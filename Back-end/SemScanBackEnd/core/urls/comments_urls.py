from django.urls import path
from ..View.Comments_View import  CommentsView

urlpatterns = [
    path('', CommentsView.as_view(), name='chapter-list-create'),  # GET (lista) / POST (cria)
    path('<int:novel>/', CommentsView.as_view(), name='chapter-detail'),  # GET / PATCH / DELETE por id
]
