from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from .telegram_utils import send_telegram_error_notification
import traceback
from . import models
from .database import engine
from .routers import products, auth, orders
from fastapi.middleware.cors import CORSMiddleware
from starlette.middleware.sessions import SessionMiddleware
from fastapi.staticfiles import StaticFiles
import os
from sqladmin import Admin, ModelView
from sqladmin.fields import FileField
from starlette.requests import Request
from markupsafe import Markup
from .admin_auth import authentication_backend

from .database import SessionLocal
from . import crud, schemas
from .uploads_utils import save_upload_file

models.Base.metadata.create_all(bind=engine)

# Create uploads directory if it doesn't exist
os.makedirs("uploads", exist_ok=True)

# Create a default user
def create_default_user():
    db = SessionLocal()
    user = crud.get_user_by_email(db, email="admin@example.com")
    if not user:
        user_in = schemas.UserCreate(email="admin@example.com", password="password", name="Admin User")
        crud.create_user(db, user=user_in)
    db.close()

create_default_user()

app = FastAPI()

@app.exception_handler(Exception)
async def generic_exception_handler(request: Request, exc: Exception):
    error_message = f"""🚨 Unhandled Server Error 🚨

**Endpoint**: `{request.method} {request.url.path}`
**Error**: `{type(exc).__name__}: {exc}`

```
{traceback.format_exc()}
```"""
    
    send_telegram_error_notification(error_message)
    
    return JSONResponse(
        status_code=500,
        content={"detail": "Internal Server Error"},
    )


# Add session middleware
app.add_middleware(SessionMiddleware, secret_key=os.getenv("SECRET_KEY"))

admin = Admin(app, engine, authentication_backend=authentication_backend)

class UserAdmin(ModelView, model=models.User):
    column_list = [models.User.id, models.User.name, models.User.email, models.User.is_active]
    column_searchable_list = [models.User.name, models.User.email]
    column_sortable_list = [models.User.id, models.User.name, models.User.email]
    form_columns = [models.User.name, models.User.email, models.User.is_active]

class ProductAdmin(ModelView, model=models.Product):
    column_list = [models.Product.id, models.Product.name, models.Product.sku, models.Product.image_url]
    column_searchable_list = [models.Product.name, models.Product.sku]
    column_sortable_list = [models.Product.id, models.Product.name, models.Product.sku, models.Product.quantity]
    
    form_columns = [
        models.Product.name,
        models.Product.sku,
        models.Product.quantity,
        models.Product.location,
    ]
    
    form_extra_fields = {
        'image': FileField(name="Image", label="Image", base_path='uploads')
    }

    column_formatters = {
        models.Product.image_url: lambda m, a: Markup(f'<img src="{m.image_url}" height="60">') if m.image_url else '',
    }

    async def on_model_change(self, data: dict, model: any, is_created: bool, request: Request) -> None:
        upload = data.get("image")

        if upload and upload.filename:
            image_url = save_upload_file(upload)
            model.image_url = image_url

class OrderAdmin(ModelView, model=models.Order):
    column_list = [models.Order.id, models.Order.customer_name, models.Order.status]
    column_searchable_list = [models.Order.customer_name]
    column_sortable_list = [models.Order.id, models.Order.customer_name, models.Order.status]
    form_columns = [models.Order.customer_name, models.Order.status]

class OrderLineAdmin(ModelView, model=models.OrderLine):
    column_list = [models.OrderLine.id, models.OrderLine.order_id, models.OrderLine.product_id, models.OrderLine.quantity_to_pick, models.OrderLine.quantity_picked]
    column_sortable_list = [models.OrderLine.id, models.OrderLine.order_id, models.OrderLine.product_id]
    form_columns = [models.OrderLine.order, models.OrderLine.product, models.OrderLine.quantity_to_pick, models.OrderLine.quantity_picked]


admin.add_view(UserAdmin)
admin.add_view(ProductAdmin)
admin.add_view(OrderAdmin)
admin.add_view(OrderLineAdmin)


# CORS
origins = [
    "http://localhost",
    "http://localhost:8080",
    # Add your flutter web app's origin here
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.mount("/images", StaticFiles(directory="uploads"), name="images")

app.include_router(auth.router)
app.include_router(products.router)
app.include_router(orders.router)

@app.get("/test-error")
async def test_error():
    raise Exception("This is a test error for Telegram notifications.")

@app.get("/")
def read_root():
    return {"message": "Welcome to Easy Box API"}
