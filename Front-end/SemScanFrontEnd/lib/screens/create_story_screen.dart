import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/custom_header.dart';
import '../components/custom_button.dart';
import '../components/custom_input.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';
import '../providers/story_provider.dart';
import 'chapter_editor_screen.dart';

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
            onPressed: () {
              if (_storyId != null) {
                Provider.of<StoryProvider>(context, listen: false).deleteStory(_storyId!);
              }
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Close screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('História excluída com sucesso')),
              );
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
              // Cover Image Placeholder
              Center(
                child: Row(
                  children: [
                    Container(
                      width: 120,
                      height: 160,
                      decoration: BoxDecoration(
                        color: AppColors.cardDark,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                        border: Border.all(
                          color: AppColors.glassBorder,
                          width: 1,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          color: AppColors.primaryYellow,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppConstants.gapLarge),
                    const Text(
                      'Adicionar uma capa',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 14,
                      ),
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
                      activeColor: AppColors.primaryYellow,
                      activeTrackColor: AppColors.cardDark,
                      inactiveThumbColor: AppColors.textGrey,
                      inactiveTrackColor: AppColors.cardDark,
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.gapXXL),
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
                      onPressed: () {
                        if (!_validateForm()) return;
                        
                        final provider = Provider.of<StoryProvider>(context, listen: false);
                        
                        if (_storyId == null) {
                          // Creating new story
                          final newStory = Story(
                            id: DateTime.now().millisecondsSinceEpoch.toString(),
                            title: _titleController.text.trim(),
                            synopsis: _synopsisController.text.trim(),
                            categories: _selectedCategories.toList(),
                            status: 'Rascunho',
                            author: 'Usuário Atual', // TODO: Get from auth
                          );
                          provider.addStory(newStory);
                          _storyId = newStory.id;
                        } else {
                          // Updating existing story
                          provider.updateStory(
                            _storyId!,
                            title: _titleController.text.trim(),
                            synopsis: _synopsisController.text.trim(),
                            categories: _selectedCategories.toList(),
                            status: _isPublished ? 'Publicado' : 'Rascunho',
                          );
                        }
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChapterEditorScreen(
                              storyTitle: _titleController.text.trim(),
                            ),
                          ),
                        );
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
