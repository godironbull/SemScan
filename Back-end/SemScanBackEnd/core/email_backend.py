from django.contrib.auth.backends import ModelBackend
from django.contrib.auth.models import User

class EmailBackend(ModelBackend):
    """
    Custom authentication backend that allows users to authenticate
    using either username or email address.
    """
    def authenticate(self, request, username=None, password=None, **kwargs):
        try:
            # Try to fetch the user by email first
            user = User.objects.get(email=username)
        except User.DoesNotExist:
            # If email doesn't work, try username
            try:
                user = User.objects.get(username=username)
            except User.DoesNotExist:
                return None
        
        # Check the password
        if user.check_password(password):
            return user
        return None
