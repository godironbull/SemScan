import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeMore;

  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeMore,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textGrey,
              fontSize: AppConstants.fontSizeLarge, // Using Large for "Tema" as in image it looks big
              fontWeight: FontWeight.w600,
            ),
          ),
          GestureDetector(
            onTap: onSeeMore,
            child: Row(
              children: [
                const Text(
                  'Ver mais',
                  style: TextStyle(
                    color: AppColors.textGrey,
                    fontSize: AppConstants.fontSizeSmall,
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: AppColors.primaryYellow,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
