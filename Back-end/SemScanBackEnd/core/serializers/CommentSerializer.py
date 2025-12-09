from rest_framework import serializers
from ..models import Comments, Novel, Chapter

class CommentSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(read_only=True)
    username = serializers.CharField(source='user.username', read_only=True)
    novel = serializers.PrimaryKeyRelatedField(queryset=Novel.objects.all(), required=False, allow_null=True)
    chapter = serializers.PrimaryKeyRelatedField(queryset=Chapter.objects.all(), required=False, allow_null=True)

    class Meta:
        model = Comments
        fields = ["id", "content", "novel", "chapter", "user", "username", "created_at"]
