import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/persistent_audio_bar.dart';
import '../widgets/app_drawer.dart';

class ShortStoriesScreen extends StatelessWidget {
  const ShortStoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.storyBg,
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: AppColors.storyBg,
                  elevation: 0,
                  expandedHeight: 110,
                  floating: true,
                  leading: Builder(
                    builder: (ctx) => IconButton(
                      icon: const Icon(Icons.menu_rounded, color: Colors.white),
                      onPressed: () => Scaffold.of(ctx).openDrawer(),
                    ),
                  ),
                  flexibleSpace: const FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(left: 20, bottom: 16),
                    title: Text('Short Stories',
                        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Container(height: 2,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppColors.storyAccent1, AppColors.storyAccent1.withOpacity(0)],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text('Past Projects',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.5), letterSpacing: 1.2)),
                      const SizedBox(height: 16),

                      SizedBox(
                        height: 160,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: 4,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, i) {
                            if (i == 3) {
                              return GestureDetector(
                                onTap: () => Navigator.pushNamed(context, '/create-project'),
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: AppColors.storySurface,
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: AppColors.storyAccent1.withOpacity(0.3)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_rounded, color: AppColors.storyAccent1, size: 32),
                                      const SizedBox(height: 8),
                                      Text('Add new', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                                    ],
                                  ),
                                ),
                              );
                            }
                            return Container(
                              width: 130,
                              decoration: BoxDecoration(
                                color: AppColors.storySurface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.storyAccent2.withOpacity(0.2)),
                              ),
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [AppColors.storyAccent2.withOpacity(0.3), AppColors.storyAccent1.withOpacity(0.1)],
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Center(child: Icon(Icons.short_text_rounded, color: AppColors.storyAccent1, size: 28)),
                                  ),
                                  const SizedBox(height: 10),
                                  Text('Story ${i + 1}', style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                                  const Spacer(),
                                  Text('2,400 words', style: TextStyle(color: AppColors.storyAccent1.withOpacity(0.8), fontSize: 11)),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Dashboard modules
                      Row(
                        children: [
                          _StoryModule(label: 'Word Count', icon: Icons.bar_chart_rounded, color: AppColors.storyAccent1),
                          const SizedBox(width: 12),
                          _StoryModule(label: 'Scenes', icon: Icons.view_timeline_rounded, color: AppColors.storyAccent2),
                          const SizedBox(width: 12),
                          _StoryModule(label: 'Story', icon: Icons.edit_rounded, color: const Color(0xFF52E8FF)),
                        ],
                      ),

                      const SizedBox(height: 100),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          const PersistentAudioBar(),
        ],
      ),
    );
  }
}

class _StoryModule extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const _StoryModule({required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.storySurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
