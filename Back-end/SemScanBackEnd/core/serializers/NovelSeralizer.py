from rest_framework import serializers
from ..models import Novel
from .ChapterSeralizer import ChapterSerializer
class NovelSerializer(serializers.ModelSerializer):
    chapters = ChapterSerializer(many=True, read_only=True)
    class Meta:
        model = Novel
        fields = "__all__"