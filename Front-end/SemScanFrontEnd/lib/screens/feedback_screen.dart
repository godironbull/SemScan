import 'package:flutter/material.dart';
import '../components/custom_header.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';

class FeedbackScreen extends StatelessWidget {
  final String storyTitle;

  const FeedbackScreen({
    super.key,
    required this.storyTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      extendBodyBehindAppBar: true,
      appBar: CustomHeader(
        title: 'Feedback',
        showBackButton: true,
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 100, // Space for AppBar
            bottom: 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                child: Text(
                  storyTitle,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.gapLarge),
              
              // Stats Cards
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.thumb_up_alt_outlined,
                        value: '1.2k',
                        label: 'Likes',
                        color: AppColors.primaryYellow,
                      ),
                    ),
                    const SizedBox(width: AppConstants.gapMedium),
                    Expanded(
                      child: _buildStatCard(
                        icon: Icons.comment_outlined,
                        value: '45',
                        label: 'Comentários',
                        color: Colors.blueAccent,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: AppConstants.gapXXL),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                child: Text(
                  'Comentários Recentes',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.gapMedium),
              
              // Comments List
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
                itemCount: 5,
                itemBuilder: (context, index) {
                  return _buildCommentItem(index);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentItem(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=${index + 50}'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Usuário ${index + 1}',
                      style: const TextStyle(
                        color: AppColors.textWhite,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'Há ${index + 1} horas',
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.star,
                color: AppColors.primaryYellow,
                size: 16,
              ),
              const SizedBox(width: 4),
              const Text(
                '5.0',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Esta história é incrível! Adorei o desenvolvimento dos personagens e a trama envolvente. Mal posso esperar pelo próximo capítulo!',
            style: TextStyle(
              color: AppColors.textGrey,
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
