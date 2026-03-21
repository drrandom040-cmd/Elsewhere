import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/persistent_audio_bar.dart';
import '../widgets/app_drawer.dart';
import '../models/project_model.dart';
import 'novel_workspace_screen.dart';

class ShortStoriesScreen extends StatefulWidget {
  const ShortStoriesScreen({super.key});

  @override
  State<ShortStoriesScreen> createState() => _ShortStoriesScreenState();
}

class _ShortStoriesScreenState extends State<ShortStoriesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  final _store = ProjectStore();

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.storyBg,
      drawer: const AppDrawer(),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
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
                          child: _store.shortStories.isEmpty
                              ? Center(child: Text('No stories yet', style: TextStyle(color: Colors.white.withOpacity(0.3))))
                              : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _store.shortStories.length + 1,
                                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                                  itemBuilder: (context, i) {
                                    if (i == _store.shortStories.length) {
                                      return _AddNewCard(onTap: () => Navigator.pushNamed(context, '/create-project', arguments: 'short_story'));
                                    }
                                    final project = _store.shortStories[i];
                                    return _ProjectCard(
                                      title: project.title,
                                      wordCount: project.wordCount.toString(),
                                      accentColor: AppColors.storyAccent1,
                                      icon: Icons.short_text_rounded,
                                      onTap: () => Navigator.push(context, PageRouteBuilder(
                                        transitionDuration: const Duration(milliseconds: 350),
                                        pageBuilder: (_, __, ___) => ShortStoryWorkspaceScreen(project: project),
                                        transitionsBuilder: (_, anim, __, child) {
                                          final c = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
                                          return FadeTransition(opacity: c, child: ScaleTransition(scale: Tween<double>(begin: 0.93, end: 1.0).animate(c), child: child));
                                        },
                                      )),
                                    );
                                  },
                                ),
                        ),

                        const SizedBox(height: 28),
                        GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/create-project', arguments: 'short_story'),
                          child: Container(
                            height: 60,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [AppColors.storyAccent2, AppColors.storyAccent1]),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(Icons.add_rounded, color: Colors.white),
                              SizedBox(width: 8),
                              Text('New Short Story', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                            ]),
                          ),
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
      ),
    );
  }
}

// ─── Short Story Workspace ─────────────────────────────────────────────────────
class ShortStoryWorkspaceScreen extends StatefulWidget {
  final ProjectModel project;
  const ShortStoryWorkspaceScreen({super.key, required this.project});
  @override
  State<ShortStoryWorkspaceScreen> createState() => _ShortStoryWorkspaceScreenState();
}

class _ShortStoryWorkspaceScreenState extends State<ShortStoryWorkspaceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
  }

  @override
  void dispose() { _fadeController.dispose(); super.dispose(); }

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.push(context, PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => screen,
      transitionsBuilder: (_, anim, __, child) {
        final c = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return FadeTransition(opacity: c, child: ScaleTransition(scale: Tween<double>(begin: 0.93, end: 1.0).animate(c), child: child));
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.storyBg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(children: [
          Expanded(
            child: CustomScrollView(slivers: [
              SliverAppBar(
                backgroundColor: AppColors.storyBg,
                elevation: 0,
                expandedHeight: 100,
                floating: true,
                leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
                  title: Text(widget.project.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    Container(height: 2, decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.storyAccent1, AppColors.storyAccent1.withOpacity(0)]))),
                    const SizedBox(height: 24),
                    Row(children: [
                      _StoryStatChip(label: 'Words', value: widget.project.wordCount.toString(), color: AppColors.storyAccent1),
                      const SizedBox(width: 12),
                      _StoryStatChip(label: 'Scenes', value: widget.project.scenes.length.toString(), color: AppColors.storyAccent2),
                    ]),
                    const SizedBox(height: 28),
                    Row(children: [
                      _StoryModule(label: 'Word Count', icon: Icons.bar_chart_rounded, color: AppColors.storyAccent1,
                          onTap: () => _openScreen(context, WordCountScreen(project: widget.project, onUpdate: () => setState(() {})))),
                      const SizedBox(width: 12),
                      _StoryModule(label: 'Scenes', icon: Icons.view_timeline_rounded, color: AppColors.storyAccent2,
                          onTap: () => _openScreen(context, ScenesPlannerScreen(project: widget.project, onUpdate: () => setState(() {})))),
                      const SizedBox(width: 12),
                      _StoryModule(label: 'Story', icon: Icons.edit_rounded, color: const Color(0xFF52E8FF),
                          onTap: () => _openScreen(context, ChapterEditorScreen(project: widget.project, onUpdate: () => setState(() {})))),
                    ]),
                    const SizedBox(height: 100),
                  ]),
                ),
              ),
            ]),
          ),
          const PersistentAudioBar(),
        ]),
      ),
    );
  }
}

class _StoryStatChip extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StoryStatChip({required this.label, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12), border: Border.all(color: color.withOpacity(0.3))),
        child: Column(children: [
          Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11)),
        ]),
      ),
    );
  }
}

class _StoryModule extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  const _StoryModule({required this.label, required this.icon, required this.color, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 80,
          decoration: BoxDecoration(color: AppColors.storySurface, borderRadius: BorderRadius.circular(14), border: Border.all(color: color.withOpacity(0.25))),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          ]),
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String title, wordCount;
  final Color accentColor;
  final IconData icon;
  final VoidCallback onTap;
  const _ProjectCard({required this.title, required this.wordCount, required this.accentColor, required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 130,
        decoration: BoxDecoration(color: AppColors.storySurface, borderRadius: BorderRadius.circular(16), border: Border.all(color: accentColor.withOpacity(0.2))),
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(height: 60, decoration: BoxDecoration(gradient: LinearGradient(colors: [accentColor.withOpacity(0.3), accentColor.withOpacity(0.1)]), borderRadius: BorderRadius.circular(10)),
            child: Center(child: Icon(icon, color: accentColor, size: 28))),
          const SizedBox(height: 10),
          Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
          const Spacer(),
          Text('$wordCount words', style: TextStyle(color: accentColor.withOpacity(0.8), fontSize: 11)),
        ]),
      ),
    );
  }
}

class _AddNewCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AddNewCard({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        decoration: BoxDecoration(color: AppColors.storySurface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.storyAccent1.withOpacity(0.3))),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.add_rounded, color: AppColors.storyAccent1, size: 32),
          const SizedBox(height: 8),
          Text('Add new', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
        ]),
      ),
    );
  }
}
