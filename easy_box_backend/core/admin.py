from django import forms
from django.contrib import admin
from .models import User, Product, Order, OrderLine

class ProductAdminForm(forms.ModelForm):
    class Meta:
        model = Product
        fields = '__all__'

class ProductAdmin(admin.ModelAdmin):
    form = ProductAdminForm
    list_display = ('sku', 'name', 'quantity', 'location')
    search_fields = ('sku', 'name')

class OrderLineInline(admin.TabularInline):
    model = OrderLine
    extra = 1

class OrderAdmin(admin.ModelAdmin):
    list_display = ('id', 'customer_name', 'status')
    list_filter = ('status',)
    inlines = [OrderLineInline]

admin.site.register(User)
admin.site.register(Product, ProductAdmin)
admin.site.register(Order, OrderAdmin)