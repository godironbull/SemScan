import 'package:flutter/foundation.dart';

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

  void updateStory(String id, {
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
}
