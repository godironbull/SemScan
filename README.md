
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

## Testes

### Back-end (Django)

- Instalar dependências e aplicar migrações:

```
cd Back-end/SemScanBackEnd
python -m pip install -r requirements.txt
python manage.py migrate
```

- Executar a suíte de testes:

```
python manage.py test --verbosity=2
```

- Cobertura (opcional, se tiver `coverage` instalado):

```
coverage run manage.py test && coverage xml -o backend-coverage.xml
```

### Front-end (Flutter)

- Instalar dependências:

```
cd Front-end/SemScanFrontEnd
flutter pub get
```

- Executar testes com cobertura:

```
flutter test --coverage
```

Os arquivos de teste estão em `Front-end/SemScanFrontEnd/test/`.

### Testes Unitários com Pytest (Python)

- Executar pytest no back-end:

```
cd Back-end/SemScanBackEnd
pytest -q --disable-warnings --maxfail=1 --cov=core --cov-report=xml:pytest-coverage.xml
```

### Testes de Aceitação com Robot Framework

- Pré-requisito: servidor Django rodando em outra aba/terminal:

```
cd Back-end/SemScanBackEnd
python manage.py runserver
```

- Em um novo terminal, executar os testes de aceitação:

```
cd Back-end/SemScanBackEnd
robot -d reports tests_acceptance
```

Relatórios gerados em `Back-end/SemScanBackEnd/reports`. Os casos cobrem:
- Criação/consulta de usuário
- Erro ao comentar em novel inexistente
- Tempo de resposta básico de `/novels/`

### Pre-commit (automatizar execução de testes antes do commit)

- Instalar o hook de pre-commit (PowerShell):

```
pwsh -File scripts/setup_hooks.ps1
```

- O hook chama `scripts/pre_commit.ps1` e bloqueia o commit se algum teste falhar. Para pular testes do front-end em um commit específico:

```
pwsh -File scripts/pre_commit.ps1 -SkipFrontend
```

### CI/CD

- Os testes de back-end e front-end rodam automaticamente no CI para cada push/PR.
- Pipeline definida em `.github/workflows/ci.yml`.
- Artefatos de cobertura são publicados (backend: `backend-coverage.xml`, `pytest-coverage.xml`; frontend: `coverage/lcov.info`).
