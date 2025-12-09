import 'package:flutter/material.dart';
import '../components/custom_header.dart';
import '../components/custom_button.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';
import '../components/comment_item.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/api_service.dart';
import 'login_screen.dart';

class ChapterReadingScreen extends StatefulWidget {
  final String storyTitle;
  final String chapterTitle;
  final String content;

  const ChapterReadingScreen({
    super.key,
    required this.storyTitle,
    required this.chapterTitle,
    required this.content,
  });

  @override
  State<ChapterReadingScreen> createState() => _ChapterReadingScreenState();
}

class _ChapterReadingScreenState extends State<ChapterReadingScreen> {
  final TextEditingController _commentController = TextEditingController();
  
  // Mock data for chapters and pages
  late List<Map<String, dynamic>> _chapters;
  int _currentChapterIndex = 0;
  int _currentPageIndex = 0;

  // Removed global like state
  // int _likeCount = 120; 
  // bool _isLiked = false;

  // Comments
  List<Map<String, dynamic>> _comments = [];

  @override
  void initState() {
    super.initState();
<<<<<<< Updated upstream
    // Initialize mock chapters based on the passed content
    // In a real app, this would come from the backend
    _chapters = [
      {
        'title': 'Capítulo 1: O Início', // Fixed title for consistency
        'likeCount': 120,
        'isLiked': false,
        'pages': [
          widget.content,
          'Continuação da página 1...\n\nMais texto de exemplo para demonstrar a navegação entre páginas. O leitor pode avançar para ler o restante do capítulo.',
          'Página final do capítulo 1.\n\nAqui termina este capítulo. Clique em "Próximo Capítulo" para continuar a história.',
        ]
      },
      {
        'title': 'Capítulo 2: O Encontro',
        'likeCount': 45,
        'isLiked': true,
        'pages': [
          'Este é o início do segundo capítulo.\n\nA história continua com novos eventos e personagens. A navegação permite transitar suavemente entre os capítulos.',
          'Página 2 do Capítulo 2.\n\nMais desenvolvimento da trama...',
        ]
      },
      {
        'title': 'Capítulo 3: A Revelação',
        'likeCount': 89,
        'isLiked': false,
        'pages': [
          'Terceiro capítulo.\n\nO clímax se aproxima...',
        ]
      }
    ];
=======
    
    // Use real chapters if provided, otherwise use mock data for backward compatibility
    if (widget.chapters != null && widget.chapters!.isNotEmpty) {
      // Convert real chapters to the format expected by the UI
      _chapters = widget.chapters!.map((chapter) {
        return {
          'title': chapter['title'] ?? 'Capítulo sem título',
          'likeCount': 0, // Default values - can be updated when backend provides
          'isLiked': false,
          'pages': List<String>.from(chapter['pages'] ?? []),
          'chapterId': chapter['chapterId'],
        };
      }).toList();
    } else {
      // Fallback to mock data for backward compatibility
      _chapters = [
        {
          'title': widget.chapterTitle ?? 'Capítulo 1: O Início',
          'likeCount': 120,
          'isLiked': false,
          'pages': [
            widget.content ?? 'Conteúdo não disponível.',
          ]
        },
      ];
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadDataForCurrentChapter();
    });
  }

  Future<void> _loadDataForCurrentChapter() async {
    final currentChapter = _chapters[_currentChapterIndex];
    final chapterId = currentChapter['chapterId'];
    // If mocking or no/invalid ID, skip
    if (chapterId == null) return;

    // Load Like Status
    try {
      if (context.read<UserProvider>().isLoggedIn) {
        final likeResponse = await ApiService.get('/chapters/$chapterId/like/', requiresAuth: true);
        if (likeResponse != null && mounted) {
            setState(() {
                currentChapter['likeCount'] = likeResponse['count'] ?? 0;
                currentChapter['isLiked'] = likeResponse['liked'] ?? false;
            });
        }
      } else {
         // Maybe just load count public? Currently like endpoints require Auth in view?
         // View requires IsAuthenticated. So skip if not logged in.
         // But we should show count? I'll leave it 0 if not logged in or modify backend later.
      }
    } catch (e) {
      debugPrint('Error loading like status: $e');
    }

    // Load Comments
    // Use the actual chapterId from the database if available, otherwise fallback (which likely won't work for API)
    if (chapterId != null) {
      _loadComments(chapterId.toString());
    }
  }

  Future<void> _loadComments(String chapterId) async {
    try {
      final response = await ApiService.get('/comments/?chapter_id=$chapterId');
       if (response != null && response is List) {
          final List<Map<String, dynamic>> loaded = [];
          
          String? currentUserId;
          try {
             currentUserId = Provider.of<UserProvider>(context, listen: false).userId;
          } catch(e) {/* ignore */}
          
          for (var item in response) {
            loaded.add({
              'id': item['id'].toString(),
              'userId': item['user'].toString(),
              'userName': item['username'] ?? 'Usuário',
              'content': item['content'], // Changed from text
              'date':  item['created_at'] != null ? DateTime.parse(item['created_at']) : DateTime.now(),
              'isCurrentUser': item['user'].toString() == currentUserId,
            });
          }
          
          if (mounted) {
            setState(() {
              _comments = loaded;
            });
          }
       }
    } catch(e) {
      debugPrint('Error loading comments: $e');
    }
>>>>>>> Stashed changes
  }

  // Scroll controller to reset position on page change
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
  }

  void _nextPage() {
    setState(() {
      if (_currentPageIndex < _chapters[_currentChapterIndex]['pages'].length - 1) {
        _currentPageIndex++;
      } else if (_currentChapterIndex < _chapters.length - 1) {
        _currentChapterIndex++;
        _currentPageIndex = 0;
        _loadDataForCurrentChapter();
      }
      _scrollToTop();
    });
  }

  void _previousPage() {
    setState(() {
      if (_currentPageIndex > 0) {
        _currentPageIndex--;
      } else if (_currentChapterIndex > 0) {
        _currentChapterIndex--;
        _currentPageIndex = _chapters[_currentChapterIndex]['pages'].length - 1;
        _loadDataForCurrentChapter();
      }
      _scrollToTop();
    });
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

  Future<void> _toggleLike() async {
    if (!_checkLogin()) return;

    final currentChapter = _chapters[_currentChapterIndex];
    final chapterId = currentChapter['chapterId'];
    if (chapterId == null) return; // Mocks don't work with API

    // Optimistic update
    setState(() {
      final isLiked = currentChapter['isLiked'] as bool;
      final likeCount = currentChapter['likeCount'] as int;

      if (isLiked) {
        currentChapter['likeCount'] = likeCount - 1;
        currentChapter['isLiked'] = false;
      } else {
        currentChapter['likeCount'] = likeCount + 1;
        currentChapter['isLiked'] = true;
      }
    });

    try {
      final response = await ApiService.post('/chapters/$chapterId/like/', requiresAuth: true);
      // If response['liked'] doesn't match our optimistic state, correct it?
      // For now, trusting our optimistic update or simple toggle.
      // But we should strictly respect server if needed.
    } catch (e) {
      // Revert on error
       setState(() {
         final isLiked = currentChapter['isLiked'] as bool;
         final likeCount = currentChapter['likeCount'] as int;
         // Invert back
         if (isLiked) {
           currentChapter['likeCount'] = likeCount - 1;
           currentChapter['isLiked'] = false;
         } else {
           currentChapter['likeCount'] = likeCount + 1;
           currentChapter['isLiked'] = true;
         }
       });
       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erro ao curtir: $e')));
    }
  }

  void _showRatingDialog() {
    if (!_checkLogin()) return;

    int selectedStars = 0;
    final TextEditingController reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Dialog(
            backgroundColor: AppColors.cardDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nóvel finalizada',
                        style: TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.textGrey),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Voce finalizou sua leitura, avalie essa obra para contribuir com a comunidade.',
                    style: TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Star Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < selectedStars ? Icons.star : Icons.star_border,
                          color: AppColors.primaryYellow,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            selectedStars = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  const SizedBox(height: 24),

                  // Comment Field
                  Align(
                    alignment: Alignment.centerLeft,
                    child: const Text(
                      'Comentário (opicional)',
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: reviewController,
                    maxLines: 3,
                    style: const TextStyle(color: AppColors.textWhite),
                    decoration: InputDecoration(
                      hintText: 'Descreva',
                      hintStyle: const TextStyle(color: AppColors.textGrey),
                      filled: true,
                      fillColor: AppColors.backgroundDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                        borderSide: const BorderSide(color: AppColors.textGrey),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                        borderSide: BorderSide(color: AppColors.textGrey.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                        borderSide: const BorderSide(color: AppColors.primaryYellow),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primaryYellow),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                            ),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              color: AppColors.textGrey,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle rating submission
                            Navigator.pop(context);
                            Navigator.pop(context); // Exit reading screen
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Avaliação enviada com sucesso!')),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryYellow,
                            foregroundColor: AppColors.primaryBlack,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                            ),
                          ),
                          child: const Text(
                            'Confirmar',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCommentsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundDark,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(AppConstants.paddingXL),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textGrey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Comentários (${_comments.length})',
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                
                // Comment Input
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
                                onPressed: () {
                                  _addComment();
                                  Navigator.pop(context); // Close sheet after comment (optional)
                                  _showCommentsSheet(); // Re-open to show new comment
                                },
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
                const SizedBox(height: 20),
                const Divider(color: AppColors.glassBorder),
                const SizedBox(height: 20),

                // Comments List
                Expanded(
                  child: ListView.separated(
                    controller: scrollController,
                    itemCount: _comments.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final comment = _comments[index];
                      var commentContent = comment['content'] ?? '';
                      return CommentItem(
                        userName: comment['userName'] ?? 'Anônimo',
                        text: commentContent,
                        date: comment['date'],
                        isCurrentUser: comment['isCurrentUser'],
                        onEdit: () {
                          Navigator.pop(context); // Close sheet
                          _editComment(comment['id'], commentContent);
                        },
                        onDelete: () {
                          Navigator.pop(context); // Close sheet
                          _deleteComment(comment['id']);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _addComment() async {
    if (!_checkLogin()) return;

    if (_commentController.text.trim().isEmpty) return;
    
    final currentChapter = _chapters[_currentChapterIndex];
    final chapterId = currentChapter['chapterId'];
    
    if (chapterId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro: ID do capítulo não encontrado')),
      );
      return;
    }

    try {
      final response = await ApiService.post(
        '/comments/',
        body: {
          'chapter': chapterId,
          'content': _commentController.text.trim(),
        },
        requiresAuth: true,
      );
      
      if (response != null) {
        _commentController.clear();
        await _loadComments(chapterId.toString());
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Comentário adicionado com sucesso!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
           SnackBar(content: Text('Erro ao adicionar comentário: $e')),
        );
      }
    }
  }

  void _editComment(String commentId, String currentText) {
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
            hintStyle: const TextStyle(color: AppColors.textGrey),
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
            onPressed: () async {
              Navigator.pop(context);
              try {
                final response = await ApiService.put(
                   '/comments/$commentId/',
                   body: {'content': controller.text.trim()},
                   requiresAuth: true,
                );
                
                if (response != null) {
                   final currentChapter = _chapters[_currentChapterIndex];
                   final chapterId = currentChapter['chapterId'];
                   if(chapterId != null) {
                       await _loadComments(chapterId.toString());
                   }
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Comentário editado com sucesso!')),
                    );
                  }
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao editar comentário: $e')),
                  );
                }
              }
            },
            child: const Text('Salvar', style: TextStyle(color: AppColors.primaryYellow)),
          ),
        ],
      ),
    );
  }

  void _deleteComment(String commentId) {
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
            onPressed: () async {
              Navigator.pop(context);
              try {
                await ApiService.delete('/comments/$commentId/', requiresAuth: true);
                
                final currentChapter = _chapters[_currentChapterIndex];
                final chapterId = currentChapter['chapterId'];
                if(chapterId != null) {
                    await _loadComments(chapterId.toString());
                }
                
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Comentário excluído com sucesso!')),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erro ao excluir comentário: $e')),
                  );
                }
              }
            },
            child: const Text('Excluir', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentChapter = _chapters[_currentChapterIndex];
    final currentContent = currentChapter['pages'][_currentPageIndex];
    final totalPages = currentChapter['pages'].length;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: CustomHeader(
        title: widget.storyTitle,
        showBackButton: true,
        onBack: () => Navigator.pop(context),
        actionWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Like Button
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    _chapters[_currentChapterIndex]['isLiked'] ? Icons.favorite : Icons.favorite_border,
                    color: _chapters[_currentChapterIndex]['isLiked'] ? Colors.red : AppColors.textWhite,
                    size: 24,
                  ),
                  onPressed: _toggleLike,
                ),
                Text(
                  '${_chapters[_currentChapterIndex]['likeCount']}',
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            // Comment Button
            IconButton(
              icon: const Icon(Icons.comment_outlined, color: AppColors.primaryYellow),
              onPressed: _showCommentsSheet,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.all(AppConstants.paddingXL),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Chapter Title
                    Text(
                      currentChapter['title'],
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Página ${_currentPageIndex + 1} de $totalPages',
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: AppConstants.gapLarge),

                    // Content
                    Text(
                      currentContent,
                      textAlign: TextAlign.left,
                      style: const TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 18,
                        height: 1.8,
                        fontFamily: 'Georgia', // Better font for reading
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
          
          // Navigation Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              border: const Border(
                top: BorderSide(color: AppColors.glassBorder),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Previous Button
                IconButton(
                  onPressed: (_currentChapterIndex == 0 && _currentPageIndex == 0) 
                      ? null 
                      : _previousPage,
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: (_currentChapterIndex == 0 && _currentPageIndex == 0)
                        ? AppColors.textGrey.withOpacity(0.3)
                        : AppColors.textWhite,
                  ),
                ),
                
                // Progress Info
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Capítulo ${_currentChapterIndex + 1}/${_chapters.length}',
                      style: const TextStyle(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${(((_currentChapterIndex * 100) + ((_currentPageIndex + 1) / totalPages * 100)) / _chapters.length).toInt()}% lido',
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),

                // Next Button or Finish Button
                if (_currentChapterIndex == _chapters.length - 1 && _currentPageIndex == totalPages - 1)
                  IconButton(
                    onPressed: _showRatingDialog,
                    icon: const Icon(
                      Icons.check_circle,
                      color: AppColors.primaryYellow,
                      size: 28,
                    ),
                  )
                else
                  IconButton(
                    onPressed: _nextPage,
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      color: AppColors.textWhite,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
