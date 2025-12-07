from django.urls import path
from core.View.novel_view import NovelView , NovelDetailView
from  core.View.chapter_insert_view import ChapterInsertView
urlpatterns = [
    path('', NovelView.as_view(), name='chapter-list-create'),  # GET (lista) / POST (cria)
    path('<int:novel_id>/', NovelDetailView.as_view(), name='chapter-detail'),  # GET / PATCH / DELETE por id
    path('<int:novel_id>/insert/<int:chapter_id>/', ChapterInsertView.as_view(), name='chapter-insert')
]
