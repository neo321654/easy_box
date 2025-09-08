from rest_framework import serializers
from .models import User, Product, Order, OrderLine
import cloudinary.uploader

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name']

class ProductSerializer(serializers.ModelSerializer):
    image = serializers.ImageField(write_only=True, required=False)

    class Meta:
        model = Product
        fields = '__all__'

    def create(self, validated_data):
        if 'image' in validated_data:
            image = validated_data.pop('image')
            upload_result = cloudinary.uploader.upload(image)
            validated_data['image_url'] = upload_result['secure_url']
        return super().create(validated_data)

    def update(self, instance, validated_data):
        if 'image' in validated_data:
            image = validated_data.pop('image')
            upload_result = cloudinary.uploader.upload(image)
            validated_data['image_url'] = upload_result['secure_url']
        return super().update(instance, validated_data)

class OrderLineSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderLine
        fields = '__all__'

class OrderSerializer(serializers.ModelSerializer):
    lines = OrderLineSerializer(many=True, read_only=True, source='orderline_set')

    class Meta:
        model = Order
        fields = '__all__'
