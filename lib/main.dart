import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/game_progress_provider.dart';
import 'providers/quests_provider.dart';
import 'screens/main_navigation_shell.dart';
import 'screens/onboarding/welcome_screen.dart';
import 'theme/app_colors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LingoFunApp());
}

class LingoFunApp extends StatelessWidget {
  const LingoFunApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => GameProgressProvider()),
        ChangeNotifierProvider(create: (_) => QuestsProvider()),
      ],
      child: MaterialApp(
        title: 'Lingo Fun',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.green,
            primary: AppColors.green,
            secondary: AppColors.blue,
            surface: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.white,
        textTheme: GoogleFonts.nunitoTextTheme(
          Theme.of(context).textTheme,
        ),
        useMaterial3: true,
      ),
      home: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          if (!auth.isInitialized) {
            return const Scaffold(
              backgroundColor: Colors.white,
              body: Center(
                child: CircularProgressIndicator(color: AppColors.green),
              ),
            );
          }
          if (!auth.isOnboardingCompleted) {
            return const WelcomeScreen();
          }
          return const MainNavigationShell();
        },
      ),
    ),
  );
}
}
