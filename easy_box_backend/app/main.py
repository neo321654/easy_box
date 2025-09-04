from fastapi import FastAPI
from . import models
from .database import engine
from .routers import products, auth, orders
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
import os

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
