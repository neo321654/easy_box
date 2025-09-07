from sqlalchemy import Boolean, Column, Integer, String, Enum, ForeignKey
from sqlalchemy.orm import relationship
from .database import Base
import enum

class OrderStatus(enum.Enum):
    open = "open"
    inProgress = "inProgress"
    picked = "picked"
    cancelled = "cancelled"

class User(Base):
    __tablename__ = "users"

    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True, nullable=False)
    name = Column(String)
    hashed_password = Column(String, nullable=False)
    is_active = Column(Boolean, default=True)

class Product(Base):
    __tablename__ = "products"

    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True, nullable=False)
    sku = Column(String, unique=True, index=True, nullable=False)
    quantity = Column(Integer, nullable=False)
    location = Column(String, nullable=True)
    image_url = Column(String, nullable=True)

    order_lines = relationship("OrderLine", back_populates="product")

    def __str__(self) -> str:
        return f"SKU: {self.sku} | {self.name}"


class Order(Base):
    __tablename__ = "orders"

    id = Column(Integer, primary_key=True, index=True)
    customer_name = Column(String, index=True)
    status = Column(Enum(OrderStatus), nullable=False)
    
    lines = relationship("OrderLine", back_populates="order")

    def __str__(self) -> str:
        return f"Order #{self.id} - {self.customer_name}"


class OrderLine(Base):
    __tablename__ = "order_lines"

    id = Column(Integer, primary_key=True, index=True)
    order_id = Column(Integer, ForeignKey("orders.id"))
    product_id = Column(Integer, ForeignKey("products.id"))
    quantity_to_pick = Column(Integer, nullable=False)
    quantity_picked = Column(Integer, default=0)

    order = relationship("Order", back_populates="lines")
    product = relationship("Product", back_populates="order_lines")
