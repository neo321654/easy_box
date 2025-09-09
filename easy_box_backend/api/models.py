from django.db import models
from django.contrib.auth.models import AbstractUser
from django.utils.translation import gettext_lazy as _

class User(AbstractUser):
    email = models.EmailField(unique=True, blank=False)
    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

    class Meta(AbstractUser.Meta):
        verbose_name = 'Пользователь'
        verbose_name_plural = 'Пользователи'

class OrderStatus(models.TextChoices):
    OPEN = 'open', _('Открыт')
    IN_PROGRESS = 'inProgress', _('В процессе')
    PICKED = 'picked', _('Собран')
    CANCELLED = 'cancelled', _('Отменен')

class Product(models.Model):
    name = models.CharField("Название", max_length=255)
    sku = models.CharField("Артикул", max_length=100, unique=True)
    quantity = models.IntegerField("Количество")
    location = models.CharField("Местоположение", max_length=100, blank=True, null=True)
    image_url = models.CharField("URL изображения", max_length=2048, blank=True, null=True)
    thumbnail_url = models.CharField("URL миниатюры", max_length=2048, blank=True, null=True)

    class Meta:
        verbose_name = "Товар"
        verbose_name_plural = "Товары"

    def __str__(self):
        return f"SKU: {self.sku} | {self.name}"

class Order(models.Model):
    customer_name = models.CharField("Имя клиента", max_length=255)
    status = models.CharField(
        "Статус",
        max_length=20,
        choices=OrderStatus.choices,
        default=OrderStatus.OPEN,
    )
    lines = models.ManyToManyField(Product, through='OrderLine', verbose_name="Строки заказа")

    class Meta:
        verbose_name = "Заказ"
        verbose_name_plural = "Заказы"

    def __str__(self):
        return f"Order #{self.id} - {self.customer_name}"

class OrderLine(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, verbose_name="Заказ")
    product = models.ForeignKey(Product, on_delete=models.CASCADE, verbose_name="Товар")
    quantity_to_pick = models.IntegerField("Количество для сборки")
    quantity_picked = models.IntegerField("Собранное количество", default=0)

    class Meta:
        verbose_name = "Строка заказа"
        verbose_name_plural = "Строки заказа"
