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
<<<<<<< Updated upstream
=======
                                    
                                    // Validation
                                    if (_nameController.text.isEmpty || 
                                        _emailController.text.isEmpty || 
                                        _passwordController.text.isEmpty) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Por favor, preencha todos os campos'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    // Validação de formato de email
                                    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                                    if (!emailRegex.hasMatch(_emailController.text)) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Por favor, insira um e-mail válido'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    // Validação de tamanho da senha
                                    if (_passwordController.text.length < 6) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('A senha deve ter pelo menos 6 caracteres'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    if (_passwordController.text != _confirmPasswordController.text) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('As senhas não coincidem'),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                      return;
                                    }

                                    // Register
                                    final result = await context.read<UserProvider>().register(
                                      _nameController.text,
                                      _emailController.text,
                                      _passwordController.text,
                                    );

                                    if (context.mounted) {
                                      if (result['success'] == true) {
                                        Navigator.pushReplacementNamed(context, '/home');
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(result['error'] ?? 'Erro ao criar conta'),
                                            backgroundColor: Colors.red,
                                            duration: const Duration(seconds: 5),
                                          ),
                                        );
                                      }
                                    }
>>>>>>> Stashed changes
                                  },
                                ),
                                const SizedBox(height: AppConstants.gapLarge),
                                Row(
                                  children: [
                                    Expanded(child: Divider(color: Colors.white.withOpacity(0.2))),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        'ou',
                                        style: GoogleFonts.poppins(
                                          color: AppColors.textGrey,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Divider(color: Colors.white.withOpacity(0.2))),
                                  ],
                                ),
                                const SizedBox(height: AppConstants.gapLarge),
                                Row(
                                  children: [
                                    Expanded(
                                      child: _SocialButton(
                                        icon: 'assets/images/google_logo.png', // You might need to add this asset or use an Icon
                                        label: 'Google',
                                        onTap: () {},
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _SocialButton(
                                        icon: 'assets/images/facebook_logo.png', // You might need to add this asset or use an Icon
                                        label: 'Facebook',
                                        onTap: () {},
                                      ),
                                    ),
                                  ],
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

class _SocialButton extends StatelessWidget {
  final String icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Since we might not have the assets, let's use Icons for now as placeholders if assets fail, 
            // but the user asked for social login. I'll use Icons to be safe and avoid broken images.
            Icon(
              label == 'Google' ? Icons.g_mobiledata : Icons.facebook,
              color: AppColors.textWhite,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                color: AppColors.textWhite,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
