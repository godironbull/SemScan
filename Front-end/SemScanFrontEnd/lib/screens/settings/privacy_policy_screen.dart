import 'package:flutter/material.dart';
import '../../components/custom_header.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      extendBodyBehindAppBar: true,
      appBar: const CustomHeader(
        title: 'Política de Privacidade',
        showBackButton: true,
      ),
      body: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 100,
            bottom: 20,
            left: AppConstants.paddingXL,
            right: AppConstants.paddingXL,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Coleta de Informações',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Coletamos informações que você nos fornece diretamente, como quando você cria uma conta, atualiza seu perfil ou usa nossos serviços.',
                style: TextStyle(color: AppColors.textGrey, height: 1.5),
              ),
              SizedBox(height: 24),
              Text(
                'Uso das Informações',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Usamos as informações coletadas para fornecer, manter e melhorar nossos serviços, bem como para comunicar com você sobre atualizações, promoções e eventos.',
                style: TextStyle(color: AppColors.textGrey, height: 1.5),
              ),
              SizedBox(height: 24),
              Text(
                'Compartilhamento de Informações',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Não compartilhamos suas informações pessoais com terceiros, exceto conforme descrito nesta política ou com o seu consentimento.',
                style: TextStyle(color: AppColors.textGrey, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
