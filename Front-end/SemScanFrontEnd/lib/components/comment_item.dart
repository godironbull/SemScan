import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CommentItem extends StatelessWidget {
  final String userName;
  final String text;
  final DateTime date;
  final bool isCurrentUser;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const CommentItem({
    super.key,
    required this.userName,
    required this.text,
    required this.date,
    required this.isCurrentUser,
    this.onEdit,
    this.onDelete,
  });

  String _getTimeAgo() {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays > 0) {
      return '${difference.inDays}d atrás';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h atrás';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}min atrás';
    } else {
      return 'Agora';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      // Removed decoration (color and border) as requested
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.cardDark,
                child: Icon(Icons.person, size: 16, color: AppColors.textGrey),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName,
                      style: const TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      _getTimeAgo(),
                      style: const TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCurrentUser)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, color: AppColors.textGrey, size: 20),
                  color: AppColors.cardDark,
                  onSelected: (value) {
                    if (value == 'edit') {
                      onEdit?.call();
                    } else if (value == 'delete') {
                      onDelete?.call();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18, color: AppColors.textWhite),
                          SizedBox(width: 8),
                          Text('Editar', style: TextStyle(color: AppColors.textWhite)),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Excluir', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.only(left: 44), // Align text with name (16*2 radius + 12 gap)
            child: Text(
              text,
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 14,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
