from django.contrib import admin
from django.urls import path, include

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/chapter/', include('core.urls.chapter_urls')),
    path('api/novels/', include('core.urls.novel_urls')),
    path('api/users/', include('core.urls.users_urls')),
]
