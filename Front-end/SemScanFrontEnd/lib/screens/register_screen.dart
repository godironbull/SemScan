import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../components/custom_input.dart';
import '../components/custom_button.dart';
import '../components/logo_widget.dart';
import '../components/custom_card.dart';
import '../components/custom_text_link.dart';
import '../theme/app_constants.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textWhite,
            size: AppConstants.iconSizeMedium,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingXL,
            ),
            child: Column(
              children: [
                SizedBox(height: AppConstants.gapLarge),
                const LogoWidget(),
                SizedBox(height: AppConstants.gapXXL),
                Text(
                  'Criar Conta',
                  style: GoogleFonts.poppins(
                    color: AppColors.textWhite,
                    fontSize: AppConstants.fontSizeLarge,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppConstants.gapXXL),
                CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CustomInput(
                        label: 'Nome',
                        hintText: 'Nome completo',
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(height: AppConstants.gapLarge),
                      CustomInput(
                        label: 'E-mail',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: AppConstants.gapLarge),
                      CustomInput(
                        label: 'Senha',
                        controller: _passwordController,
                        obscureText: true,
                        showPasswordToggle: true,
                      ),
                      SizedBox(height: AppConstants.gapLarge),
                      CustomInput(
                        label: 'Confirmar Senha',
                        hintText: 'Confirmar senha',
                        controller: _confirmPasswordController,
                        obscureText: true,
                        showPasswordToggle: true,
                      ),
                      SizedBox(height: AppConstants.gapXXL),
                      CustomButton(
                        text: 'Criar conta',
                        onPressed: () {
                          HapticFeedback.lightImpact();
                        },
                      ),
                      SizedBox(height: AppConstants.gapXL),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Já possui uma conta?',
                            style: GoogleFonts.poppins(
                              color: AppColors.textWhite,
                              fontSize: AppConstants.fontSizeSmall,
                            ),
                          ),
                          CustomTextLink(
                            text: 'Fazer login',
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppConstants.gapXXL),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
