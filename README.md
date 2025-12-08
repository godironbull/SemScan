# 📚 SemScan

Uma plataforma completa para leitura e criação de novelas (romances), desenvolvida com Django REST Framework no backend e Flutter no frontend.

## 🎯 Sobre o Projeto

O SemScan é uma aplicação multiplataforma que permite aos usuários:
- 📖 Ler novelas e capítulos
- ✍️ Criar e editar suas próprias histórias
- 👤 Gerenciar perfis personalizados
- 🔍 Buscar novelas por título, autor ou categoria
- 💬 Interagir com comentários e feedback

## 🛠️ Tecnologias Utilizadas

### Backend
- **Django 5.2.8** - Framework web Python
- **Django REST Framework 3.16.1** - API REST
- **SQLite** - Banco de dados
- **django-cors-headers** - Configuração CORS para comunicação com o frontend

### Frontend
- **Flutter** - Framework multiplataforma
- **Provider** - Gerenciamento de estado
- **HTTP** - Comunicação com a API
- **Shared Preferences** - Armazenamento local
- **Google Fonts** - Tipografia
- **Flutter SVG** - Renderização de imagens SVG

## 📁 Estrutura do Projeto

```
SemScan-main/
├── Back-end/
│   └── SemScanBackEnd/
│       ├── core/
│       │   ├── models.py          # Modelos (Novel, Chapter, UserProfile)
│       │   ├── serializers/       # Serializers da API
│       │   ├── View/              # Views da API
│       │   └── urls/              # Rotas da API
│       ├── SemScanBackEnd/
│       │   ├── settings.py        # Configurações do Django
│       │   └── urls.py           # URLs principais
│       ├── requirements.txt       # Dependências Python
│       └── manage.py
│
└── Front-end/
    └── SemScanFrontEnd/
        ├── lib/
        │   ├── components/        # Componentes reutilizáveis
        │   ├── models/            # Modelos de dados
        │   ├── providers/         # Providers de estado
        │   ├── screens/           # Telas da aplicação
        │   ├── services/          # Serviços (API, Auth, Storage)
        │   └── theme/            # Tema e cores
        ├── assets/               # Imagens e recursos
        └── pubspec.yaml          # Dependências Flutter
```

## 🚀 Como Executar

### Pré-requisitos

- Python 3.8+ instalado
- Flutter SDK instalado
- Git instalado

### Backend

1. Navegue até a pasta do backend:
```bash
cd SemScan-main/Back-end/SemScanBackEnd
```

2. Crie um ambiente virtual (recomendado):
```bash
python -m venv venv
```

3. Ative o ambiente virtual:
   - **Windows:**
   ```bash
   venv\Scripts\activate
   ```
   - **Linux/Mac:**
   ```bash
   source venv/bin/activate
   ```

4. Instale as dependências:
```bash
pip install -r requirements.txt
```

5. Execute as migrações:
```bash
python manage.py migrate
```

6. (Opcional) Crie dados de teste:
```bash
python setup_test_data.py
```

7. Inicie o servidor:
```bash
python manage.py runserver
```

O servidor estará disponível em `http://localhost:8000`

### Frontend

1. Navegue até a pasta do frontend:
```bash
cd SemScan-main/Front-end/SemScanFrontEnd
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Configure a URL da API (se necessário):
   - Edite o arquivo `lib/services/api_service.dart`
   - Altere a constante `baseUrl` se o backend estiver em outro endereço

4. Execute o aplicativo:
```bash
flutter run
```

## 📱 Funcionalidades

### Autenticação
- ✅ Registro de novos usuários
- ✅ Login com email/username
- ✅ Recuperação de senha
- ✅ Gerenciamento de sessão

### Novelas
- ✅ Listagem de novelas
- ✅ Visualização de detalhes
- ✅ Busca por título, autor ou categoria
- ✅ Criação de novas novelas
- ✅ Edição de novelas existentes

### Capítulos
- ✅ Leitura de capítulos
- ✅ Criação e edição de capítulos
- ✅ Navegação entre capítulos

### Perfil
- ✅ Visualização e edição de perfil
- ✅ Upload de foto de perfil
- ✅ Alteração de senha
- ✅ Configurações de privacidade

### Outros
- ✅ Sistema de comentários
- ✅ Notificações
- ✅ Feedback
- ✅ Tema escuro

## 🔧 Configuração

### Backend

O arquivo `SemScanBackEnd/settings.py` contém as configurações principais:

- **SECRET_KEY**: Chave secreta do Django (altere em produção!)
- **DEBUG**: Modo debug (desative em produção)
- **ALLOWED_HOSTS**: Hosts permitidos
- **CORS**: Configurado para permitir todas as origens (ajuste em produção)

### Frontend

O arquivo `lib/services/api_service.dart` contém a configuração da API:

```dart
static const String baseUrl = 'http://localhost:8000/api';
```

Altere esta URL conforme necessário para seu ambiente.

## 📝 API Endpoints

### Autenticação
- `POST /api/register/` - Registrar novo usuário
- `POST /api/login/` - Fazer login
- `POST /api/logout/` - Fazer logout

### Novelas
- `GET /api/novels/` - Listar todas as novelas
- `GET /api/novels/{id}/` - Obter detalhes de uma novela
- `POST /api/novels/` - Criar nova novela
- `PUT /api/novels/{id}/` - Atualizar novela
- `DELETE /api/novels/{id}/` - Deletar novela

### Capítulos
- `GET /api/chapters/` - Listar capítulos
- `GET /api/chapters/{id}/` - Obter detalhes de um capítulo
- `POST /api/chapters/` - Criar novo capítulo
- `PUT /api/chapters/{id}/` - Atualizar capítulo
- `DELETE /api/chapters/{id}/` - Deletar capítulo

### Usuários
- `GET /api/users/me/` - Obter perfil do usuário atual
- `PUT /api/users/me/` - Atualizar perfil

## 🤝 Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para:

1. Fazer um fork do projeto
2. Criar uma branch para sua feature (`git checkout -b feature/AmazingFeature`)
3. Commit suas mudanças (`git commit -m 'Add some AmazingFeature'`)
4. Push para a branch (`git push origin feature/AmazingFeature`)
5. Abrir um Pull Request

## 📄 Licença

Este projeto está sob a licença MIT. Veja o arquivo `LICENSE` para mais detalhes.

## 👥 Autores

- Desenvolvido com ❤️ pela equipe SemScan

## 📞 Suporte

Se você encontrar algum problema ou tiver dúvidas, por favor abra uma [issue](../../issues) no repositório.

---

⭐ Se este projeto foi útil para você, considere dar uma estrela!

