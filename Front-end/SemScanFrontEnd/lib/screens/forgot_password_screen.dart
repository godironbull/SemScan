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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: AppConstants.paddingXL,
                    right: AppConstants.paddingXL,
                    top: AppConstants.paddingLarge,
                  ),
                  child: Column(
                    children: [
                      const LogoWidget(),
                      const Spacer(),
                      Column(
                        children: [
                          Text(
                            'Recuperar Conta',
                            style: GoogleFonts.poppins(
                              color: AppColors.textWhite,
                              fontSize: AppConstants.fontSizeLarge,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: AppConstants.gapMedium),
                          Text(
                            'Digite seu e-mail para receber\ninstruções de recuperação',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              color: AppColors.textGrey,
                              fontSize: AppConstants.fontSizeSmall,
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
                                SizedBox(height: AppConstants.gapXXL),
                                CustomButton(
                                  text: 'Enviar instruções',
                                  onPressed: () {
                                    HapticFeedback.lightImpact();
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Instruções de recuperação enviadas para seu e-mail!',
                                          style: GoogleFonts.poppins(
                                            color: AppColors.textWhite,
                                          ),
                                        ),
                                        backgroundColor: AppColors.cardDark,
                                        duration: const Duration(seconds: 3),
                                      ),
                                    );
                                  },
                                ),
                                SizedBox(height: AppConstants.gapXL),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Lembrou sua senha?',
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
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
