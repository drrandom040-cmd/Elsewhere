import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E1A35),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.homeSurface,
                    child: Icon(Icons.person_rounded, color: AppColors.homeAccent1, size: 28),
                  ),
                  const SizedBox(height: 12),
                  const Text('Writer', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                  Text('elsewhere@writing.app', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
                ],
              ),
            ),
            const Divider(color: Colors.white12),
            const SizedBox(height: 8),
            _DrawerItem(icon: Icons.home_rounded, label: 'Home', onTap: () => Navigator.pushReplacementNamed(context, '/home')),
            _DrawerItem(icon: Icons.menu_book_rounded, label: 'Novels', onTap: () => Navigator.pushNamed(context, '/novels')),
            _DrawerItem(icon: Icons.short_text_rounded, label: 'Short Stories', onTap: () => Navigator.pushNamed(context, '/short-stories')),
            _DrawerItem(icon: Icons.article_rounded, label: 'Articles', onTap: () => Navigator.pushNamed(context, '/articles')),
            _DrawerItem(icon: Icons.photo_library_rounded, label: 'Gallery', onTap: () => Navigator.pushNamed(context, '/gallery')),
            _DrawerItem(icon: Icons.music_note_rounded, label: 'Audio Library', onTap: () => Navigator.pushNamed(context, '/audio-player')),
            const Divider(color: Colors.white12),
            _DrawerItem(icon: Icons.settings_rounded, label: 'Settings', onTap: () {}),
            _DrawerItem(icon: Icons.logout_rounded, label: 'Sign Out', onTap: () => Navigator.pushReplacementNamed(context, '/login')),
          ],
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _DrawerItem({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: AppColors.homeAccent1, size: 22),
      title: Text(label, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 2),
    );
  }
}
