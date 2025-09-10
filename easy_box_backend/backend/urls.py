from django.contrib import admin
from django.urls import path, include
from core.views import CustomObtainAuthToken

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/', include('core.urls')),
    path('api/auth/token/', CustomObtainAuthToken.as_view())
]
