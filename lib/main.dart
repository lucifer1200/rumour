import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rumour/providers/index.dart';
import 'package:rumour/screens/index.dart';
import 'package:rumour/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: RumourApp(),
    ),
  );
}

class RumourApp extends ConsumerWidget {
  const RumourApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final firebaseAsync = ref.watch(firebaseProvider);
    final isDarkMode = ref.watch(themeModeProvider);

    return MaterialApp(
      title: 'Rumour',
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? AppTheme.darkTheme() : AppTheme.lightTheme(),
      home: firebaseAsync.when(
        data: (_) => const JoinRoomScreen(),
        loading: () => const SplashScreen(),
        error: (error, _) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error initializing app:\n$error'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
