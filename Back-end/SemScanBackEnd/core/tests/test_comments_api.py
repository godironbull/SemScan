from django.test import TestCase
from rest_framework.test import APIClient
from rest_framework import status
from core.models import User, Novel


class TestCommentsAPI(TestCase):
    def setUp(self):
        self.client = APIClient()

    def test_create_and_list_comments_for_novel(self):
        user = User.objects.create(username="user1", email="u1@example.com")
        novel = Novel.objects.create(name="N1", author="A1")
        payload = {"content": "Nice", "novel": novel.id, "user": user.id}
        resp = self.client.post("/comments/", payload, format="json")
        self.assertEqual(resp.status_code, status.HTTP_201_CREATED)
        list_resp = self.client.get(f"/comments/{novel.id}/")
        self.assertEqual(list_resp.status_code, status.HTTP_200_OK)
        self.assertTrue(isinstance(list_resp.data, list))
