# Create your models here.
from django.db import models

class Chapter(models.Model):
    id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=200)
    content = models.TextField()

    def __str__(self):
        return self.title
    def to_dict(self):
        return {
            'id': self.id,
            'title': self.title,
            'content': self.content,
        }
        