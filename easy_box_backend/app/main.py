from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from .telegram_utils import send_telegram_error_notification, TelegramLogHandler
import traceback
import logging
import sys
from . import models
from .database import engine
from .routers import products, auth, orders
from fastapi.middleware.cors import CORSMiddleware
from starlette.middleware.sessions import SessionMiddleware
import os
from sqladmin import Admin, ModelView
from sqladmin.fields import FileField
from starlette.requests import Request
from markupsafe import Markup
from pydantic import BaseModel
from .admin_auth import authentication_backend
import cloudinary
from dotenv import load_dotenv

from .database import SessionLocal
from . import crud, schemas
from .uploads_utils import save_upload_file

# Load environment variables from .env file
load_dotenv()

# Configure Cloudinary
cloudinary.config(
  cloud_name = os.getenv("CLOUDINARY_CLOUD_NAME"),
  api_key = os.getenv("CLOUDINARY_API_KEY"),
  api_secret = os.getenv("CLOUDINARY_API_SECRET"),
  secure = True
)


models.Base.metadata.create_all(bind=engine)

# Create a default user
def create_default_user():
    db = SessionLocal()
    user = crud.get_user_by_email(db, email="admin@example.com")
    if not user:
        user_in = schemas.UserCreate(email="admin@example.com", password="password", name="Admin User")
        crud.create_user(db, user=user_in)
    db.close()

create_default_user()

# Configure logging
# Create a dedicated logger for the application
log = logging.getLogger("easybox_app")
log.setLevel(logging.INFO) # Set a base level

# Create a handler for console output
import sys
console_handler = logging.StreamHandler(sys.stdout)
console_handler.setLevel(logging.INFO)
console_formatter = logging.Formatter('%(asctime)s - %(name)s - %(levelname)s - %(message)s')
console_handler.setFormatter(console_formatter)
log.addHandler(console_handler)

# Create and add the Telegram handler for critical errors
telegram_handler = TelegramLogHandler()
telegram_handler.setLevel(logging.ERROR)
telegram_formatter = logging.Formatter('🚨 **EasyBox Server Error** 🚨\n\n' \
                                     '**Level**: `%(levelname)s`\n' \
                                     '**Path**: `%(pathname)s:%(lineno)d`\n' \
                                     '**Message**: `%(message)s`')
telegram_handler.setFormatter(telegram_formatter)
log.addHandler(telegram_handler)

# Prevent the logger from propagating to the root logger
log.propagate = False

app = FastAPI()


@app.middleware("http")
async def log_exceptions_middleware(request: Request, call_next):
    try:
        return await call_next(request)
    except Exception as e:
        # Log the exception with traceback
        log.error(f"Unhandled exception for {request.method} {request.url.path}", exc_info=True)
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
        'image': FileField(name="Image", label="Image")
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



app.include_router(auth.router)
app.include_router(products.router)
app.include_router(orders.router)

class ClientLog(BaseModel):
    message: str

@app.post("/log-client-error")
async def log_client_error(log: ClientLog):
    formatted_message = f"📱 **Client-Side Error** 📱\n\n{log.message}"
    send_telegram_error_notification(formatted_message)
    return {"status": "logged"}

@app.post("/log-client-error")
async def log_client_error(log: ClientLog):
    formatted_message = f"📱 **Client-Side Error** 📱\n\n{log.message}"
    send_telegram_error_notification(formatted_message)
    return {"status": "logged"}

@app.get("/test-error")
async def test_error():
    raise Exception("This is a test error for Telegram notifications.")

@app.get("/")
def read_root():
    return {"message": "Welcome to Easy Box API"}

# Re-deploy test to verify image persistence

# Triggering diagnostic deployment