import 'package:flutter/material.dart';
import '../components/custom_header.dart';
import '../components/custom_button.dart';
import '../components/profile/book_list_item.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';

class WriteScreen extends StatelessWidget {
  const WriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      extendBodyBehindAppBar: true,
      appBar: CustomHeader(
        title: 'Escrever',
        onNotification: () {
          // Handle notification tap
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
              // Create Story Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                child: CustomButton(
                  text: 'Criar uma nova história',
                  icon: Icons.add,
                  isSecondary: true,
                  onPressed: () {
                    // Handle create new story
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
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return BookListItem(
                    title: 'Titulo da obra',
                    author: 'Autor da obra',
                    imageUrl: 'https://picsum.photos/200/300?random=${index + 10}',
                    views: '12k',
                    stars: '1.2k',
                    chapters: '6',
                    tags: const ['Drama', 'Amizade', 'Ficção', '+3'],
                    onTap: () {},
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
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return BookListItem(
                    title: 'Titulo da obra',
                    author: 'Autor da obra',
                    imageUrl: 'https://picsum.photos/200/300?random=${index + 20}',
                    views: '12k',
                    stars: '1.2k',
                    chapters: '6',
                    tags: const ['Drama', 'Amizade', 'Ficção', '+3'],
                    status: 'Publicado',
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
