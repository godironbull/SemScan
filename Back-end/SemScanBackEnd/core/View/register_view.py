from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth.models import User
from rest_framework.authtoken.models import Token
from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError

class RegisterView(APIView):
    def post(self, request):
        username = request.data.get('username')
        email = request.data.get('email')
        password = request.data.get('password')

        if not username or not email or not password:
            return Response({'error': 'Todos os campos são obrigatórios'}, 
                          status=status.HTTP_400_BAD_REQUEST)

        # Check if email is already used as username (since we use email as username)
        if User.objects.filter(username=email).exists():
            return Response({'error': 'Este email já está cadastrado'}, 
                          status=status.HTTP_400_BAD_REQUEST)

        # Check if email is already registered
        if User.objects.filter(email=email).exists():
            return Response({'error': 'Este email já está cadastrado'}, 
                          status=status.HTTP_400_BAD_REQUEST)

        # Validate password
        try:
            validate_password(password, user=User(username=username, email=email))
        except ValidationError as e:
            # Format validation errors in Portuguese
            error_messages = []
            for error in e.messages:
                if 'at least 8 characters' in error:
                    error_messages.append('A senha deve ter pelo menos 8 caracteres')
                elif 'too similar' in error:
                    error_messages.append('A senha não pode ser muito similar ao nome de usuário')
                elif 'too common' in error:
                    error_messages.append('Esta senha é muito comum. Escolha uma senha mais segura')
                elif 'entirely numeric' in error:
                    error_messages.append('A senha não pode ser totalmente numérica')
                else:
                    error_messages.append(error)
            
            return Response({'error': '. '.join(error_messages)}, 
                          status=status.HTTP_400_BAD_REQUEST)

        user = User.objects.create_user(
            username=email,  # Use email as username for uniqueness
            email=email,
            password=password,
            first_name=username  # Save the provided name as first_name
        )

        # Profile is auto-created by signal, get it to return data
        from ..models import UserProfile
        profile, _ = UserProfile.objects.get_or_create(user=user)

        token, created = Token.objects.get_or_create(user=user)

        return Response({
            'token': token.key,
            'user_id': user.pk,
            'email': user.email,
            'username': user.username,
            'name': user.first_name,
            'bio': profile.bio or '',
            'location': profile.location or ''
        }, status=status.HTTP_201_CREATED)
