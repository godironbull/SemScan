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
import 'register_screen.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.paddingXL,
            ),
            child: Column(
              children: [
                SizedBox(height: AppConstants.gapXXXL),
                const LogoWidget(),
                SizedBox(height: AppConstants.gapHuge),
                Text(
                  'Login',
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
                      SizedBox(height: AppConstants.gapSmall),
                      Align(
                        alignment: Alignment.centerRight,
                        child: CustomTextLink(
                          text: 'Esqueceu a senha?',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ForgotPasswordScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: AppConstants.gapLarge),
                      CustomButton(
                        text: 'Acessar conta',
                        onPressed: () {
                          HapticFeedback.lightImpact();
                        },
                      ),
                      SizedBox(height: AppConstants.gapXL),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Não possuí uma conta?',
                            style: GoogleFonts.poppins(
                              color: AppColors.textWhite,
                              fontSize: AppConstants.fontSizeSmall,
                            ),
                          ),
                          CustomTextLink(
                            text: 'Crie uma',
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const RegisterScreen(),
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
