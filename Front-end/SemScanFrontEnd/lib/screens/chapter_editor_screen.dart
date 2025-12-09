import 'dart:async';
import 'package:flutter/material.dart';
import '../components/custom_header.dart';
import '../components/custom_button.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';
import '../services/api_service.dart';

class ChapterEditorScreen extends StatefulWidget {
  final String storyTitle;
  final String storyId;

  const ChapterEditorScreen({
    super.key,
    required this.storyTitle,
    required this.storyId,
  });

  @override
  State<ChapterEditorScreen> createState() => _ChapterEditorScreenState();
}

class _ChapterEditorScreenState extends State<ChapterEditorScreen> {
  // Structure: [{'title': String, 'pages': List<String>, 'chapterId': int?}]
  final List<Map<String, dynamic>> _chapters = [
    {'title': 'Capítulo 1', 'pages': <String>[''], 'chapterId': null},
  ];
  int _currentChapterIndex = 0;
  int _currentPageIndex = 0;
  
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  
  // Character limit per page
  static const int _charsPerPage = 1500;
  
  // Loading state for save operation
  bool _isSaving = false;
  
  // Auto-save debounce timer
  Timer? _autoSaveTimer;
  static const Duration _autoSaveDelay = Duration(seconds: 2);
  
  // Track if we need to save
  bool _needsSave = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadExistingChapters();
    });
  }
  
  Future<void> _loadExistingChapters() async {
    try {
      // Fetch novel to get existing chapters
      final novelResponse = await ApiService.get('/novels/${widget.storyId}/');
      if (novelResponse != null && novelResponse['chapters'] != null) {
        final List<dynamic> chapters = novelResponse['chapters'];
        
        if (chapters.isNotEmpty && mounted) {
          setState(() {
            _chapters.clear();
            for (var chapterData in chapters) {
              final content = chapterData['content'] ?? '';
              // Split content by page separator
              final pages = content.split('\n\n--- Página ---\n\n');
              if (pages.isEmpty) pages.add('');
              
              _chapters.add({
                'title': chapterData['title'] ?? 'Capítulo ${_chapters.length + 1}',
                'pages': pages,
                'chapterId': chapterData['id'],
              });
            }
            
            // If no chapters, add default one
            if (_chapters.isEmpty) {
              _chapters.add({'title': 'Capítulo 1', 'pages': <String>[''], 'chapterId': null});
            }
            
            _currentChapterIndex = 0;
            _currentPageIndex = 0;
            _updateControllersForNewContext();
          });
        }
      }
    } catch (e) {
      debugPrint('Error loading existing chapters: $e');
      // Keep default chapter if loading fails
    }
  }

  void _initializeControllers() {
    _titleController = TextEditingController(text: _chapters[_currentChapterIndex]['title']);
    _contentController = TextEditingController(text: _chapters[_currentChapterIndex]['pages'][_currentPageIndex]);
    
    _titleController.addListener(_updateChapterTitle);
    _contentController.addListener(_updateChapterContent);
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    // Save any pending changes before disposing
    if (_needsSave) {
      _saveCurrentChapter();
    }
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _updateChapterTitle() {
    _chapters[_currentChapterIndex]['title'] = _titleController.text;
    _scheduleAutoSave();
  }

  void _updateChapterContent() {
    // We don't call setState here to avoid rebuilding the whole UI on every keystroke
    // which would lose focus or cursor position if not handled carefully.
    _chapters[_currentChapterIndex]['pages'][_currentPageIndex] = _contentController.text;
    _scheduleAutoSave();
  }
  
  void _scheduleAutoSave() {
    _needsSave = true;
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(_autoSaveDelay, () {
      if (_needsSave) {
        _saveCurrentChapter();
      }
    });
  }
  
  Future<void> _saveCurrentChapter() async {
    if (_isSaving) return;
    
    final chapter = _chapters[_currentChapterIndex];
    final String title = chapter['title'];
    final List<String> pages = chapter['pages'];
    final int? chapterId = chapter['chapterId'];
    
    // Combine all pages into single content
    final String content = pages.join('\n\n--- Página ---\n\n');
    
    try {
      setState(() {
        _isSaving = true;
      });
      
      if (chapterId != null) {
        // Update existing chapter
        await ApiService.patch(
          '/chapter/$chapterId/',
          body: {
            'title': title,
            'content': content,
          },
          requiresAuth: true,
        );
      } else {
        // Create new chapter
        final chapterResponse = await ApiService.post(
          '/chapter/',
          body: {
            'title': title,
            'content': content,
          },
          requiresAuth: true,
        );
        
        if (chapterResponse != null && chapterResponse['id'] != null) {
          final newChapterId = chapterResponse['id'];
          
          // Update local chapter with ID
          setState(() {
            _chapters[_currentChapterIndex]['chapterId'] = newChapterId;
          });
          
          // Associate chapter with novel
          await ApiService.post(
            '/novels/${widget.storyId}/insert/$newChapterId/',
            requiresAuth: true,
          );
        }
      }
      
      setState(() {
        _needsSave = false;
        _isSaving = false;
      });
    } catch (e) {
      debugPrint('Error auto-saving chapter: $e');
      setState(() {
        _isSaving = false;
      });
      // Don't show error to user for auto-save failures
      // They can still manually save
    }
  }

  Future<void> _save() async {
    // Cancel any pending auto-save
    _autoSaveTimer?.cancel();
    
    // Save all chapters
    if (_isSaving) return;
    
    setState(() {
      _isSaving = true;
    });

    try {
      // Save all chapters to the backend
      for (int i = 0; i < _chapters.length; i++) {
        final chapter = _chapters[i];
        final String title = chapter['title'];
        final List<String> pages = chapter['pages'];
        final int? chapterId = chapter['chapterId'];
        
        // Combine all pages into single content
        final String content = pages.join('\n\n--- Página ---\n\n');
        
        if (chapterId != null) {
          // Update existing chapter
          await ApiService.patch(
            '/chapter/$chapterId/',
            body: {
              'title': title,
              'content': content,
            },
            requiresAuth: true,
          );
        } else {
          // Create new chapter
          final chapterResponse = await ApiService.post(
            '/chapter/',
            body: {
              'title': title,
              'content': content,
            },
            requiresAuth: true,
          );
          
          if (chapterResponse != null && chapterResponse['id'] != null) {
            final newChapterId = chapterResponse['id'];
            
            // Update local chapter with ID
            setState(() {
              _chapters[i]['chapterId'] = newChapterId;
            });
            
            // Associate chapter with novel
            await ApiService.post(
              '/novels/${widget.storyId}/insert/$newChapterId/',
              requiresAuth: true,
            );
          }
        }
      }
      
      setState(() {
        _needsSave = false;
        _isSaving = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Capítulos salvos com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        // Pop all screens until we reach WriteScreen
        Navigator.popUntil(context, (route) => route.isFirst || route.settings.name == '/write');
      }
    } catch (e) {
      if (mounted) {
        final errorMessage = e.toString();
        // Check if it's an authentication error
        final isAuthError = errorMessage.contains('Não autorizado') || 
                           errorMessage.contains('401') ||
                           errorMessage.contains('autorizado');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isAuthError 
                ? 'Sessão expirada. Por favor, faça login novamente.'
                : 'Erro ao salvar capítulos: $e'
            ),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
        
        // Don't redirect on error - let user stay on the page to fix the issue
        // Only show error message
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  void _addNewChapter() {
    setState(() {
      _chapters.add({
        'title': 'Capítulo ${_chapters.length + 1}', 
        'pages': <String>[''],
        'chapterId': null,
      });
      _currentChapterIndex = _chapters.length - 1;
      _currentPageIndex = 0;
      _updateControllersForNewContext();
    });
    Navigator.pop(context); // Close the bottom sheet
  }

  void _switchChapter(int index) async {
    // Save current chapter before switching
    if (_needsSave) {
      await _saveCurrentChapter();
    }
    
    setState(() {
      _currentChapterIndex = index;
      _currentPageIndex = 0;
      _updateControllersForNewContext();
    });
  }
  
  void _updateControllersForNewContext() {
    // Remove listeners to avoid triggering updates during switch
    _titleController.removeListener(_updateChapterTitle);
    _contentController.removeListener(_updateChapterContent);

    _titleController.text = _chapters[_currentChapterIndex]['title'];
    _contentController.text = _chapters[_currentChapterIndex]['pages'][_currentPageIndex];

    _titleController.addListener(_updateChapterTitle);
    _contentController.addListener(_updateChapterContent);
  }

  void _previousPage() {
    if (_currentPageIndex > 0) {
      setState(() {
        _currentPageIndex--;
        _updateControllersForNewContext();
      });
    } else if (_currentChapterIndex > 0) {
      setState(() {
        _currentChapterIndex--;
        _currentPageIndex = (_chapters[_currentChapterIndex]['pages'] as List<String>).length - 1;
        _updateControllersForNewContext();
      });
    }
  }

  void _nextPage() {
    final currentChapterPages = _chapters[_currentChapterIndex]['pages'] as List<String>;
    
    if (_currentPageIndex < currentChapterPages.length - 1) {
      setState(() {
        _currentPageIndex++;
        _updateControllersForNewContext();
      });
    } else {
      // Last page of current chapter
      if (_currentChapterIndex < _chapters.length - 1) {
        // Go to next chapter
        setState(() {
          _currentChapterIndex++;
          _currentPageIndex = 0;
          _updateControllersForNewContext();
        });
      } else {
        // Last page of last chapter
        // Create new page if current is not empty
        if (currentChapterPages.last.isNotEmpty) {
           setState(() {
            currentChapterPages.add('');
            _currentPageIndex++;
            _updateControllersForNewContext();
          });
        }
      }
    }
  }

  int _calculateGlobalPage() {
    int pageCount = 0;
    for (int i = 0; i < _currentChapterIndex; i++) {
      pageCount += (_chapters[i]['pages'] as List<String>).length;
    }
    return pageCount + _currentPageIndex + 1;
  }

  int _calculateTotalPages() {
    int pageCount = 0;
    for (var chapter in _chapters) {
      pageCount += (chapter['pages'] as List<String>).length;
    }
    return pageCount;
  }

  void _showChapterList() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.cardDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(AppConstants.paddingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Capítulos',
                    style: TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, color: AppColors.primaryYellow),
                    onPressed: _addNewChapter,
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.gapMedium),
              Expanded(
                child: ListView.separated(
                  itemCount: _chapters.length,
                  separatorBuilder: (context, index) => const Divider(color: AppColors.glassBorder),
                  itemBuilder: (context, index) {
                    final isSelected = index == _currentChapterIndex;
                    return ListTile(
                      title: Text(
                        _chapters[index]['title'],
                        style: TextStyle(
                          color: isSelected ? AppColors.primaryYellow : AppColors.textWhite,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      onTap: () {
                        _switchChapter(index);
                        Navigator.pop(context);
                      },
                      trailing: isSelected ? const Icon(Icons.check, color: AppColors.primaryYellow) : null,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentGlobalPage = _calculateGlobalPage();
    final totalPages = _calculateTotalPages();
    final currentContentLength = _contentController.text.length;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      extendBodyBehindAppBar: true,
      appBar: CustomHeader(
        title: 'Cap. ${_currentChapterIndex + 1} de ${_chapters.length}',
        showBackButton: true,
        onBack: () async {
          // Save before going back
          if (_needsSave) {
            await _saveCurrentChapter();
          }
          Navigator.pop(context);
        },
        actionWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isSaving || _needsSave)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      _isSaving ? AppColors.primaryYellow : AppColors.textGrey,
                    ),
                  ),
                ),
              ),
            TextButton(
              onPressed: _isSaving ? null : _save,
              child: Text(
                _isSaving ? 'Salvando...' : 'Salvar',
                style: TextStyle(
                  color: _isSaving ? AppColors.textGrey : AppColors.primaryYellow,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Main Content
          Padding(
            padding: const EdgeInsets.only(
              top: 100, // Space for AppBar
              bottom: 100, // Space for Bottom Controls
              left: AppConstants.paddingXL,
              right: AppConstants.paddingXL,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Chapter Title Input
                TextField(
                  controller: _titleController,
                  style: const TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Título do Capítulo',
                    hintStyle: TextStyle(color: AppColors.textGreyDark),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.glassBorder),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primaryYellow),
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
                const SizedBox(height: AppConstants.gapLarge),
                
                // Content Input
                Expanded(
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    expands: true,
                    maxLength: _charsPerPage,
                    textAlignVertical: TextAlignVertical.top,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 16,
                      height: 1.5,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Comece a escrever sua história...',
                      hintStyle: TextStyle(color: AppColors.textGreyDark),
                      border: InputBorder.none,
                      counterText: '',
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Floating Chapter Menu Button
          Positioned(
            right: AppConstants.paddingXL,
            top: 110,
            child: GestureDetector(
              onTap: _showChapterList,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: AppColors.primaryYellow,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.black,
                  size: 20,
                ),
              ),
            ),
          ),

          // Bottom Controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(AppConstants.paddingXL),
              decoration: const BoxDecoration(
                color: AppColors.backgroundDark,
                border: Border(
                  top: BorderSide(color: AppColors.glassBorder),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ValueListenableBuilder<TextEditingValue>(
                    valueListenable: _contentController,
                    builder: (context, value, child) {
                      return Text(
                        'Página $currentGlobalPage/$totalPages • ${value.text.length}/$_charsPerPage',
                        style: const TextStyle(
                          color: AppColors.textWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppConstants.gapMedium),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Anterior',
                          isSecondary: true,
                          onPressed: (currentGlobalPage > 1) 
                              ? _previousPage 
                              : null,
                        ),
                      ),
                      const SizedBox(width: AppConstants.gapMedium),
                      Expanded(
                        child: CustomButton(
                          text: 'Próximo',
                          onPressed: _nextPage,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
