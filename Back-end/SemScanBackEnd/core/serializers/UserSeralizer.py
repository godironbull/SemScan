from rest_framework import serializers
from ..models import User, UserProfile

class UserSerializer(serializers.ModelSerializer):
    bio = serializers.CharField(source='profile.bio', required=False, allow_blank=True)
    location = serializers.CharField(source='profile.location', required=False, allow_blank=True)
    name = serializers.CharField(source='first_name', required=False, allow_blank=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'first_name', 'bio', 'location', 'name']
        read_only_fields = ['id', 'username', 'email']  # Make username and email read-only

    def update(self, instance, validated_data):
        # Update User first_name
        instance.first_name = validated_data.get('first_name', instance.first_name)
        instance.save()

        # Update Profile fields
        profile, created = UserProfile.objects.get_or_create(user=instance)
        profile_data = validated_data.get('profile', {})
        
        bio = profile_data.get('bio', validated_data.get('bio', profile.bio))
        location = profile_data.get('location', validated_data.get('location', profile.location))

        profile.bio = bio
        profile.location = location
        profile.save()

        return instance