import 'package:flutter/material.dart';
import '../../components/custom_header.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_constants.dart';

class TermsOfUseScreen extends StatelessWidget {
  const TermsOfUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      extendBodyBehindAppBar: true,
      appBar: const CustomHeader(
        title: 'Termos de Uso',
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
                '1. Aceitação dos Termos',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Ao acessar e usar este aplicativo, você concorda em cumprir e ficar vinculado aos seguintes termos e condições de uso.',
                style: TextStyle(color: AppColors.textGrey, height: 1.5),
              ),
              SizedBox(height: 24),
              Text(
                '2. Uso do Serviço',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Você concorda em usar o serviço apenas para fins legais e de acordo com todas as leis aplicáveis. Você não deve usar o serviço para transmitir qualquer conteúdo que seja ilegal, ofensivo ou que viole os direitos de terceiros.',
                style: TextStyle(color: AppColors.textGrey, height: 1.5),
              ),
              SizedBox(height: 24),
              Text(
                '3. Propriedade Intelectual',
                style: TextStyle(
                  color: AppColors.textWhite,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Todo o conteúdo incluído neste aplicativo, como texto, gráficos, logotipos, imagens e software, é propriedade do aplicativo ou de seus fornecedores de conteúdo e é protegido pelas leis de direitos autorais.',
                style: TextStyle(color: AppColors.textGrey, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
