# Create your models here.
from django.db import models
from django.contrib.auth.models import User
from django.db.models.signals import post_save
from django.dispatch import receiver

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    bio = models.TextField(blank=True, null=True)
    location = models.CharField(max_length=100, blank=True, null=True)

    def __str__(self):
        return self.user.username

@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        UserProfile.objects.create(user=instance)


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
        
class Novel(models.Model):
    id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=200, default="Untitled")
    author = models.CharField(max_length=100)
    synopsis = models.TextField(blank=True, null=True)
    cover_image_url = models.CharField(max_length=500, blank=True, null=True)
    status = models.CharField(max_length=50, default='Rascunho')
    categories = models.JSONField(default=list, blank=True)
    chapters = models.ManyToManyField(Chapter, related_name='novels', blank=True)

    def __str__(self):
        return self.title
    def to_dict(self):
        return {
            'id': self.id,
            'title': self.title,
            'author': self.author,
            'synopsis': self.synopsis,
            'coverImageUrl': self.cover_image_url,
            'status': self.status,
            'categories': self.categories,
            'chapters': [chapter.to_dict() for chapter in self.chapters.all()],
        }
    def insert_chapter(self, chapter):
        self.chapters.add(chapter)
        self.save()
    
    def remove_chapter(self, chapter):
        self.chapters.remove(chapter)
        self.save()