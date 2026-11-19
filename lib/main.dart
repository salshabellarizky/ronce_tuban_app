import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ronce_tuban_app/pages/home_page.dart';
import 'package:ronce_tuban_app/pages/login_page.dart';
import 'package:ronce_tuban_app/providers/auth_provider.dart';
import 'package:ronce_tuban_app/providers/tradition_provider.dart';
import 'package:ronce_tuban_app/providers/quiz_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  final AuthProvider? authProvider;
  final bool loadFavorites;

  const MyApp({
    super.key,
    this.authProvider,
    this.loadFavorites = true,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => authProvider ?? (AuthProvider()..initialize()),
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = TraditionProvider();
            if (loadFavorites) provider.loadFavorit();
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) => QuizProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Ronce Tuban',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF7F5F1),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF247BA0),
            surface: const Color(0xFFF7F5F1),
            primary: const Color(0xFF247BA0),
            secondary: const Color(0xFFCE7850),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            foregroundColor: Color(0xFF1E3A4C),
            elevation: 0,
            centerTitle: false,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF247BA0),
              foregroundColor: Colors.white,
              minimumSize: const Size.fromHeight(52),
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          textTheme: ThemeData.light().textTheme.copyWith(
                titleLarge: const TextStyle(
                  color: Color(0xFF1E3A4C),
                  fontWeight: FontWeight.w700,
                ),
              ),
        ),
        home: const _AuthGate(),
      ),
    );
  }
}

class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    if (auth.isInitializing) {
      return const Scaffold(
        body: Center(
          child: Text(
            'Memuat akun...',
            style: TextStyle(color: Color(0xFF6B7A8D)),
          ),
        ),
      );
    }
    if (auth.initializationError != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.storage_rounded,
                  color: Color(0xFFCE7850),
                  size: 36,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Tidak dapat membuka penyimpanan akun di perangkat.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: auth.retryInitialization,
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    if (auth.isAuthenticated || auth.isGuest) return const HomePage();
    return const LoginPage();
  }
}
