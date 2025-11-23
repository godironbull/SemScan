import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'screens/login_screen.dart';
import 'theme/app_colors.dart';
import 'providers/story_provider.dart';
import 'providers/user_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StoryProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'SemScan',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.dark(
            primary: AppColors.primaryYellow,
            surface: AppColors.backgroundDark,
            background: AppColors.backgroundDark,
          ),
          scaffoldBackgroundColor: AppColors.backgroundDark,
          textTheme: GoogleFonts.poppinsTextTheme(),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
