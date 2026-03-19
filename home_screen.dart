import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/persistent_audio_bar.dart';
import '../widgets/app_drawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBg,
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  expandedHeight: 120,
                  floating: true,
                  leading: Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(Icons.menu_rounded, color: Colors.white),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.photo_library_rounded, color: Colors.white),
                      onPressed: () => Navigator.pushNamed(context, '/gallery'),
                    ),
                    const SizedBox(width: 8),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                    title: const Text(
                      'Elsewhere',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 8),
                      Text(
                        'What are you working on?',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.5),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Section Cards
                      _SectionCard(
                        title: 'Novels',
                        subtitle: 'Long-form fiction',
                        icon: Icons.menu_book_rounded,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0D1B2E), Color(0xFF1A3A5C)],
                        ),
                        accentColor: AppColors.novelAccent1,
                        onTap: () => Navigator.pushNamed(context, '/novels'),
                      ),
                      const SizedBox(height: 16),
                      _SectionCard(
                        title: 'Short Stories',
                        subtitle: 'Quick, sharp narratives',
                        icon: Icons.short_text_rounded,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A1220), Color(0xFF2D1B3D)],
                        ),
                        accentColor: AppColors.storyAccent1,
                        onTap: () => Navigator.pushNamed(context, '/short-stories'),
                      ),
                      const SizedBox(height: 16),
                      _SectionCard(
                        title: 'Articles',
                        subtitle: 'Essays & non-fiction',
                        icon: Icons.article_rounded,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF5C3D2E), Color(0xFF8B5E3C)],
                        ),
                        accentColor: AppColors.articleAccent2,
                        onTap: () => Navigator.pushNamed(context, '/articles'),
                      ),

                      const SizedBox(height: 32),

                      // Create New Project Button
                      _CreateNewButton(
                        onTap: () => Navigator.pushNamed(context, '/create-project'),
                      ),

                      const SizedBox(height: 100),
                    ]),
                  ),
                ),
              ],
            ),
          ),

          // Persistent Audio Player Bar
          const PersistentAudioBar(),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final Color accentColor;
  final VoidCallback onTap;

  const _SectionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: accentColor.withOpacity(0.3), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: accentColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accentColor, size: 26),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, color: accentColor, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreateNewButton extends StatelessWidget {
  final VoidCallback onTap;
  const _CreateNewButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 64,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.homeAccent1, AppColors.homeAccent2],
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.homeAccent1.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_rounded, color: Color(0xFF312C51), size: 24),
            SizedBox(width: 10),
            Text(
              'Create New Project',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xFF312C51),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
