from django.urls import path
from core.View.novels_favoritar_view import NovelsFavoritarView , NovelsFavoritarDetailView
urlpatterns = [
    path('', NovelsFavoritarView.as_view(), name='chapter-list-create'),  # GET (lista) / POST (cria)
    path('<int:user_id>/', NovelsFavoritarView.as_view(), name='chapter-detail'),  # GET 
    path("<int:user_id>/<int:novel_id>/", NovelsFavoritarDetailView.as_view(), name='chapter-delete')  # DELETE
]
