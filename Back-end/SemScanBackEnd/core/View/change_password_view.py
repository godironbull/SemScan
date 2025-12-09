from django.contrib.auth.password_validation import validate_password
from django.core.exceptions import ValidationError
from rest_framework import status
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework.views import APIView


class ChangePasswordView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request):
        user = request.user
        current_password = request.data.get('current_password')
        new_password = request.data.get('new_password')

        if not current_password or not new_password:
            return Response(
                {'error': 'Informe a senha atual e a nova senha'},
                status=status.HTTP_400_BAD_REQUEST,
            )

        if not user.check_password(current_password):
            return Response(
                {'error': 'Senha atual incorreta'},
                status=status.HTTP_400_BAD_REQUEST,
            )

        # Validate the new password using Django's validators
        try:
            validate_password(new_password, user=user)
        except ValidationError as e:
            # Translate common validation messages to Portuguese, similar to register_view
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

            return Response(
                {'error': '. '.join(error_messages)},
                status=status.HTTP_400_BAD_REQUEST,
            )

        user.set_password(new_password)
        user.save()

        return Response(
            {'success': True, 'message': 'Senha alterada com sucesso'},
            status=status.HTTP_200_OK,
        )

