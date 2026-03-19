import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/novels_screen.dart';
import 'screens/short_stories_screen.dart';
import 'screens/articles_screen.dart';
import 'screens/create_project_screen.dart';
import 'screens/novel_workspace_screen.dart';
import 'screens/audio_player_screen.dart';
import 'screens/gallery_screen.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const ElsewhereApp());
}

class ElsewhereApp extends StatelessWidget {
  const ElsewhereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elsewhere',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.homeTheme,
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/novels': (context) => const NovelsScreen(),
        '/short-stories': (context) => const ShortStoriesScreen(),
        '/articles': (context) => const ArticlesScreen(),
        '/create-project': (context) => const CreateProjectScreen(),
        '/novel-workspace': (context) => const NovelWorkspaceScreen(),
        '/audio-player': (context) => const AudioPlayerScreen(),
        '/gallery': (context) => const GalleryScreen(),
      },
    );
  }
}
