import 'package:flutter/material.dart';
import '../components/custom_header.dart';
import '../components/custom_bottom_nav_bar.dart';
import '../components/section_header.dart';
import '../components/novel_card.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      extendBody: true, // Important for glassmorphism navbar
      extendBodyBehindAppBar: true,
      appBar: CustomHeader(
        title: 'Inicio',
        onNotification: () {
          // Handle notification tap
        },
      ),
      body: Stack(
        children: [
          // Main Content
          SingleChildScrollView(
            padding: const EdgeInsets.only(
              top: 100, // Adjusted for extended body behind app bar
              bottom: 100, // Space for navbar
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSection('Destaques'),
                const SizedBox(height: AppConstants.gapXXL),
                _buildSection('Recomendados'),
                const SizedBox(height: AppConstants.gapXXL),
                _buildSection('Novos Lançamentos'),
                const SizedBox(height: AppConstants.gapXXL),
                _buildSection('Ação'),
              ],
            ),
          ),
          // Bottom Navigation Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title) {
    return Column(
      children: [
        SectionHeader(
          title: title,
          onSeeMore: () {
            // Handle see more
          },
        ),
        const SizedBox(height: AppConstants.gapMedium),
        SizedBox(
          height: 220, // Height for the card list
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (context, index) => const SizedBox(width: AppConstants.gapMedium),
            itemBuilder: (context, index) {
              return NovelCard(
                title: 'Titulo da Obra $index',
                author: 'Autor da obra',
                // imageUrl: 'https://placeholder.com/image.jpg', // Uncomment when real images are available
                onTap: () {
                  // Handle card tap
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
