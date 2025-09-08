from django.contrib import admin
from .models import User, Product, Order, OrderLine

admin.site.register(User)
admin.site.register(Product)
admin.site.register(Order)
admin.site.register(OrderLine)