from django.test import TestCase
from rest_framework.test import APIClient
from rest_framework import status
from core.models import Chapter


class TestChapterAPI(TestCase):
    def setUp(self):
        self.client = APIClient()

    def test_create_chapter(self):
        payload = {"title": "Ch1", "content": "Text"}
        resp = self.client.post("/chapter/", payload, format="json")
        self.assertEqual(resp.status_code, status.HTTP_201_CREATED)
        self.assertEqual(resp.data["title"], "Ch1")

    def test_get_patch_delete(self):
        c = Chapter.objects.create(title="ChX", content="Lorem")
        get_resp = self.client.get(f"/chapter/{c.id}/")
        self.assertEqual(get_resp.status_code, status.HTTP_200_OK)
        patch_resp = self.client.patch(f"/chapter/{c.id}/", {"title": "Updated"}, format="json")
        self.assertEqual(patch_resp.status_code, status.HTTP_200_OK)
        self.assertEqual(patch_resp.data["title"], "Updated")
        del_resp = self.client.delete(f"/chapter/{c.id}/")
        self.assertEqual(del_resp.status_code, status.HTTP_200_OK)
