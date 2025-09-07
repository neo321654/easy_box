from fastapi import FastAPI
from . import models
from .database import engine
from .routers import products, auth, orders
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
import os
from sqladmin import Admin, ModelView

from .database import SessionLocal
from . import crud, schemas

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
admin = Admin(app, engine)

class UserAdmin(ModelView, model=models.User):
    column_list = [models.User.id, models.User.name, models.User.email, models.User.is_active]
    column_searchable_list = [models.User.name, models.User.email]
    column_sortable_list = [models.User.id, models.User.name, models.User.email]
    form_columns = [models.User.name, models.User.email, models.User.is_active]

class ProductAdmin(ModelView, model=models.Product):
    column_list = [models.Product.id, models.Product.name, models.Product.sku, models.Product.quantity, models.Product.location]
    column_searchable_list = [models.Product.name, models.Product.sku]
    column_sortable_list = [models.Product.id, models.Product.name, models.Product.sku, models.Product.quantity]
    form_columns = [models.Product.name, models.Product.sku, models.Product.quantity, models.Product.location, models.Product.image_url]

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

@app.get("/")
def read_root():
    return {"message": "Welcome to Easy Box API"}

# Trivial change to trigger deployment
