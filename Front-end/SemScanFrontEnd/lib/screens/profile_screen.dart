import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_io/io.dart';
import '../components/custom_header.dart';
import '../components/profile/book_list_item.dart';
import '../components/search_input.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';
import 'package:provider/provider.dart';
import '../providers/story_provider.dart';
import '../providers/user_provider.dart';
import 'story_detail_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<StoryProvider>();
      provider.fetchFavorites();
      provider.fetchDownloadedStories();
    });
  }

  Future<void> _pickProfileImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _profileImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Seleção de imagem não disponível nesta plataforma. Use um dispositivo móvel.'),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 4),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 10,
              left: 16,
              right: 16,
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      extendBodyBehindAppBar: true,
      appBar: CustomHeader(
        title: 'Perfil',
        actionIcon: Icons.settings_outlined,
        onNotification: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SettingsScreen()),
          );
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
              // User Info Header with Profile Image
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                child: Row(
                  children: [
                    // Avatar with Edit Button
                    Stack(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                              width: 2,
                            ),
                            image: _profileImage != null
                                ? DecorationImage(
                                    image: FileImage(_profileImage!),
                                    fit: BoxFit.cover,
                                  )
                                : const DecorationImage(
                                    image: NetworkImage('https://i.pravatar.cc/300?img=5'),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: GestureDetector(
                            onTap: _pickProfileImage,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: const BoxDecoration(
                                color: AppColors.backgroundDark,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(2),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: AppColors.primaryYellow,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 12,
                                  color: AppColors.backgroundDark,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: AppConstants.gapLarge),
                    // User Info
                    Expanded(
                      child: Consumer<UserProvider>(
                        builder: (context, userProvider, child) {
                          final username = userProvider.username ?? 'Usuário';
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Olá, $username',
                                style: const TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.location_on_outlined,
                                    color: AppColors.primaryYellow,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'São Paulo - SP',
                                    style: TextStyle(
                                      color: AppColors.textGrey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.gapXXL),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                child: Text(
                  'Continue lendo',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.gapMedium),
              
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                child: SearchInput(
                  controller: TextEditingController(),
                  onChanged: (query) {
                    // Handle search in profile
                  },
                ),
              ),
              const SizedBox(height: AppConstants.gapLarge),
              
              // Book List
              Consumer<StoryProvider>(
                builder: (context, provider, child) {
                  final savedStories = provider.savedStories;

                  if (savedStories.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingXL),
                      child: Center(
                        child: Text(
                          'Sua biblioteca está vazia.',
                          style: TextStyle(color: AppColors.textGrey),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: savedStories.length,
                    itemBuilder: (context, index) {
                      final story = savedStories[index];
                      return BookListItem(
                        title: story.title,
                        author: story.author,
                        imageUrl: story.coverImageUrl ?? 'https://picsum.photos/200/300',
                        views: '0', // TODO: Add views to Story model
                        stars: '0', // TODO: Add stars to Story model
                        chapters: '0', // TODO: Add chapters count
                        tags: story.categories,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoryDetailScreen(
                                storyId: story.id,
                                title: story.title,
                                author: story.author,
                                imageUrl: story.coverImageUrl ?? 'https://picsum.photos/200/300',
                                synopsis: story.synopsis,
                                tags: story.categories,
                                views: '0',
                                stars: '0',
                                chapters: '0',
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: AppConstants.gapXXL),

              // Downloads Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                child: Text(
                  'Downloads',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.gapMedium),

              Consumer<StoryProvider>(
                builder: (context, provider, child) {
                  final downloadedStories = provider.downloadedStories;

                  if (downloadedStories.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.all(AppConstants.paddingXL),
                      child: Center(
                        child: Text(
                          'Nenhum download encontrado.',
                          style: TextStyle(color: AppColors.textGrey),
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: downloadedStories.length,
                    itemBuilder: (context, index) {
                      final story = downloadedStories[index];
                      return BookListItem(
                        title: story.title,
                        author: story.author,
                        imageUrl: story.coverImageUrl ?? 'https://picsum.photos/200/300',
                        views: '0',
                        stars: '0',
                        chapters: '0',
                        tags: story.categories,
                        status: 'Baixado',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StoryDetailScreen(
                                storyId: story.id,
                                title: story.title,
                                author: story.author,
                                imageUrl: story.coverImageUrl ?? 'https://picsum.photos/200/300',
                                synopsis: story.synopsis,
                                tags: story.categories,
                                views: '0',
                                stars: '0',
                                chapters: '0',
                              ),
                            ),
                          );
                        },
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
