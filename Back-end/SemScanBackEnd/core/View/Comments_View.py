from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from ..models import Comments, Novel, User
from core.serializers.CommentSeralizer import CommentSerializer

class CommentsView(APIView):
    
    def post(self, request):
        

        novel_id = request.data.get("novel")
        user_id = request.data.get("user")
        try:
            novel = Novel.objects.get(id=novel_id)
            user= User.objects.get(id=user_id)
        except Novel.DoesNotExist:
            return Response({"error": "Novel not found"}, status=status.HTTP_404_NOT_FOUND)

        serializer = CommentSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=user, novel=novel)  # ✅ Agora salva com FK correto
            return Response({"msg": "Comentário criado com sucesso!"}, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def get(self, request, novel):
        try:
            comments = Comments.objects.filter(novel=novel)
        except Comments.DoesNotExist:
            return Response({'error': 'Chapter not found'}, status=status.HTTP_404_NOT_FOUND)
        
        
        serializer = CommentSerializer(comments, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)