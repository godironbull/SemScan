from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.permissions import IsAuthenticated, IsAuthenticatedOrReadOnly
from ..models import Comments, Favorite, Like, Novel, Chapter
from ..serializers.CommentSerializer import CommentSerializer
from ..serializers.FavoriteSerializer import FavoriteSerializer
from ..serializers.LikeSerializer import LikeSerializer

class CommentView(APIView):
    permission_classes = [IsAuthenticatedOrReadOnly]

    def get(self, request):
        novel_id = request.query_params.get('novel_id')
        chapter_id = request.query_params.get('chapter_id')
        
        if novel_id:
            comments = Comments.objects.filter(novel_id=novel_id).order_by('-created_at')
        elif chapter_id:
            comments = Comments.objects.filter(chapter_id=chapter_id).order_by('-created_at')
        else:
            return Response({"error": "novel_id or chapter_id required"}, status=status.HTTP_400_BAD_REQUEST)
            
        serializer = CommentSerializer(comments, many=True)
        return Response(serializer.data)

    def post(self, request):
        serializer = CommentSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=request.user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def put(self, request, pk):
        try:
            comment = Comments.objects.get(pk=pk)
            if comment.user != request.user:
                return Response({'error': 'Not authorized'}, status=status.HTTP_403_FORBIDDEN)
            serializer = CommentSerializer(comment, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Comments.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

    def delete(self, request, pk):
        try:
            comment = Comments.objects.get(pk=pk)
            if comment.user != request.user:
                return Response({'error': 'Not authorized'}, status=status.HTTP_403_FORBIDDEN)
            comment.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Comments.DoesNotExist:
            return Response(status=status.HTTP_404_NOT_FOUND)

class FavoriteView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        favorites = Favorite.objects.filter(user=request.user)
        # Assuming frontend wants simple list of story IDs to check "isSaved"
        # Or structured data. StoryProvider calls '/favorites/'.
        # StoryProvider.fetchFavorites maps response to list of story_ids.
        # Line 209: _savedStoryIds.addAll(data.map((e) => e['story_id'].toString()));
        # So I should return objects with 'story_id' key.
        data = [{'id': f.id, 'story_id': f.novel.id} for f in favorites]
        return Response(data)

    def post(self, request):
        novel_id = request.data.get('story_id')
        if not novel_id:
             novel_id = request.data.get('novel_id')
             
        if not novel_id:
             return Response({'error': 'novel_id/story_id required'}, status=status.HTTP_400_BAD_REQUEST)

        # Check if already exists
        if Favorite.objects.filter(user=request.user, novel_id=novel_id).exists():
            return Response({'message': 'Already favorited'}, status=status.HTTP_200_OK)

        favorite = Favorite.objects.create(user=request.user, novel_id=novel_id)
        # StoryProvider expects response['id'] if needed? 
        # Actually it just checks response != null in fetchFavorites.
        # But toggleStorySaved ignores return value mostly, just relying on success.
        return Response({'id': favorite.id, 'story_id': favorite.novel.id}, status=status.HTTP_201_CREATED)

    def delete(self, request, pk):
        # pk is expected to be novel_id based on StoryProvider behavior:
        # await ApiService.delete('/favorites/$id/', requiresAuth: true);
        # where $id is widget.storyId.
        try:
            favorite = Favorite.objects.get(user=request.user, novel_id=pk)
            favorite.delete()
            return Response(status=status.HTTP_204_NO_CONTENT)
        except Favorite.DoesNotExist:
             # It's possible the user sends favorite ID instead of novel ID?
             # No, the frontend code explicitly sends storyId.
             return Response({'error': 'Not found'}, status=status.HTTP_404_NOT_FOUND)

class LikeView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, novel_id=None, chapter_id=None):
        if novel_id:
            count = Like.objects.filter(novel_id=novel_id).count()
            liked = Like.objects.filter(user=request.user, novel_id=novel_id).exists()
        elif chapter_id:
            count = Like.objects.filter(chapter_id=chapter_id).count()
            liked = Like.objects.filter(user=request.user, chapter_id=chapter_id).exists()
        else:
            return Response({'error': 'ID required'}, status=status.HTTP_400_BAD_REQUEST)
            
        return Response({'count': count, 'liked': liked})

    def post(self, request, novel_id=None, chapter_id=None):
        if novel_id:
            if Like.objects.filter(user=request.user, novel_id=novel_id).exists():
                Like.objects.filter(user=request.user, novel_id=novel_id).delete()
                liked = False
            else:
                Like.objects.create(user=request.user, novel_id=novel_id)
                liked = True
        elif chapter_id:
            if Like.objects.filter(user=request.user, chapter_id=chapter_id).exists():
                Like.objects.filter(user=request.user, chapter_id=chapter_id).delete()
                liked = False
            else:
                Like.objects.create(user=request.user, chapter_id=chapter_id)
                liked = True
        else:
            return Response({'error': 'ID required'}, status=status.HTTP_400_BAD_REQUEST)

        return Response({'liked': liked})
