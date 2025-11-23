import 'package:flutter/material.dart';
import '../theme/app_constants.dart';
import '../theme/app_colors.dart';

class CustomInput extends StatefulWidget {
  final String label;
  final String? hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool showPasswordToggle;

  const CustomInput({
    super.key,
    required this.label,
    this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.showPasswordToggle = false,
  });

  @override
  State<CustomInput> createState() => _CustomInputState();
}

class _CustomInputState extends State<CustomInput> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: AppColors.textWhite,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(height: AppConstants.gapXS),
        SizedBox(
          height: AppConstants.inputHeight,
          child: TextField(
            controller: widget.controller,
            obscureText: widget.showPasswordToggle
                ? _obscureText
                : widget.obscureText,
            keyboardType: widget.keyboardType,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 14,
            ),
            decoration: InputDecoration(
              hintText: widget.hintText ?? widget.label,
              hintStyle: TextStyle(
                color: AppColors.textGreyDark,
                fontSize: 13,
              ),
              filled: true,
              fillColor: AppColors.backgroundDark,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusSmall,
                ),
                borderSide: const BorderSide(
                  color: AppColors.borderWhite,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusSmall,
                ),
                borderSide: const BorderSide(
                  color: Color.fromARGB(25, 255, 255, 255),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.borderRadiusSmall,
                ),
                borderSide: const BorderSide(
                  color: AppColors.borderYellow,
                  width: 2,
                ),
              ),
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingMedium,
                vertical: 12,
              ),
              suffixIcon: widget.showPasswordToggle
                  ? IconButton(
                      icon: Icon(
                        _obscureText
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: AppColors.primaryYellow,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
            ),
          ),
        ),
      ],
    );
  }
}
