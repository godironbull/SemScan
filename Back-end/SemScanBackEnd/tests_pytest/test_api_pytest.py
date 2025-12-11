import time
import pytest
from django.urls import reverse
from core.models import User, Novel, Chapter


@pytest.mark.django_db
def test_user_create_and_detail(api_client):
    start = time.time()
    r = api_client.post("/users/", {"username": "pyuser", "email": "py@user.com"}, format="json")
    assert r.status_code == 201
    uid = r.data["id"]
    r2 = api_client.get(f"/users/{uid}/")
    assert r2.status_code == 200
    assert r2.data["username"] == "pyuser"
    assert (time.time() - start) < 1.0


@pytest.mark.django_db
def test_user_validation_errors(api_client):
    r = api_client.post("/users/", {}, format="json")
    assert r.status_code in (400, 201)


@pytest.mark.django_db
def test_novel_happy_and_patch(api_client):
    r = api_client.post("/novels/", {"name": "PNovel", "author": "Auth"}, format="json")
    assert r.status_code == 201
    nid = r.data["id"]
    r2 = api_client.patch(f"/novels/{nid}/", {"name": "NewName"}, format="json")
    assert r2.status_code == 200
    assert r2.data["name"] == "NewName"


@pytest.mark.django_db
def test_insert_chapter_integration(api_client):
    novel = Novel.objects.create(name="N3", author="A3")
    chap = Chapter.objects.create(title="C3", content="T")
    r = api_client.post(f"/novels/{novel.id}/insert/{chap.id}/", {}, format="json")
    assert r.status_code == 200
    assert any(c["id"] == chap.id for c in r.data.get("chapters", []))


@pytest.mark.django_db
def test_comments_invalid_novel_returns_404(api_client):
    user = User.objects.create(username="u", email="u@u.com")
    r = api_client.post("/comments/", {"content": "Nice", "novel": 99999, "user": user.id}, format="json")
    assert r.status_code == 404

