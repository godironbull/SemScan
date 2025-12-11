from django.test import TestCase
from rest_framework.test import APIClient
from rest_framework import status
from core.models import User
from core.serializers.UserSeralizer import UserSerializer


class TestUserAPI(TestCase):
    def setUp(self):
        self.client = APIClient()

    def test_create_user(self):
        payload = {"username": "alice", "email": "alice@example.com"}
        resp = self.client.post("/users/", payload, format="json")
        self.assertEqual(resp.status_code, status.HTTP_201_CREATED)
        self.assertEqual(resp.data["username"], "alice")
        self.assertEqual(resp.data["email"], "alice@example.com")

    def test_list_users(self):
        User.objects.create(username="bob", email="bob@example.com")
        User.objects.create(username="carol", email="carol@example.com")
        resp = self.client.get("/users/")
        self.assertEqual(resp.status_code, status.HTTP_200_OK)
        self.assertTrue(isinstance(resp.data, list))
        self.assertGreaterEqual(len(resp.data), 2)

    def test_get_user_detail(self):
        u = User.objects.create(username="dave", email="dave@example.com")
        resp = self.client.get(f"/users/{u.id}/")
        self.assertEqual(resp.status_code, status.HTTP_200_OK)
        self.assertEqual(resp.data["id"], u.id)
        self.assertEqual(resp.data["username"], "dave")

    def test_patch_user(self):
        u = User.objects.create(username="erin", email="erin@example.com")
        resp = self.client.patch(f"/users/{u.id}/", {"email": "new@example.com"}, format="json")
        self.assertEqual(resp.status_code, status.HTTP_200_OK)
        self.assertEqual(resp.data["email"], "new@example.com")


class TestUserSerializer(TestCase):
    def test_user_serializer_validation(self):
        serializer = UserSerializer(data={})
        self.assertFalse(serializer.is_valid())
