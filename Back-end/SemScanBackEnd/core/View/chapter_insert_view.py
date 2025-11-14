from rest_framework import status
from ..models import Chapter, Novel
from core.serializers.NovelSeralizer import NovelSerializer
from rest_framework.views import APIView, Response
class ChapterInsertView(APIView):
    
    def post(self, request, novel_id, chapter_id):
        try:
            novel = Novel.objects.get(id=novel_id)
        except Novel.DoesNotExist:
            return Response({'error': 'Novel not found'}, status=status.HTTP_404_NOT_FOUND)
        
        try:
            chapter = Chapter.objects.get(id=chapter_id)
        except Chapter.DoesNotExist:
            return Response({'error': 'Chapter not found'}, status=status.HTTP_404_NOT_FOUND)
        
        novel.insert_chapter(chapter)
        serializer = NovelSerializer(novel)
        return Response(serializer.data, status=status.HTTP_200_OK)