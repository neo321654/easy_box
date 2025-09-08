from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.authtoken.models import Token
from rest_framework.response import Response
from .models import User, Product, Order, OrderLine
from .serializers import UserSerializer, ProductSerializer, OrderSerializer, OrderLineSerializer, CustomAuthTokenSerializer
import cloudinary.uploader

class CustomObtainAuthToken(ObtainAuthToken):
    serializer_class = CustomAuthTokenSerializer

    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data,
                                           context={'request': request})
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        token, created = Token.objects.get_or_create(user=user)
        return Response({'token': token.key})

class UserViewSet(viewsets.ModelViewSet):
    queryset = User.objects.all()
    serializer_class = UserSerializer

    @action(detail=False, methods=['get'])
    def me(self, request):
        serializer = self.get_serializer(request.user, many=False)
        return Response(serializer.data)

class ProductViewSet(viewsets.ModelViewSet):
    queryset = Product.objects.all()
    serializer_class = ProductSerializer
    parser_classes = [MultiPartParser, FormParser]

    @action(detail=True, methods=['post'])
    def add_stock(self, request, pk=None):
        product = self.get_object()
        quantity = request.data.get('quantity')
        if quantity is None:
            return Response({'error': 'Quantity not provided'}, status=400)
        product.quantity += int(quantity)
        product.save()
        serializer = self.get_serializer(product)
        return Response(serializer.data)

    @action(detail=True, methods=['post'], parser_classes=[MultiPartParser, FormParser])
    def upload_image(self, request, pk=None):
        product = self.get_object()
        image = request.data.get('image')
        if not image:
            return Response({'error': 'No image provided'}, status=400)

        try:
            upload_result = cloudinary.uploader.upload(
                image,
                transformation={"width": 150, "height": 150, "crop": "thumb"}
            )
            product.image_url = upload_result['secure_url']
            product.thumbnail_url = cloudinary.CloudinaryImage(upload_result['public_id']).build_url(transformation={"width": 150, "height": 150, "crop": "thumb"})
            product.save()

            serializer = self.get_serializer(product)
            return Response(serializer.data)
        except Exception as e:
            return Response({'error': str(e)}, status=500)

class OrderViewSet(viewsets.ModelViewSet):
    queryset = Order.objects.all()
    serializer_class = OrderSerializer

class OrderLineViewSet(viewsets.ModelViewSet):
    queryset = OrderLine.objects.all()
    serializer_class = OrderLineSerializer