from django.test import TestCase
from rest_framework.test import APIClient
from rest_framework import status
from core.models import Novel


class TestNovelAPI(TestCase):
    def setUp(self):
        self.client = APIClient()

    def test_create_novel(self):
        payload = {"name": "My Story", "author": "Author"}
        resp = self.client.post("/novels/", payload, format="json")
        self.assertEqual(resp.status_code, status.HTTP_201_CREATED)
        self.assertEqual(resp.data["name"], "My Story")
        self.assertEqual(resp.data["author"], "Author")

    def test_list_and_detail(self):
        n = Novel.objects.create(name="S1", author="A1")
        resp = self.client.get("/novels/1/") if n.id == 1 else self.client.get(f"/novels/{n.id}/")
        self.assertEqual(resp.status_code, status.HTTP_200_OK)
        self.assertEqual(resp.data["id"], n.id)
        list_resp = self.client.get("/novels/")
        self.assertEqual(list_resp.status_code, status.HTTP_200_OK)
        self.assertTrue(isinstance(list_resp.data, list))

    def test_patch_and_delete(self):
        n = Novel.objects.create(name="Old", author="A")
        patch = self.client.patch(f"/novels/{n.id}/", {"name": "New"}, format="json")
        self.assertEqual(patch.status_code, status.HTTP_200_OK)
        self.assertEqual(patch.data["name"], "New")
        delete = self.client.delete(f"/novels/{n.id}/")
        self.assertEqual(delete.status_code, status.HTTP_200_OK)
