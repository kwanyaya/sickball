import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/postgres_auth_provider.dart';
import 'providers/postgres_sick_leave_provider.dart';
import 'providers/language_provider.dart';
import 'screens/home_screen.dart';
import 'screens/modern_login_screen.dart';
import 'widgets/auth_wrapper.dart';
import 'theme/app_theme.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Note: Firebase initialization commented out to test crash isolation
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(create: (_) => PostgresAuthProvider()),
        ChangeNotifierProvider(create: (_) => PostgresSickLeaveProvider()),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, languageProvider, child) {
          return MaterialApp(
            title: 'SickBall',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,

            // Internationalization Configuration
            // TODO: Enable after fixing localization imports
            // localizationsDelegates: [
            //   AppLocalizations.delegate,
            //   GlobalMaterialLocalizations.delegate,
            //   GlobalWidgetsLocalizations.delegate,
            //   GlobalCupertinoLocalizations.delegate,
            // ],
            // supportedLocales: LanguageProvider.supportedLocales,
            // locale: languageProvider.currentLocale,
            home: const AuthWrapper(),
          );
        },
      ),
    );
  }
}

class MinimalApp extends StatelessWidget {
  const MinimalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostgresAuthProvider()),
        ChangeNotifierProvider(create: (_) => PostgresSickLeaveProvider()),
      ],
      child: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PostgresAuthProvider>(
      builder: (context, authProvider, _) {
        if (authProvider.isAuthenticated) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
