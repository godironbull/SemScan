import 'package:flutter/material.dart';
import 'dart:ui';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';
import '../components/custom_button.dart';
import '../components/custom_header.dart';
import '../components/comment_item.dart';
import 'package:provider/provider.dart';
import '../providers/story_provider.dart';
import '../providers/user_provider.dart';
import 'login_screen.dart';
import 'chapter_reading_screen.dart';

class StoryDetailScreen extends StatefulWidget {
  final String? storyId;
  final String title;
  final String author;
  final String imageUrl;
  final String synopsis;
  final List<String> tags;
  final String views;
  final String stars;
  final String chapters;

  const StoryDetailScreen({
    super.key,
    this.storyId,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.synopsis,
    required this.tags,
    required this.views,
    required this.stars,
    required this.chapters,
  });

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  bool _isExpanded = false;
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.storyId != null) {
        final provider = context.read<StoryProvider>();
        if (provider.getStoryById(widget.storyId!) == null) {
          provider.addStory(Story(
            id: widget.storyId!,
            title: widget.title,
            synopsis: widget.synopsis,
            categories: widget.tags,
            coverImageUrl: widget.imageUrl,
            author: widget.author,
            status: 'Publicado',
          ));
        }
      }
    });
  }
  
  // Sample comments - replace with actual data from API
  final List<Map<String, dynamic>> _comments = [
    {
      'id': '1',
      'userId': 'user1',
      'userName': 'João Silva',
      'text': 'Adorei essa história! Muito bem escrita e envolvente.',
      'date': DateTime.now().subtract(const Duration(days: 2)),
      'isCurrentUser': false,
    },
    {
      'id': '2',
      'userId': 'current',
      'userName': 'Você',
      'text': 'Estou ansioso para os próximos capítulos!',
      'date': DateTime.now().subtract(const Duration(hours: 5)),
      'isCurrentUser': true,
    },
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  bool _checkLogin() {
    if (!context.read<UserProvider>().isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      return false;
    }
    return true;
  }

  void _addComment() {
    if (!_checkLogin()) return;

    if (_commentController.text.trim().isEmpty) return;

    setState(() {
      _comments.insert(0, {
        'id': DateTime.now().millisecondsSinceEpoch.toString(),
        'userId': 'current',
        'userName': 'Você',
        'text': _commentController.text.trim(),
        'date': DateTime.now(),
        'isCurrentUser': true,
      });
      _commentController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Comentário adicionado com sucesso!')),
    );
  }

  void _editComment(String commentId, String currentText) {
    if (!_checkLogin()) return;

    final controller = TextEditingController(text: currentText);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text(
          'Editar comentário',
          style: TextStyle(color: AppColors.textWhite),
        ),
        content: TextField(
          controller: controller,
          maxLines: 3,
          style: const TextStyle(color: AppColors.textWhite),
          decoration: InputDecoration(
            hintText: 'Digite seu comentário',
            hintStyle: TextStyle(color: AppColors.textGrey),
            filled: true,
            fillColor: AppColors.backgroundDark,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.textGrey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                final index = _comments.indexWhere((c) => c['id'] == commentId);
                if (index != -1) {
                  _comments[index]['text'] = controller.text.trim();
                }
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Comentário editado com sucesso!')),
              );
            },
            child: const Text('Salvar', style: TextStyle(color: AppColors.primaryYellow)),
          ),
        ],
      ),
    );
  }

  void _deleteComment(String commentId) {
    if (!_checkLogin()) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text(
          'Excluir comentário',
          style: TextStyle(color: AppColors.textWhite),
        ),
        content: const Text(
          'Tem certeza que deseja excluir este comentário?',
          style: TextStyle(color: AppColors.textGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.textGrey)),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _comments.removeWhere((c) => c['id'] == commentId);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Comentário excluído com sucesso!')),
              );
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      extendBodyBehindAppBar: true,
      appBar: CustomHeader(
        title: 'Voltar',
        showBackButton: true,
        onBack: () => Navigator.pop(context),
        onNotification: () {},
      ),
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                // Top section with blurred background
                Stack(
                  children: [
                    // Background image with blur
                    Container(
                      height: 550, // Height up to stats section
                      width: double.infinity,
                      child: Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(color: AppColors.backgroundDark);
                        },
                      ),
                    ),
                    // Blur effect
                    Container(
                      height: 550,
                      width: double.infinity,
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Container(
                          color: Colors.black.withOpacity(0.5),
                        ),
                      ),
                    ),
                    // Gradient at bottom
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 300,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.backgroundDark,
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Content on top of background
                    Padding(
                      padding: const EdgeInsets.only(top: 80), // Space for fixed header
                      child: Column(
                        children: [
                          const SizedBox(height: 20),

                          // Cover image
                          Container(
                            height: 280,
                            width: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 20,
                                  spreadRadius: 5,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                widget.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: AppColors.cardDark,
                                    child: const Icon(Icons.book, size: 60, color: AppColors.textGrey),
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Title
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                            child: Text(
                              widget.title,
                              style: const TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Author
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircleAvatar(
                                radius: 12,
                                backgroundColor: AppColors.cardDark,
                                child: Icon(Icons.person, size: 16, color: AppColors.textGrey),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                widget.author,
                                style: const TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Stats
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _buildStat(Icons.visibility_outlined, widget.views, 'leituras'),
                              const SizedBox(width: 24),
                              _buildStat(Icons.star_outline, widget.stars, 'curtidas'),
                              const SizedBox(width: 24),
                              _buildStat(Icons.menu_book_outlined, widget.chapters, 'capítulos'),
                            ],
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ],
                ),

                // Bottom section with solid background
                Container(
                  color: AppColors.backgroundDark,
                  child: Column(
                    children: [
                      // Action buttons
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: CustomButton(
                                text: 'Ler agora',
                                icon: Icons.menu_book,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChapterReadingScreen(
                                        storyTitle: widget.title,
                                        chapterTitle: 'Capítulo 1',
                                        content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.\n\nDuis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.\n\nSed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo.',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Consumer<StoryProvider>(
                                builder: (context, provider, child) {
                                  final isSaved = widget.storyId != null && 
                                      provider.isStorySaved(widget.storyId!);
                                  
                                  return CustomButton(
                                    text: isSaved ? 'Salvo' : 'Biblioteca',
                                    icon: isSaved ? Icons.check : Icons.add,
                                    isSecondary: !isSaved,
                                    onPressed: () {
                                      if (widget.storyId != null) {
                                        provider.toggleStorySaved(widget.storyId!);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(isSaved 
                                              ? 'Removido da biblioteca' 
                                              : 'Adicionado à biblioteca'),
                                            duration: const Duration(seconds: 1),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Erro: ID da história não encontrado'),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Tags
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          alignment: WrapAlignment.center,
                          children: widget.tags.map((tag) {
                            return Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.cardDark.withOpacity(0.6),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.glassBorder,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                tag,
                                style: const TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Synopsis
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Sinopse',
                              style: TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              widget.synopsis,
                              style: const TextStyle(
                                color: AppColors.textGrey,
                                fontSize: 14,
                                height: 1.5,
                              ),
                              maxLines: _isExpanded ? null : 4,
                              overflow: _isExpanded ? null : TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isExpanded = !_isExpanded;
                                });
                              },
                              child: Text(
                                _isExpanded ? 'ver menos' : 'ver mais',
                                style: const TextStyle(
                                  color: AppColors.primaryYellow,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Comments Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Comentários (${_comments.length})',
                              style: const TextStyle(
                                color: AppColors.textWhite,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Comment input
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 18,
                                  backgroundColor: AppColors.cardDark,
                                  child: Icon(Icons.person, size: 18, color: AppColors.textGrey),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: _commentController,
                                        maxLines: 3,
                                        style: const TextStyle(
                                          color: AppColors.textWhite,
                                          fontSize: 14,
                                        ),
                                        decoration: InputDecoration(
                                          hintText: 'Escreva um comentário...',
                                          hintStyle: const TextStyle(
                                            color: AppColors.textGrey,
                                            fontSize: 13,
                                          ),
                                          filled: true,
                                          fillColor: AppColors.cardDark,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                                            borderSide: BorderSide.none,
                                          ),
                                          contentPadding: const EdgeInsets.all(12),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: SizedBox(
                                          height: 36,
                                          child: ElevatedButton(
                                            onPressed: _addComment,
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: AppColors.primaryYellow,
                                              foregroundColor: AppColors.primaryBlack,
                                              padding: const EdgeInsets.symmetric(horizontal: 20),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                                              ),
                                            ),
                                            child: const Text(
                                              'Comentar',
                                              style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Comments list
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: _comments.length,
                              separatorBuilder: (context, index) => const SizedBox(height: 16),
                              itemBuilder: (context, index) {
                                final comment = _comments[index];
                                return CommentItem(
                                  userName: comment['userName'],
                                  text: comment['text'],
                                  date: comment['date'],
                                  isCurrentUser: comment['isCurrentUser'],
                                  onEdit: () => _editComment(comment['id'], comment['text']),
                                  onDelete: () => _deleteComment(comment['id']),
                                );
                              },
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }

  Widget _buildStat(IconData icon, String value, String label) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textGrey, size: 20),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            color: AppColors.textWhite,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }


}
