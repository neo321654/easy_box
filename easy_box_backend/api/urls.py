from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import UserViewSet, ProductViewSet, OrderViewSet, OrderLineViewSet, CustomObtainAuthToken

router = DefaultRouter()
router.register(r'users', UserViewSet)
router.register(r'products', ProductViewSet)
router.register(r'orders', OrderViewSet)
router.register(r'orderlines', OrderLineViewSet)

urlpatterns = [
    path('', include(router.urls)),
    path('auth/token/', CustomObtainAuthToken.as_view())
]
