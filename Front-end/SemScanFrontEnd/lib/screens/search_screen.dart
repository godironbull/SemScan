import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/custom_header.dart';
import '../components/profile/book_list_item.dart';
import '../components/search_input.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';
import '../providers/story_provider.dart';
import '../providers/user_provider.dart';
import '../services/api_service.dart';
import 'story_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => SearchScreenState();
}

class SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _allBooks = [];
  List<Map<String, dynamic>> _filteredBooks = [];
  final Set<String> _selectedCategories = {};
  bool _isLoading = false;

  // Sample data - kept for fallback or demo purposes
  final List<Map<String, dynamic>> _sampleBooks = [
    {
      'title': 'A Jornada do Herói',
      'author': 'João Silva',
      'imageUrl': 'https://picsum.photos/200/300?random=1',
      'views': '15k',
      'stars': '2.3k',
      'chapters': '12',
      'tags': ['Aventura', 'Fantasia', 'Ação', '+2'],
    },
    {
      'title': 'Mistérios da Noite',
      'author': 'Maria Santos',
      'imageUrl': 'https://picsum.photos/200/300?random=2',
      'views': '12k',
      'stars': '1.8k',
      'chapters': '8',
      'tags': ['Suspense', 'Drama', 'Mistério'],
    },
    {
      'title': 'Amor nas Estrelas',
      'author': 'Pedro Costa',
      'imageUrl': 'https://picsum.photos/200/300?random=3',
      'views': '20k',
      'stars': '3.5k',
      'chapters': '15',
      'tags': ['Romance', 'Ficção', '+1'],
    },
    {
      'title': 'O Último Reino',
      'author': 'Ana Oliveira',
      'imageUrl': 'https://picsum.photos/200/300?random=4',
      'views': '18k',
      'stars': '2.9k',
      'chapters': '20',
      'tags': ['Fantasia', 'Aventura', 'Épico', '+3'],
    },
    {
      'title': 'Segredos do Passado',
      'author': 'Carlos Mendes',
      'imageUrl': 'https://picsum.photos/200/300?random=5',
      'views': '10k',
      'stars': '1.5k',
      'chapters': '6',
      'tags': ['Drama', 'Suspense', 'Mistério'],
    },
  ];

  List<String> _availableCategories = [];

  @override
  void initState() {
    super.initState();
    _loadStories();
  }

  Future<void> _loadStories() async {
    setState(() {
      _isLoading = true;
    });

    final storyProvider = context.read<StoryProvider>();
    await storyProvider.fetchStories();

    // Fetch raw data to get chapters count
    List<Map<String, dynamic>> booksFromStories = [];
    try {
      final response = await ApiService.get('/novels/');
      if (response != null) {
        final List<dynamic> novelsData = response;
        booksFromStories = novelsData.map((novelData) {
          final chapters = novelData['chapters'] as List<dynamic>?;
          final chaptersCount = chapters?.length ?? 0;
          
          return {
            'id': novelData['id'].toString(),
            'title': novelData['title'] ?? 'Sem título',
            'author': novelData['author'] ?? 'Autor desconhecido',
            'imageUrl': novelData['cover_image_url'] ?? 
                       novelData['coverImageUrl'] ?? 
                       'https://picsum.photos/200/300?random=${novelData['id']}',
            'views': '0', // Default values - can be updated when backend provides
            'stars': '0',
            'chapters': chaptersCount.toString(),
            'tags': List<String>.from(novelData['categories'] ?? []),
            'synopsis': novelData['synopsis'] ?? '',
            'status': novelData['status'] ?? 'Rascunho',
          };
        }).where((book) => book['status'] == 'Publicado').toList();
      }
    } catch (e) {
      // Fallback: use stories from provider
      final publishedStories = storyProvider.publishedStories;
      booksFromStories = publishedStories.map((story) {
        return {
          'id': story.id,
          'title': story.title,
          'author': story.author,
          'imageUrl': story.coverImageUrl ?? 'https://picsum.photos/200/300?random=${story.id}',
          'views': '0',
          'stars': '0',
          'chapters': '0', // Default when chapters data not available
          'tags': story.categories,
          'synopsis': story.synopsis,
          'status': story.status,
        };
      }).toList();
    }

    // Combine real books with sample books (real books first)
    final allBooks = [...booksFromStories, ..._sampleBooks];

    // Extract unique categories from all books
    final Set<String> categoriesSet = {};
    for (var book in allBooks) {
      final tags = book['tags'] as List<dynamic>;
      for (var tag in tags) {
        final tagStr = tag.toString();
        // Remove '+X' format tags
        if (!tagStr.startsWith('+') && tagStr.isNotEmpty) {
          categoriesSet.add(tagStr);
        }
      }
    }
    _availableCategories = categoriesSet.toList()..sort();

    setState(() {
      _allBooks = allBooks;
      _filteredBooks = allBooks;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void selectCategory(String category) {
    setState(() {
      _selectedCategories.clear();
      _selectedCategories.add(category);
      _filterBooks(_searchController.text);
    });
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
      _filterBooks(_searchController.text);
    });
  }

  void _filterBooks(String query) {
    final searchQuery = query.toLowerCase();
    setState(() {
      _filteredBooks = _allBooks.where((book) {
        final title = book['title']?.toString().toLowerCase() ?? '';
        final author = book['author']?.toString().toLowerCase() ?? '';
        final synopsis = book['synopsis']?.toString().toLowerCase() ?? '';
        final tags = (book['tags'] as List<dynamic>?)
                ?.map((tag) => tag.toString().toLowerCase())
                .toList() ?? [];
        
        final matchesSearch = searchQuery.isEmpty ||
            title.contains(searchQuery) ||
            author.contains(searchQuery) ||
            synopsis.contains(searchQuery) ||
            tags.any((tag) => tag.contains(searchQuery));

        final matchesCategory = _selectedCategories.isEmpty ||
            _selectedCategories.any((category) => 
                tags.contains(category.toLowerCase()));

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      extendBodyBehindAppBar: true,
      appBar: CustomHeader(
        title: 'Buscar',
        onNotification: () {
          // Handle notification tap
        },
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 100, // Space for AppBar
            bottom: 100, // Space for BottomNavBar
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                child: SearchInput(
                  controller: _searchController,
                  onChanged: _filterBooks,
                ),
              ),
              const SizedBox(height: AppConstants.gapLarge),

              // Loading indicator
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(AppConstants.paddingXXL),
                    child: CircularProgressIndicator(
                      color: AppColors.primaryYellow,
                    ),
                  ),
                ),
              if (_isLoading) const SizedBox(height: AppConstants.gapLarge),

              // Categories Filter
              SizedBox(
                height: 40,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                  scrollDirection: Axis.horizontal,
                  itemCount: _availableCategories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = _availableCategories[index];
                    final isSelected = _selectedCategories.contains(category);
                    return FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) => _toggleCategory(category),
                      backgroundColor: AppColors.cardDark,
                      selectedColor: AppColors.primaryYellow,
                      labelStyle: TextStyle(
                        color: isSelected ? AppColors.primaryBlack : AppColors.textGrey,
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color: isSelected ? AppColors.primaryYellow : AppColors.glassBorder,
                        ),
                      ),
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppConstants.gapLarge),
              
              // Results count or empty state (only show when searching or filtering)
              if (_searchController.text.isNotEmpty || _selectedCategories.isNotEmpty)
                if (_filteredBooks.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppConstants.paddingXL,
                      vertical: AppConstants.paddingXXL,
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: AppColors.textGrey.withOpacity(0.5),
                          ),
                          const SizedBox(height: AppConstants.gapMedium),
                          Text(
                            'Nenhum resultado encontrado',
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                    child: Text(
                      '${_filteredBooks.length} resultado${_filteredBooks.length != 1 ? 's' : ''} encontrado${_filteredBooks.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12,
                      ),
                    ),
                  ),
              if (_searchController.text.isNotEmpty || _selectedCategories.isNotEmpty)
                const SizedBox(height: AppConstants.gapMedium),
              
              // Results List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: _filteredBooks.length,
                itemBuilder: (context, index) {
                  final book = _filteredBooks[index];
                  return BookListItem(
                    title: book['title'],
                    author: book['author'],
                    imageUrl: book['imageUrl'],
                    views: book['views'],
                    stars: book['stars'],
                    chapters: book['chapters'],
                    tags: List<String>.from(book['tags']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoryDetailScreen(
                            storyId: book['id']?.toString(),
                            title: book['title'],
                            author: book['author'],
                            imageUrl: book['imageUrl'],
                            synopsis: book['synopsis'] ?? 'Sem sinopse disponível.',
                            tags: List<String>.from(book['tags']),
                            views: book['views'],
                            stars: book['stars'],
                            chapters: book['chapters'],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
