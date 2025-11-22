class Book {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final int views;
  final int stars;
  final int chapters;
  final List<String> tags;
  final String? status; // 'Publicado', 'Rascunho', etc.
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Book({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.views,
    required this.stars,
    required this.chapters,
    required this.tags,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      author: json['author'] ?? '',
      imageUrl: json['imageUrl'] ?? json['image_url'] ?? '',
      views: json['views'] ?? 0,
      stars: json['stars'] ?? 0,
      chapters: json['chapters'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      status: json['status'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'imageUrl': imageUrl,
      'views': views,
      'stars': stars,
      'chapters': chapters,
      'tags': tags,
      'status': status,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  String get viewsFormatted => _formatNumber(views);
  String get starsFormatted => _formatNumber(stars);
  String get chaptersFormatted => chapters.toString();

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}k';
    }
    return number.toString();
  }
}
