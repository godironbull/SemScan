import 'package:flutter/material.dart';
import '../components/custom_header.dart';
import '../components/custom_bottom_nav_bar.dart';
import '../components/section_header.dart';
import '../components/novel_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';
import 'profile_screen.dart';
import 'search_screen.dart';
import 'write_screen.dart';
import 'story_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../providers/story_provider.dart';
import 'login_screen.dart';
import 'notifications_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final GlobalKey<SearchScreenState> _searchScreenKey = GlobalKey<SearchScreenState>();

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = [
      _HomeContent(
        onCategorySelected: _navigateToSearchWithCategory,
      ),
      const ProfileScreen(),
      SearchScreen(key: _searchScreenKey),
      const WriteScreen(),
    ];
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<StoryProvider>().fetchStories();
    });
  }

  void _navigateToSearchWithCategory(String category) {
    setState(() {
      _currentIndex = 2; // Index of SearchScreen
    });
    // Use a post-frame callback to ensure the widget is built before accessing state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchScreenKey.currentState?.selectCategory(category);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      extendBody: true,
      body: Stack(
        children: [
          // Main Content
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
          // Bottom Navigation Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                if (index == 3) { // Write tab
                  if (!context.read<UserProvider>().isLoggedIn) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                    return;
                  }
                }
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final Function(String) onCategorySelected;

  const _HomeContent({
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: CustomHeader(
        title: 'Inicio',
        onNotification: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationsScreen()),
          );
        },
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 100,
            bottom: 100,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(context, 'Destaques'),
              const SizedBox(height: AppConstants.gapXXL),
              _buildSection(context, 'Recomendados'),
              const SizedBox(height: AppConstants.gapXXL),
              _buildSection(context, 'Novos Lançamentos'),
              const SizedBox(height: AppConstants.gapXXL),
              _buildSection(context, 'Ação'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title) {
    return Column(
      children: [
        SectionHeader(
          title: title,
          onSeeMore: () => onCategorySelected(title),
        ),
        const SizedBox(height: AppConstants.gapMedium),
        SizedBox(
          height: 220,
          child: Consumer<StoryProvider>(
            builder: (context, provider, child) {
              if (provider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              
              final stories = provider.publishedStories;
              
              if (stories.isEmpty) {
                return const Center(child: Text('Nenhuma história encontrada', style: TextStyle(color: Colors.white)));
              }

              return ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                  scrollDirection: Axis.horizontal,
                  itemCount: stories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: AppConstants.gapMedium),
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    return NovelCard(
                      title: story.title,
                      author: story.author,
                      imageUrl: story.coverImageUrl ?? 'https://picsum.photos/200/300?random=$index',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StoryDetailScreen(
                              storyId: story.id,
                              title: story.title,
                              author: story.author,
                              imageUrl: story.coverImageUrl ?? 'https://picsum.photos/200/300?random=$index',
                              synopsis: story.synopsis,
                              tags: story.categories,
                              views: '0', // Placeholder
                              stars: '0', // Placeholder
                              chapters: '0', // Placeholder
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
