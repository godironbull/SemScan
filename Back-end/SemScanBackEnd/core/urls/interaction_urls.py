from django.urls import path
from ..View.interaction_view import CommentView, FavoriteView, LikeView

urlpatterns = [
    # Comments
    path('comments/', CommentView.as_view(), name='comments'),
    path('comments/<int:pk>/', CommentView.as_view(), name='comment-detail'), 
    
    # Favorites
    path('favorites/', FavoriteView.as_view(), name='favorites'),
    path('favorites/<int:pk>/', FavoriteView.as_view(), name='favorite-detail'), 

    # Likes
    path('novels/<int:novel_id>/like/', LikeView.as_view(), name='novel-like'),
    path('chapters/<int:chapter_id>/like/', LikeView.as_view(), name='chapter-like'),
]
