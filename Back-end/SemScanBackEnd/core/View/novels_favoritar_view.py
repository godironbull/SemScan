from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from ..models import Favorite as NovelsFavoritar
class NovelsFavoritarView(APIView):

    def post(self, request):
        
        NovelsFavoritar.objects.create(**request.data)
        return Response({"msg":"NovelsFavoritar criada com sucesso!"}, 
                        status=status.HTTP_201_CREATED)
    
    def get(self, request,user_id=None):
        novels=NovelsFavoritar.objects.filter(user_id=user_id)
        novels_list=[novel.to_dict() for novel in novels]
        return Response(novels_list, status=status.HTTP_200_OK)
    
    
class NovelsFavoritarDetailView(APIView):

    def delete(self, request, user_id, novel_id):
        try:
            favorite = NovelsFavoritar.objects.get(user_id=user_id, novel_id=novel_id)
            favorite.delete()
            return Response({"msg":"NovelsFavoritar deletada com sucesso!"}, 
                            status=status.HTTP_200_OK)
        except NovelsFavoritar.DoesNotExist:
            return Response({"error":"NovelsFavoritar não encontrada."}, 
                            status=status.HTTP_404_NOT_FOUND)