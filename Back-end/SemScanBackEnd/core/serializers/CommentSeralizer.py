from rest_framework import serializers
from ..models import Comments, Novel

class CommentSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(read_only=True)
    novel = serializers.PrimaryKeyRelatedField(queryset=Novel.objects.all())

    class Meta:
        model = Comments
        fields = ["id", "content","novel","user"]