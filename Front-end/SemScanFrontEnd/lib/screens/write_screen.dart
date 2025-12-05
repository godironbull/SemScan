import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/custom_header.dart';
import '../components/custom_button.dart';
import '../components/profile/book_list_item.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';
import '../providers/story_provider.dart';
import 'create_story_screen.dart';
import 'feedback_screen.dart';
import 'notifications_screen.dart';

class WriteScreen extends StatefulWidget {
  const WriteScreen({super.key});

  @override
  State<WriteScreen> createState() => _WriteScreenState();
}

class _WriteScreenState extends State<WriteScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch stories when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StoryProvider>(context, listen: false).fetchStories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      extendBodyBehindAppBar: true,
      appBar: CustomHeader(
        title: 'Escrever',
        onNotification: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationsScreen()),
          );
        },
      ),
      body: Consumer<StoryProvider>(
        builder: (context, storyProvider, child) {
          final drafts = storyProvider.draftStories;
          final published = storyProvider.publishedStories;

          return ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(
                top: 100, // Space for AppBar
                bottom: 100, // Space for BottomNavBar
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Create Story Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                    child: CustomButton(
                      text: 'Criar uma nova história',
                      icon: Icons.add,
                      isSecondary: true,
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CreateStoryScreen(),
                          ),
                        );
                        // Refresh stories after returning from creation
                        if (mounted) {
                          Provider.of<StoryProvider>(context, listen: false).fetchStories();
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: AppConstants.gapXXL),
                  
                  // Drafts Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                    child: Text(
                      'Rascunhos',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.gapMedium),
                  
                  // Drafts List
                  if (drafts.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                      child: Text(
                        'Nenhum rascunho encontrado',
                        style: TextStyle(
                          color: AppColors.textGreyDark,
                          fontSize: 14,
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: drafts.length,
                      itemBuilder: (context, index) {
                        final story = drafts[index];
                        return BookListItem(
                          title: story.title,
                          author: story.author,
                          imageUrl: story.coverImageUrl ?? 'https://picsum.photos/200/300?random=${story.id}',
                          views: '0',
                          stars: '0',
                          chapters: '0', // TODO: Get actual chapter count
                          tags: story.categories,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateStoryScreen(
                                  story: {
                                    'id': story.id,
                                    'title': story.title,
                                    'author': story.author,
                                    'imageUrl': story.coverImageUrl,
                                    'tags': story.categories,
                                    'status': story.status,
                                    'synopsis': story.synopsis,
                                  },
                                ),
                              ),
                            );
                            // Refresh after editing
                            if (mounted) {
                              Provider.of<StoryProvider>(context, listen: false).fetchStories();
                            }
                          },
                        );
                      },
                    ),
                  
                  const SizedBox(height: AppConstants.gapXXL),
                  
                  // Published Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                    child: Text(
                      'Minhas obras',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppConstants.gapMedium),
                  
                  // Published List
                  if (published.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                      child: Text(
                        'Nenhuma obra publicada',
                        style: TextStyle(
                          color: AppColors.textGreyDark,
                          fontSize: 14,
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      itemCount: published.length,
                      itemBuilder: (context, index) {
                        final story = published[index];
                        return BookListItem(
                          title: story.title,
                          author: story.author,
                          imageUrl: story.coverImageUrl ?? 'https://picsum.photos/200/300?random=${story.id}',
                          views: '0',
                          stars: '0',
                          chapters: '0', // TODO: Get actual chapter count
                          tags: story.categories,
                          status: 'Publicado',
                          onFeedback: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FeedbackScreen(
                                  storyTitle: story.title,
                                ),
                              ),
                            );
                          },
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateStoryScreen(
                                  story: {
                                    'id': story.id,
                                    'title': story.title,
                                    'author': story.author,
                                    'imageUrl': story.coverImageUrl,
                                    'tags': story.categories,
                                    'status': story.status,
                                    'synopsis': story.synopsis,
                                  },
                                ),
                              ),
                            );
                            // Refresh after editing
                            if (mounted) {
                              Provider.of<StoryProvider>(context, listen: false).fetchStories();
                            }
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
