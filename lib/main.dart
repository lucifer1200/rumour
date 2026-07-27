import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rumour/firebase_options.dart';
import 'package:rumour/blocs/index.dart';
import 'package:rumour/repositories/index.dart';
import 'package:rumour/services/index.dart';
import 'package:rumour/screens/index.dart';
import 'package:rumour/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalStorageService.init();
  runApp(const RumourApp());
}

class RumourApp extends StatelessWidget {
  const RumourApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize services
    final randomUserService = RandomUserService();
    final firestoreService = FirestoreService();
    final localStorageService = LocalStorageService();

    // Create repositories
    final userRepo = UserRepository(
      randomUserService: randomUserService,
      localStorageService: localStorageService,
    );
    final roomRepo = RoomRepository(firestoreService: firestoreService);
    final msgRepo = MessageRepository(firestoreService: firestoreService);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => UserBloc(userRepo)),
        BlocProvider(create: (_) => RoomBloc(roomRepo)),
        BlocProvider(create: (_) => ChatBloc(msgRepo)),
        BlocProvider(create: (_) => ThemeBloc()),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          final isDark = themeState is ThemeChanged ? themeState.isDark : true;

          return MaterialApp(
            title: 'Rumour',
            debugShowCheckedModeBanner: false,
            theme: isDark ? AppTheme.darkTheme() : AppTheme.lightTheme(),
            home: const JoinRoomScreen(),
          );
        },
      ),
    );
  }
}
