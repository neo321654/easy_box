from django.db import models
from django.contrib.auth.models import AbstractUser
from django.conf import settings
from django.db.models.signals import post_save
from django.dispatch import receiver
from rest_framework.authtoken.models import Token
from cloudinary.models import CloudinaryField

class User(AbstractUser):
    email = models.EmailField(unique=True, blank=False)
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

class OrderStatus(models.TextChoices):
    OPEN = 'open', 'Open'
    IN_PROGRESS = 'inProgress', 'In Progress'
    PICKED = 'picked', 'Picked'
    CANCELLED = 'cancelled', 'Cancelled'

class Product(models.Model):
    name = models.CharField(max_length=255)
    sku = models.CharField(max_length=100, unique=True)
    quantity = models.IntegerField()
    location = models.CharField(max_length=100, blank=True, null=True)
    image = CloudinaryField('image', blank=True, null=True)

    def __str__(self):
        return f"SKU: {self.sku} | {self.name}"

    @property
    def image_url(self):
        if self.image:
            return self.image.build_url(transformation=[{'width': 400, 'height': 400, 'crop': 'limit'}])
        return None

    @property
    def thumbnail_url(self):
        if self.image:
            return self.image.build_url(transformation=[{'width': 100, 'height': 100, 'crop': 'thumb'}])
        return None

class Order(models.Model):
    customer_name = models.CharField(max_length=255)
    status = models.CharField(
        max_length=20,
        choices=OrderStatus.choices,
        default=OrderStatus.OPEN,
    )
    lines = models.ManyToManyField(Product, through='OrderLine')

    def __str__(self):
        return f"Order #{self.id} - {self.customer_name}"

class OrderLine(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    quantity_to_pick = models.IntegerField()
    quantity_picked = models.IntegerField(default=0)

@receiver(post_save, sender=settings.AUTH_USER_MODEL)
def create_auth_token(sender, instance=None, created=False, **kwargs):
    if created:
        Token.objects.create(user=instance)

# Trigger deployment
# Trigger deployment again