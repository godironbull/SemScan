from django.urls import path
from core.View.user_view import UserView
from core.View.auth_view import CustomLoginView
from core.View.register_view import RegisterView

urlpatterns = [
    path('', UserView.as_view(), name='user-list-create'),
    path('<int:user_id>/', UserView.as_view(), name='user-detail'),
    path('login/', CustomLoginView.as_view(), name='user-login'),
    path('register/', RegisterView.as_view(), name='user-register'),
]
