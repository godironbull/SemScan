import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoWidget extends StatelessWidget {
  final double? width;
  final double? height;

  const LogoWidget({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/Logo.svg',
      width: width ?? 193,
      height: height ?? 66,
      fit: BoxFit.contain,
    );
  }
}

