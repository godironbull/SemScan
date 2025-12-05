import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../components/custom_header.dart';
import '../../components/custom_button.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';
import '../../providers/user_provider.dart';
import '../../services/storage_service.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final userProvider = context.read<UserProvider>();
    
    _nameController.text = userProvider.name ?? '';
    _bioController.text = userProvider.bio ?? '';
    _locationController.text = userProvider.location ?? '';
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _saveProfile() async {
    final userProvider = context.read<UserProvider>();
    
    final success = await userProvider.updateProfile(
      name: _nameController.text,
      bio: _bioController.text,
      location: _locationController.text,
    );
    
    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil atualizado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao atualizar perfil. Tente novamente.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.backgroundDark,
        appBar: const CustomHeader(
          title: 'Editar Perfil',
          showBackButton: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(
            color: AppColors.primaryYellow,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      extendBodyBehindAppBar: true,
      appBar: const CustomHeader(
        title: 'Editar Perfil',
        showBackButton: true,
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 100,
            bottom: 20,
            left: AppConstants.paddingXL,
            right: AppConstants.paddingXL,
          ),
          child: Column(
            children: [
              _buildTextField(
                label: 'Nome',
                controller: _nameController,
                icon: Icons.person_outline,
              ),
              const SizedBox(height: AppConstants.gapLarge),
              _buildTextField(
                label: 'Bio',
                controller: _bioController,
                icon: Icons.edit_note,
                maxLines: 3,
                hint: 'Conte um pouco sobre você...',
              ),
              const SizedBox(height: AppConstants.gapLarge),
              _buildTextField(
                label: 'Localização',
                controller: _locationController,
                icon: Icons.location_on_outlined,
                hint: 'Ex: São Paulo - SP',
              ),
              const SizedBox(height: AppConstants.gapXXL),
              CustomButton(
                text: 'Salvar Alterações',
                onPressed: _saveProfile,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.1)),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(color: AppColors.textWhite),
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.textGrey),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              hintText: hint,
              hintStyle: TextStyle(
                color: AppColors.textGrey.withOpacity(0.5),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
