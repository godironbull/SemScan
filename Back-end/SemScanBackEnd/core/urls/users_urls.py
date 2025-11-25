from django.urls import path
from core.View.user_view import UserView

urlpatterns = [
    path('', UserView.as_view(), name='chapter-list-create'),  # GET (lista) / POST (cria)
    path('<int:user_id>/', UserView.as_view(), name='chapter-detail'),  # GET / PATCH / DELETE por id
]
