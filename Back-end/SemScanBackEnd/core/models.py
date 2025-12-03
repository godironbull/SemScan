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
        
class Novel(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=200)
    author = models.CharField(max_length=100)
    chapters = models.ManyToManyField(Chapter, related_name='novels', blank=True)

    def __str__(self):
        return self.name
    def to_dict(self):
        return {
            'id': self.id,
            'name': self.name,
            'author': self.author,
            'chapters': [chapter.to_dict() for chapter in self.chapters.all()],
        }
    def insert_chapter(self, chapter):
        self.chapters.add(chapter)
        self.save()
    
    def remove_chapter(self, chapter):
        self.chapters.remove(chapter)
        self.save()

class Favorite(models.Model):
    id = models.AutoField(primary_key=True)
    user = models.ForeignKey('User', on_delete=models.CASCADE, related_name='favorites')
    novel = models.ForeignKey(Novel, on_delete=models.CASCADE, related_name='favorited_by')

    def __str__(self):
        return f"{self.user.username} - {self.novel.name}"
    def to_dict(self):
        return {
            'id': self.id,
            'user': self.user.to_dict(),
            'novel': self.novel.to_dict(),
        }
        
class User(models.Model):
    id = models.AutoField(primary_key=True)
    username = models.CharField(max_length=100, unique=True)
    email = models.EmailField(unique=True)
    
    def __str__(self):
        return self.username
    def to_dict(self):
        return {
            'id': self.id,
            'username': self.username,
            'email': self.email,
        }
    def add_favorite(self, novel):
        self.favorites.add(novel)
        self.save()
    
    def remove_favorite(self, novel):
        self.favorites.remove(novel)
        self.save()