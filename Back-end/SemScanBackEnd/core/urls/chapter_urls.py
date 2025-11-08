from django.urls import path
from ..View.chapter_view import ChapterView

urlpatterns = [
    path('', ChapterView.as_view(), name='chapter-list-create'),  # GET (lista) / POST (cria)
    path('<int:chapter_id>/', ChapterView.as_view(), name='chapter-detail'),  # GET / PATCH / DELETE por id
]
