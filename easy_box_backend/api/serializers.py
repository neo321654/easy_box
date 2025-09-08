from rest_framework import serializers, exceptions
from django.contrib.auth import authenticate
from .models import User, Product, Order, OrderLine
import cloudinary.uploader

class CustomAuthTokenSerializer(serializers.Serializer):
    email = serializers.EmailField()
    password = serializers.CharField(style={'input_type': 'password'})

    def validate(self, attrs):
        email = attrs.get('email')
        password = attrs.get('password')

        if email and password:
            user = authenticate(request=self.context.get('request'),
                                username=email, password=password)

            if not user:
                msg = 'Unable to log in with provided credentials.'
                raise exceptions.ValidationError(msg, code='authorization')

        else:
            msg = 'Must include "email" and "password".'
            raise exceptions.ValidationError(msg, code='authorization')

        attrs['user'] = user
        return attrs

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'last_name']

class ProductSerializer(serializers.ModelSerializer):
    class Meta:
        model = Product
        fields = '__all__'

class OrderLineSerializer(serializers.ModelSerializer):
    product = serializers.PrimaryKeyRelatedField(queryset=Product.objects.all())

    class Meta:
        model = OrderLine
        fields = ['product', 'quantity_to_pick']

class OrderSerializer(serializers.ModelSerializer):
    lines = OrderLineSerializer(many=True, source='orderline_set')

    class Meta:
        model = Order
        fields = '__all__'

    def create(self, validated_data):
        lines_data = validated_data.pop('orderline_set')
        order = Order.objects.create(**validated_data)
        for line_data in lines_data:
            OrderLine.objects.create(order=order, **line_data)
        return order

    def update(self, instance, validated_data):
        lines_data = validated_data.get('lines')
        instance.customer_name = validated_data.get('customer_name', instance.customer_name)
        instance.status = validated_data.get('status', instance.status)
        instance.save()

        if lines_data:
            OrderLine.objects.filter(order=instance).delete()
            for line_data in lines_data:
                OrderLine.objects.create(order=instance, **line_data)

        return instance
