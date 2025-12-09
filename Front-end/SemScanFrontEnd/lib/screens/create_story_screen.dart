import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/custom_header.dart';
import '../components/custom_button.dart';
import '../components/custom_input.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';
import '../providers/story_provider.dart';
import '../providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_io/io.dart';
import 'chapter_editor_screen.dart';
import 'story_detail_screen.dart';

class CreateStoryScreen extends StatefulWidget {
  final Map<String, dynamic>? story;

  const CreateStoryScreen({
    super.key,
    this.story,
  });

  @override
  State<CreateStoryScreen> createState() => _CreateStoryScreenState();
}

class _CreateStoryScreenState extends State<CreateStoryScreen> {
  late TextEditingController _titleController;
  late TextEditingController _synopsisController;
  final Set<String> _selectedCategories = {};
  bool _isPublished = false;
  String? _storyId;
  File? _coverImage;
  final ImagePicker _picker = ImagePicker();

  final List<String> _availableCategories = [
    'Ação',
    'Aventura',
    'Fantasia',
    'Romance',
    'Mistério',
    'Suspense',
    'Drama',
    'Ficção',
    'Épico',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.story?['title'] ?? '');
    _synopsisController = TextEditingController(text: widget.story?['synopsis'] ?? '');
    
    if (widget.story != null) {
      _storyId = widget.story!['id'];
      if (widget.story!['tags'] != null) {
        _selectedCategories.addAll(List<String>.from(widget.story!['tags']));
      }
      _isPublished = widget.story!['status'] == 'Publicado';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _synopsisController.dispose();
    super.dispose();
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategories.contains(category)) {
        _selectedCategories.remove(category);
      } else {
        _selectedCategories.add(category);
      }
    });
  }

  Future<void> _pickCoverImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1200,
        maxHeight: 1600,
        imageQuality: 85,
      );
      
      if (image != null) {
        setState(() {
          _coverImage = File(image.path);
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



  bool _validateForm() {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira o título da obra'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_synopsisController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, insira a sinopse/descrição'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    if (_selectedCategories.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione pelo menos uma categoria'),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    return true;
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardDark,
        title: const Text(
          'Excluir história',
          style: TextStyle(color: AppColors.textWhite),
        ),
        content: const Text(
          'Tem certeza que deseja excluir esta história? Esta ação não pode ser desfeita.',
          style: TextStyle(color: AppColors.textGrey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.textGrey),
            ),
          ),
          TextButton(
            onPressed: () async {
              if (_storyId != null) {
                Navigator.pop(context); // Close dialog first
                
                final success = await Provider.of<StoryProvider>(context, listen: false).deleteStory(_storyId!);
                
                if (mounted) {
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('História excluída com sucesso'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.pop(context); // Close screen
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Erro ao excluir história'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              }
            },
            child: const Text(
              'Excluir',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.story != null;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      extendBodyBehindAppBar: true,
      appBar: CustomHeader(
        title: isEditing ? 'Editar História' : 'Criar História',
        showBackButton: true,
        onBack: () => Navigator.pop(context),
        actionWidget: isEditing
            ? IconButton(
                icon: const Icon(
                  Icons.delete_outline,
                  color: AppColors.textGrey,
                ),
                onPressed: _showDeleteConfirmation,
              )
            : null,
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 100,
            bottom: 40,
            left: AppConstants.paddingXL,
            right: AppConstants.paddingXL,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover Image Selector
              Center(
                child: Column(
                  children: [
                    Row(
                      children: [
                        GestureDetector(
                          onTap: _pickCoverImage,
                          child: Container(
                            width: 120,
                            height: 160,
                            decoration: BoxDecoration(
                              color: AppColors.cardDark,
                              borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                              border: Border.all(
                                color: AppColors.glassBorder,
                                width: 1,
                              ),
                              image: _coverImage != null
                                  ? DecorationImage(
                                      image: FileImage(_coverImage!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: _coverImage == null
                                ? const Center(
                                    child: Icon(
                                      Icons.add_photo_alternate_outlined,
                                      color: AppColors.primaryYellow,
                                      size: 32,
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        const SizedBox(width: AppConstants.gapLarge),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _coverImage == null ? 'Adicionar uma capa' : 'Capa selecionada',
                                style: const TextStyle(
                                  color: AppColors.textWhite,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Toque para ${_coverImage == null ? "selecionar" : "alterar"}',
                                style: const TextStyle(
                                  color: AppColors.textGrey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.gapXXL),

              // Title Input
              CustomInput(
                label: 'Titulo da obra *',
                hintText: 'Escolha o título da sua história',
                controller: _titleController,
              ),
              const SizedBox(height: AppConstants.gapLarge),

              // Synopsis Input
              CustomInput(
                label: 'Sinopse/descrição *',
                hintText: 'Descrição básica',
                controller: _synopsisController,
              ),
              const SizedBox(height: AppConstants.gapLarge),

              // Categories Selector
              const Text(
                'Categorias *',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppConstants.gapSmall),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _availableCategories.map((category) {
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
                }).toList(),
              ),
              const SizedBox(height: AppConstants.gapXXL),

              // Publish Switch (Only if editing or maybe always?)
              // User asked for it "ao clicar em qualquer novel da tela de editar", implying edit mode.
              if (isEditing) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Publicar história',
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Switch(
                      value: _isPublished,
                      onChanged: (value) {
                        setState(() {
                          _isPublished = value;
                        });
                      },
                      activeThumbColor: AppColors.primaryYellow,
                      activeTrackColor: AppColors.cardDark,
                      inactiveThumbColor: AppColors.textGrey,
                      inactiveTrackColor: AppColors.cardDark,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.gapXXL),
              ],

              // View Story Button (only if published)
              if (_isPublished && _storyId != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      final userProvider = Provider.of<UserProvider>(context, listen: false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoryDetailScreen(
                            storyId: _storyId,
                            title: _titleController.text,
                            author: userProvider.username ?? userProvider.name ?? 'Usuário Atual',
                            imageUrl: widget.story?['imageUrl'] ?? widget.story?['coverImageUrl'] ?? 'https://picsum.photos/200/300',
                            synopsis: _synopsisController.text,
                            tags: _selectedCategories.toList(),
                            views: '0', // TODO: Get real stats
                            stars: '0',
                            chapters: '0',
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility_outlined),
                    label: const Text('Ver página da obra (como leitor)'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryYellow,
                      side: const BorderSide(color: AppColors.primaryYellow),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppConstants.gapMedium),
              ],

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Cancelar',
                      isSecondary: true,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const SizedBox(width: AppConstants.gapMedium),
                  Expanded(
                    child: CustomButton(
                      text: 'Continuar',
                      onPressed: () async {
                        if (!_validateForm()) return;
                        
                        final provider = Provider.of<StoryProvider>(context, listen: false);
                        final userProvider = Provider.of<UserProvider>(context, listen: false);
                        
                        if (_storyId == null) {
                          // Creating new story
                          final newStory = Story(
                            id: '', // Will be assigned by backend
                            title: _titleController.text.trim(),
                            synopsis: _synopsisController.text.trim(),
                            categories: _selectedCategories.toList(),
                            status: 'Rascunho',
                            author: userProvider.username ?? 'Anônimo',
                          );
                          
                          final createdId = await provider.addStory(newStory);
                          if (createdId != null) {
                            setState(() => _storyId = createdId);
                            
                            if (mounted) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChapterEditorScreen(
                                    storyTitle: _titleController.text.trim(),
                                    storyId: createdId,
                                  ),
                                ),
                              );
                            }
                          } else {
                            // Show error
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Erro ao criar novel. Verifique sua conexão.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        } else {
                          // Updating existing story
                          final success = await provider.updateStory(
                            _storyId!,
                            title: _titleController.text.trim(),
                            synopsis: _synopsisController.text.trim(),
                            categories: _selectedCategories.toList(),
                            status: _isPublished ? 'Publicado' : 'Rascunho',
                          );
                          
                          if (success && mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChapterEditorScreen(
                                  storyTitle: _titleController.text.trim(),
                                  storyId: _storyId!,
                                ),
                              ),
                            );
                          } else if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Erro ao atualizar novel'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}
