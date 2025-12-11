from django.test import TestCase
from rest_framework.test import APIClient
from rest_framework import status
from core.models import Novel, Chapter


class TestChapterInsertIntegration(TestCase):
    def setUp(self):
        self.client = APIClient()

    def test_insert_chapter_into_novel(self):
        novel = Novel.objects.create(name="N2", author="Auth")
        chapter = Chapter.objects.create(title="C1", content="Content")
        resp = self.client.post(f"/novels/{novel.id}/insert/{chapter.id}/", {}, format="json")
        self.assertEqual(resp.status_code, status.HTTP_200_OK)
        self.assertEqual(resp.data["id"], novel.id)
        self.assertTrue(any(ch["id"] == chapter.id for ch in resp.data.get("chapters", [])))
