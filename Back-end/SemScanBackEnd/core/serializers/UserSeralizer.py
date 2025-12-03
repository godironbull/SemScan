from rest_framework import serializers
from ..models import User, UserProfile

class UserSerializer(serializers.ModelSerializer):
    bio = serializers.CharField(source='profile.bio', required=False, allow_blank=True)
    location = serializers.CharField(source='profile.location', required=False, allow_blank=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'email', 'bio', 'location']
        read_only_fields = ['id']

    def update(self, instance, validated_data):
        # Update User fields
        instance.username = validated_data.get('username', instance.username)
        instance.email = validated_data.get('email', instance.email)
        instance.save()

        # Update Profile fields
        # Use get_or_create to handle cases where existing users don't have a profile yet
        profile, created = UserProfile.objects.get_or_create(user=instance)
        
        # DRF puts source='profile.bio' fields into validated_data['profile']['bio'] usually,
        # but since we are handling it manually and input is flat, let's check both or just rely on DRF mapping.
        # If input is flat 'bio', and field has source='profile.bio', DRF might map it to nested dict in validated_data.
        
        profile_data = validated_data.get('profile', {})
        
        # If profile_data is empty, maybe it's in root? (Unlikely with source=...)
        # But let's be safe.
        
        bio = profile_data.get('bio', validated_data.get('bio', profile.bio))
        location = profile_data.get('location', validated_data.get('location', profile.location))

        profile.bio = bio
        profile.location = location
        profile.save()

        return instance