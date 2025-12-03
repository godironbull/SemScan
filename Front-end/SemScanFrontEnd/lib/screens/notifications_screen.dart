import 'package:flutter/material.dart';
import '../components/custom_header.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      extendBodyBehindAppBar: true,
      appBar: const CustomHeader(
        title: 'Notificações',
        showBackButton: true,
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: ListView.builder(
          padding: const EdgeInsets.only(
            top: 100, // Space for AppBar
            bottom: 20,
            left: AppConstants.paddingXL,
            right: AppConstants.paddingXL,
          ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return _buildNotificationItem(index);
          },
        ),
      ),
    );
  }

  Widget _buildNotificationItem(int index) {
    final isLike = index % 2 == 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.05),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isLike 
                  ? AppColors.primaryYellow.withOpacity(0.1)
                  : Colors.blueAccent.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isLike ? Icons.thumb_up_alt : Icons.comment,
              color: isLike ? AppColors.primaryYellow : Colors.blueAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    style: const TextStyle(
                      color: AppColors.textWhite,
                      fontSize: 14,
                      height: 1.4,
                    ),
                    children: [
                      TextSpan(
                        text: 'Usuário ${index + 1} ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: isLike 
                            ? 'curtiu sua obra '
                            : 'comentou na sua obra ',
                      ),
                      const TextSpan(
                        text: '"O Retorno do Guerreiro"',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Há ${index + 2} horas',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (!isLike) // Show a small dot for unread or specific types if needed
             Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.primaryYellow,
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}
