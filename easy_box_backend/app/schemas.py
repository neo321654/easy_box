from pydantic import BaseModel
from typing import List, Optional
from .models import OrderStatus

# Product
class ProductBase(BaseModel):
    name: str
    sku: str
    quantity: int
    location: Optional[str] = None
    image_url: Optional[str] = None

class ProductCreate(ProductBase):
    pass

class ProductUpdate(BaseModel):
    name: Optional[str] = None
    sku: Optional[str] = None
    quantity: Optional[int] = None
    location: Optional[str] = None
    image_url: Optional[str] = None

class Product(ProductBase):
    id: int

    class Config:
        from_attributes = True

# OrderLine
class OrderLineBase(BaseModel):
    product_id: int
    quantity_to_pick: int
    quantity_picked: int = 0

class OrderLineCreate(OrderLineBase):
    pass

class OrderLine(OrderLineBase):
    id: int
    product: Product

    class Config:
        from_attributes = True

# Order
class OrderBase(BaseModel):
    customer_name: str
    status: OrderStatus

class OrderCreate(OrderBase):
    lines: List[OrderLineCreate]

class OrderUpdate(BaseModel):
    status: Optional[OrderStatus] = None
    lines: Optional[List[OrderLineCreate]] = None

class Order(OrderBase):
    id: int
    lines: List[OrderLine] = []

    class Config:
        from_attributes = True

# User
class UserBase(BaseModel):
    email: str
    name: Optional[str] = None

class UserCreate(UserBase):
    password: str

class User(UserBase):
    id: int
    is_active: bool

    class Config:
        from_attributes = True

# Token
class Token(BaseModel):
    access_token: str
    token_type: str

class TokenData(BaseModel):
    email: Optional[str] = None
