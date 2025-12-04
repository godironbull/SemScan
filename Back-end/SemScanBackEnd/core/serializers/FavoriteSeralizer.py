from rest_framework import serializers
from ..models import Favorite, Novel, User
class FavoriteSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())
    novel = serializers.PrimaryKeyRelatedField(queryset=Novel.objects.all())

    class Meta:
        model = Favorite
        fields = ["id", "user", "novel"]