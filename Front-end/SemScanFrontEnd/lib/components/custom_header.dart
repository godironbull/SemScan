import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../theme/app_colors.dart';
import '../theme/app_constants.dart';


class CustomHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onNotification;
  final IconData? actionIcon;

  const CustomHeader({
    super.key,
    this.showBackButton = false,
    this.title = '',
    this.onBack,
    this.onNotification,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.transparent,
            ],
          ),
        ),
      ),
      centerTitle: false,
      automaticallyImplyLeading: false,
      titleSpacing: AppConstants.paddingXL,
      title: Row(
        children: [
          if (showBackButton)
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.textWhite,
                size: AppConstants.iconSizeMedium,
              ),
              onPressed: onBack ?? () => Navigator.pop(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            )
          else
            SvgPicture.asset(
              'assets/images/logo_icon.svg',
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
            
          if (!showBackButton && title.isNotEmpty) ...[
            const SizedBox(width: AppConstants.gapSmall),
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: AppConstants.fontSizeMedium,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(
            actionIcon ?? Icons.notifications_none_outlined,
            color: AppColors.primaryYellow,
            size: AppConstants.iconSizeMedium,
          ),
          onPressed: onNotification,
        ),
        const SizedBox(width: AppConstants.paddingSmall),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
