from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from ..models import Chapter
from core.serializers.ChapterSeralizer import ChapterSerializer


class ChapterView(APIView):
    def get(self, request, chapter_id):
        try:
            chapter = Chapter.objects.get(id=chapter_id)
            serializer = ChapterSerializer(chapter)
            return Response(serializer.data, status=status.HTTP_200_OK)
        except Chapter.DoesNotExist:
            return Response({"error": "Chapter not found"}, status=status.HTTP_404_NOT_FOUND)
    def post(self, request):
        serializer = ChapterSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
    def delete(self, request,chapter_id):
        try:
            chapter = Chapter.objects.get(id=chapter_id)
            chapter.delete()
            return Response({"message": "Chapter deleted"}, status=status.HTTP_200_OK)
        except Chapter.DoesNotExist:
            return Response({"error": "Chapter not found"}, status=status.HTTP_404_NOT_FOUND)
    def patch(self, request,chapter_id):
        try:
            chapter = Chapter.objects.get(id=chapter_id)
            serializer = ChapterSerializer(chapter, data=request.data, partial=True)
            if serializer.is_valid():
                serializer.save()
                return Response(serializer.data, status=status.HTTP_200_OK)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        except Chapter.DoesNotExist:
            return Response({"error": "Chapter not found"}, status=status.HTTP_404_NOT_FOUND)