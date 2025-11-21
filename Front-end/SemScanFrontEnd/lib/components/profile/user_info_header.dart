import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';

class UserInfoHeader extends StatelessWidget {
  final String name;
  final String location;
  final String imageUrl;
  final VoidCallback? onEdit;

  const UserInfoHeader({
    super.key,
    required this.name,
    required this.location,
    required this.imageUrl,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppConstants.paddingXL),
      child: Row(
        children: [
          // Avatar with Edit Button
          Stack(
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: GestureDetector(
                  onTap: onEdit,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: const BoxDecoration(
                      color: AppColors.backgroundDark,
                      shape: BoxShape.circle,
                    ),
                    padding: const EdgeInsets.all(2),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.primaryYellow,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 12,
                        color: AppColors.backgroundDark,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppConstants.gapLarge),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Olá, $name',
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      color: AppColors.primaryYellow,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: TextStyle(
                        color: AppColors.textGrey,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
