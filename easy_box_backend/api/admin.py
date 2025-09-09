from django.contrib import admin
from .models import User, Product, Order, OrderLine
from django import forms
import cloudinary.uploader
from django.utils.html import format_html

class ProductAdminForm(forms.ModelForm):
    image = forms.ImageField(label='Изображение', required=False)

    class Meta:
        model = Product
        fields = '__all__'

class ProductAdmin(admin.ModelAdmin):
    form = ProductAdminForm
    list_display = ('name', 'sku', 'quantity', 'location', 'image_thumbnail')

    def image_thumbnail(self, obj):
        if obj.thumbnail_url:
            return format_html(f'<img src="{obj.thumbnail_url}" width="100" />')
        return "Нет изображения"
    image_thumbnail.short_description = 'Миниатюра'

    def save_model(self, request, obj, form, change):
        if 'image' in form.cleaned_data and form.cleaned_data['image']:
            image = form.cleaned_data['image']
            upload_result = cloudinary.uploader.upload(
                image,
                transformation={"width": 150, "height": 150, "crop": "thumb"}
            )
            obj.image_url = upload_result['secure_url']
            obj.thumbnail_url = cloudinary.CloudinaryImage(upload_result['public_id']).build_url(transformation={"width": 150, "height": 150, "crop": "thumb"})
        super().save_model(request, obj, form, change)

admin.site.register(User)
admin.site.register(Product, ProductAdmin)
admin.site.register(Order)
admin.site.register(OrderLine)
