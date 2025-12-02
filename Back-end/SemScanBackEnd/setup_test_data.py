import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'SemScanBackEnd.settings')
django.setup()

from django.contrib.auth import get_user_model
from core.models import Novel, User as CustomUser

def create_test_data():
    User = get_user_model()
    
    # Create Test User
    email = 'teste@semscan.com'
    password = 'password123'
    
    if not User.objects.filter(email=email).exists():
        user = User.objects.create_user(username=email, email=email, password=password)
        user.name = 'Usuário Teste'
        user.save()
        print(f'User created: {email} / {password}')
    else:
        print(f'User already exists: {email}')

    # Create Test Novels
    novels_data = [
        {
            'title': 'O Começo do Fim',
            'author': 'Autor Desconhecido',
            'synopsis': 'Uma história emocionante sobre o fim dos tempos.',
            'cover_image_url': 'https://picsum.photos/200/300?random=100',
            'status': 'Publicado',
            'categories': ['Ação', 'Drama']
        },
        {
            'title': 'A Jornada do Herói',
            'author': 'João Silva',
            'synopsis': 'Um jovem descobre poderes incríveis.',
            'cover_image_url': 'https://picsum.photos/200/300?random=101',
            'status': 'Publicado',
            'categories': ['Fantasia', 'Aventura']
        },
        {
            'title': 'Romance de Verão',
            'author': 'Maria Souza',
            'synopsis': 'Um amor que dura apenas um verão.',
            'cover_image_url': 'https://picsum.photos/200/300?random=102',
            'status': 'Publicado',
            'categories': ['Romance']
        }
    ]

    for data in novels_data:
        if not Novel.objects.filter(title=data['title']).exists():
            Novel.objects.create(**data)
            print(f"Novel created: {data['title']}")
        else:
            print(f"Novel already exists: {data['title']}")

if __name__ == '__main__':
    create_test_data()
