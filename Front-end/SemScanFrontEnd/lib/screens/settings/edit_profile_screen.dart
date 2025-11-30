import 'package:flutter/material.dart';
import '../../components/custom_header.dart';
import '../../components/custom_button.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController(text: 'Jhon doe');
  final _bioController = TextEditingController(text: 'Apaixonado por livros e histórias de fantasia.');
  final _locationController = TextEditingController(text: 'São Paulo - SP');

  @override
  Widget build(BuildContext context) {
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
              ),
              const SizedBox(height: AppConstants.gapLarge),
              _buildTextField(
                label: 'Localização',
                controller: _locationController,
                icon: Icons.location_on_outlined,
              ),
              const SizedBox(height: AppConstants.gapXXL),
              CustomButton(
                text: 'Salvar Alterações',
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Perfil atualizado com sucesso!')),
                  );
                },
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
            ),
          ),
        ),
      ],
    );
  }
}
