from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from ..models import Favorite
from ..serializers.FavoriteSeralizer import FavoriteSerializer  # Ajuste o caminho se necessário


class NovelsFavoritarView(APIView):

    def post(self, request):
        serializer = FavoriteSerializer(data=request.data)

        if serializer.is_valid():
            serializer.save()
            return Response(
                {"msg": "Favorite criada com sucesso!"},
                status=status.HTTP_201_CREATED
            )

        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def get(self, request, user_id=None):
        if user_id is None:
            return Response(
                {"error": "user_id é obrigatório na requisição"},
                status=status.HTTP_400_BAD_REQUEST
            )

        favorites = Favorite.objects.filter(user_id=user_id)
        favorites_list = [fav.to_dict() for fav in favorites]

        return Response(favorites_list, status=status.HTTP_200_OK)


class NovelsFavoritarDetailView(APIView):

    def delete(self, request, user_id, novel_id):
        try:
            favorite = Favorite.objects.get(user_id=user_id, novel_id=novel_id)
            favorite.delete()
            return Response(
                {"msg": "Favorite deletada com sucesso!"},
                status=status.HTTP_200_OK
            )

        except Favorite.DoesNotExist:
            return Response(
                {"error": "Favorite não encontrada."},
                status=status.HTTP_404_NOT_FOUND
            )
