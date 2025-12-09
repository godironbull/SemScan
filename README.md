
Este projeto utiliza Flutter no front-end, Django com Django REST Framework no back-end e SQLite como banco de dados. 
O Flutter envia requisições HTTP para o Django, que processa as informações, acessa o SQLite e devolve a resposta ao aplicativo.Não foi utilizado postgres devido a falta de experiência com docker

## Configuração do Back-end e front-end

Primeiro foi criado um ambiente virtual para isolar as dependências:

```
python -m venv venv
```

Ativação:

```
venv\Scripts\activate       # Windows
source venv/bin/activate   # Linux/Mac
```

Instalação do Django e do Django REST Framework:

```
pip install django djangorestframework
```

Criação do projeto Django:

```
django-admin startproject backend
cd backend
```

Criação do app responsável pela API:

```
python manage.py startapp api
```

Registro do app e do REST Framework dentro de `settings.py` para funcionamento correto. Após isso, o banco SQLite já está configurado por padrão. Para gerar o arquivo do banco e aplicar alterações:

```
python manage.py makemigrations
python manage.py migrate
```

Para iniciar o servidor:

```
python manage.py runserver
```

O back-end fica acessível em:

```
http://127.0.0.1:8000/
```


## 🧩 Configuração do Front-end (Flutter)

Para configurar o front-end desenvolvido em Flutter, primeiro é necessário instalar todas as dependências do projeto seguindo a documentação oficial do Flutter:

Documentação oficial:
[https://docs.flutter.dev/](https://docs.flutter.dev/)

Instale as dependências com:

```
flutter pub get
```

Após isso, o aplicativo pode ser executado com:

```
flutter run
```




## Estrutura

O projeto é dividido em duas partes principais: o diretório do Flutter, onde está o aplicativo, e o diretório do back-end, que contém o projeto Django e o banco SQLite.
A API centraliza as rotas, modelos e regras de negócio.
