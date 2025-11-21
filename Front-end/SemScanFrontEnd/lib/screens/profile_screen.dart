import 'package:flutter/material.dart';
import '../components/custom_header.dart';
import '../components/profile/user_info_header.dart';
import '../components/profile/book_list_item.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      extendBodyBehindAppBar: true,
      appBar: CustomHeader(
        title: 'Perfil',
        actionIcon: Icons.settings_outlined,
        onNotification: () {
          // Handle settings tap
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
              const UserInfoHeader(
                name: 'Jhon doe',
                location: 'São Paulo - SP',
                imageUrl: 'https://i.pravatar.cc/300', // Placeholder
                onEdit: null, // Handle edit
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
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                    border: Border.all(
                      color: AppColors.textGrey.withOpacity(0.5),
                      width: 1,
                    ),
                  ),
                  child: TextField(
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontSize: AppConstants.fontSizeSmall,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Procurar',
                      hintStyle: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: AppConstants.fontSizeSmall - 2,
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: AppColors.primaryYellow,
                        size: 20,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.paddingMedium,
                        vertical: AppConstants.paddingXS,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.gapLarge),
              
              // Book List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return BookListItem(
                    title: 'Titulo da obra',
                    author: 'Autor da obra',
                    imageUrl: 'https://picsum.photos/200/300?random=$index',
                    views: '12k',
                    stars: '1.2k',
                    chapters: '6',
                    tags: const ['Drama', 'Amizade', 'Ficção', '+3'],
                    onTap: () {},
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
