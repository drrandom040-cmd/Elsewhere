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
      onGenerateRoute: (settings) {
        Widget page;
        switch (settings.name) {
          case '/login':
            page = const LoginScreen();
            break;
          case '/home':
            page = const HomeScreen();
            break;
          case '/novels':
            page = const NovelsScreen();
            break;
          case '/short-stories':
            page = const ShortStoriesScreen();
            break;
          case '/articles':
            page = const ArticlesScreen();
            break;
          case '/create-project':
            page = CreateProjectScreen(initialType: settings.arguments as String?);
            break;
          case '/novel-workspace':
            page = NovelWorkspaceScreen(project: settings.arguments as Map<String, String>?);
            break;
          case '/audio-player':
            page = const AudioPlayerScreen();
            break;
          case '/gallery':
            page = const GalleryScreen();
            break;
          default:
            page = const HomeScreen();
        }
        return ZoomFadeRoute(page: page);
      },
    );
  }
}

class ZoomFadeRoute extends PageRouteBuilder {
  final Widget page;
  ZoomFadeRoute({required this.page})
      : super(
          transitionDuration: const Duration(milliseconds: 350),
          reverseTransitionDuration: const Duration(milliseconds: 250),
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
            return FadeTransition(
              opacity: curved,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.92, end: 1.0).animate(curved),
                child: child,
              ),
            );
          },
        );
}
