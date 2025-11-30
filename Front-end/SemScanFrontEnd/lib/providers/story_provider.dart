import 'package:flutter/foundation.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../services/download_service.dart';

class Story {
  final String id;
  String title;
  String synopsis;
  List<String> categories;
  String? coverImageUrl;
  String status; // 'Rascunho' ou 'Publicado'
  final String author;
  final DateTime createdAt;
  DateTime updatedAt;

  Story({
    required this.id,
    required this.title,
    required this.synopsis,
    required this.categories,
    this.coverImageUrl,
    this.status = 'Rascunho',
    required this.author,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'synopsis': synopsis,
      'categories': categories,
      'coverImageUrl': coverImageUrl,
      'status': status,
      'author': author,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      id: map['id'],
      title: map['title'],
      synopsis: map['synopsis'],
      categories: List<String>.from(map['categories']),
      coverImageUrl: map['coverImageUrl'],
      status: map['status'] ?? 'Rascunho',
      author: map['author'],
      createdAt: DateTime.parse(map['createdAt']),
      updatedAt: DateTime.parse(map['updatedAt']),
    );
  }
}

class StoryProvider extends ChangeNotifier {
  final List<Story> _stories = [];

  List<Story> get allStories => _stories;

  List<Story> get publishedStories =>
      _stories.where((story) => story.status == 'Publicado').toList();

  List<Story> get draftStories =>
      _stories.where((story) => story.status == 'Rascunho').toList();

  Story? getStoryById(String id) {
    try {
      return _stories.firstWhere((story) => story.id == id);
    } catch (e) {
      return null;
    }
  }

  void addStory(Story story) {
    _stories.add(story);
    notifyListeners();
  }

  void updateStory(
    String id, {
    String? title,
    String? synopsis,
    List<String>? categories,
    String? coverImageUrl,
    String? status,
  }) {
    final story = getStoryById(id);
    if (story != null) {
      if (title != null) story.title = title;
      if (synopsis != null) story.synopsis = synopsis;
      if (categories != null) story.categories = categories;
      if (coverImageUrl != null) story.coverImageUrl = coverImageUrl;
      if (status != null) story.status = status;
      story.updatedAt = DateTime.now();
      notifyListeners();
    }
  }

  void deleteStory(String id) {
    _stories.removeWhere((story) => story.id == id);
    notifyListeners();
  }

  // Library (Saved Stories)
  final Set<String> _savedStoryIds = {};

  List<Story> get savedStories =>
      _stories.where((story) => _savedStoryIds.contains(story.id)).toList();

  bool isStorySaved(String id) {
    return _savedStoryIds.contains(id);
  }

  Future<void> fetchFavorites() async {
    try {
      final response = await ApiService.get('/favorites/', requiresAuth: true);
      if (response != null) {
        final List<dynamic> data = response;
        _savedStoryIds.clear();
        _savedStoryIds.addAll(data.map((e) => e['story_id'].toString()));

        await StorageService.saveFavorites(_savedStoryIds.toList());
        notifyListeners();
        return;
      }
    } catch (e) {
      debugPrint('Error fetching favorites from API: $e');
    }

    try {
      final localFavorites = await StorageService.getFavorites();
      _savedStoryIds.clear();
      _savedStoryIds.addAll(localFavorites);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading local favorites: $e');
    }
  }

  Future<void> toggleStorySaved(String id) async {
    final isSaved = _savedStoryIds.contains(id);

    if (isSaved) {
      _savedStoryIds.remove(id);
    } else {
      _savedStoryIds.add(id);
    }
    notifyListeners();

    await StorageService.saveFavorites(_savedStoryIds.toList());

    try {
      if (isSaved) {
        await ApiService.delete('/favorites/$id/', requiresAuth: true);
      } else {
        await ApiService.post('/favorites/',
            body: {'story_id': id}, requiresAuth: true);
      }
    } catch (e) {
      debugPrint('Error toggling favorite on API: $e');
    }
  }

  List<Story> searchStories(String query, {List<String>? categories}) {
    final searchQuery = query.toLowerCase();
    return publishedStories.where((story) {
      final matchesSearch = searchQuery.isEmpty ||
          story.title.toLowerCase().contains(searchQuery) ||
          story.synopsis.toLowerCase().contains(searchQuery) ||
          story.categories.any((cat) => cat.toLowerCase().contains(searchQuery));

      final matchesCategory = categories == null ||
          categories.isEmpty ||
          categories.any((cat) => story.categories.contains(cat));

      return matchesSearch && matchesCategory;
    }).toList();
  }

  // Downloads
  List<Story> _downloadedStories = [];
  List<Story> get downloadedStories => _downloadedStories;

  Future<void> fetchDownloadedStories() async {
    _downloadedStories = await DownloadService.getDownloadedStories();
    notifyListeners();
  }

  bool isStoryDownloaded(String id) {
    return _downloadedStories.any((s) => s.id == id);
  }

  Future<void> downloadStory(
      Story story, List<Map<String, dynamic>> chapters) async {
    try {
      await DownloadService.saveStory(story, chapters);
      await fetchDownloadedStories();
    } catch (e) {
      debugPrint('Error downloading story: $e');
      rethrow;
    }
  }

  Future<void> removeDownloadedStory(String id) async {
    try {
      await DownloadService.deleteStory(id);
      await fetchDownloadedStories();
    } catch (e) {
      debugPrint('Error removing downloaded story: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getOfflineChapters(
      String storyId) async {
    return await DownloadService.getStoryChapters(storyId);
  }
}
