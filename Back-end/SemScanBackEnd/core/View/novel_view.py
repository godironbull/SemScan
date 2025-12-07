from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from ..models import Novel
from core.serializers.NovelSeralizer import NovelSerializer

class NovelView(APIView):

    # POST /novels/
    def post(self, request):
        serializer = NovelSerializer(data=request.data)

        if serializer.is_valid():
            novel = serializer.save()  # cria o novel
            serializer = NovelSerializer(novel)  # recarrega dados completos
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    

class NovelDetailView(APIView):
    
    def delete(self, request, novel_id):
        novel = Novel.objects.get(id=novel_id)
        novel.delete()
        return Response({"msg":"novel deletada"},status=status.HTTP_200_OK)
    
    def get(self, request, novel_id=None):
        # Se NÃO recebeu novel_id => LISTA
        if novel_id is None:
            novels = Novel.objects.all()
            serializer = NovelSerializer(novels, many=True)
            return Response(serializer.data)

        # Se recebeu novel_id => DETALHE
        novel = Novel.objects.get(id=novel_id)
        serializer = NovelSerializer(novel)
        return Response(serializer.data)
    
    def patch(self, request, novel_id):
        novel = Novel.objects.get(id=novel_id)
        serializer = NovelSerializer(novel, data=request.data, partial=True)

        if serializer.is_valid():
            novel = serializer.save()
            return Response(NovelSerializer(novel).data)