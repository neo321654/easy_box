from django.contrib import admin
from .models import User, Product, Order, OrderLine
from django.utils.html import format_html

@admin.register(Product)
class ProductAdmin(admin.ModelAdmin):
    list_display = ('name', 'sku', 'quantity', 'location', 'image_thumbnail')
    readonly_fields = ('image_thumbnail',)

    def image_thumbnail(self, obj):
        if obj.thumbnail:
            return format_html(f'<img src="{obj.thumbnail.url}" width="100" />')
        if obj.image:
            return format_html(f'<img src="{obj.image.url}" width="100" />')
        return "No Image"
    image_thumbnail.short_description = 'Thumbnail'

admin.site.register(User)
admin.site.register(Order)
admin.site.register(OrderLine)
