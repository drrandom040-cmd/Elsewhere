import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/persistent_audio_bar.dart';
import '../widgets/app_drawer.dart';
import '../models/project_model.dart';
import 'novel_workspace_screen.dart';

class NovelsScreen extends StatefulWidget {
  const NovelsScreen({super.key});

  @override
  State<NovelsScreen> createState() => _NovelsScreenState();
}

class _NovelsScreenState extends State<NovelsScreen>
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

  void _openProject(BuildContext context, ProjectModel project) {
    Navigator.push(context, PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => NovelWorkspaceScreen(project: project),
      transitionsBuilder: (_, anim, __, child) {
        final c = CurvedAnimation(parent: anim, curve: Curves.easeOutCubic);
        return FadeTransition(opacity: c, child: ScaleTransition(scale: Tween<double>(begin: 0.93, end: 1.0).animate(c), child: child));
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.novelTheme,
      child: Scaffold(
        backgroundColor: AppColors.novelBg,
        drawer: const AppDrawer(),
        body: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: AppColors.novelBg,
                      elevation: 0,
                      expandedHeight: 110,
                      floating: true,
                      leading: Builder(
                        builder: (ctx) => IconButton(
                          icon: const Icon(Icons.menu_rounded, color: Colors.white),
                          onPressed: () => Scaffold.of(ctx).openDrawer(),
                        ),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
                        title: Row(children: [
                          const Text('Novels', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                          const SizedBox(width: 8),
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.novelAccent1, shape: BoxShape.circle)),
                        ]),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          Container(height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [AppColors.novelAccent1, AppColors.novelAccent2.withOpacity(0)]),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text('Past Projects',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                                  color: Colors.white.withOpacity(0.5), letterSpacing: 1.2)),
                          const SizedBox(height: 16),

                          SizedBox(
                            height: 160,
                            child: _store.novels.isEmpty
                                ? Center(child: Text('No novels yet', style: TextStyle(color: Colors.white.withOpacity(0.3))))
                                : ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _store.novels.length + 1,
                                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                                    itemBuilder: (context, i) {
                                      if (i == _store.novels.length) {
                                        return GestureDetector(
                                          onTap: () => Navigator.pushNamed(context, '/create-project', arguments: 'novel'),
                                          child: Container(
                                            width: 100,
                                            decoration: BoxDecoration(
                                              color: AppColors.novelSurface,
                                              borderRadius: BorderRadius.circular(16),
                                              border: Border.all(color: AppColors.novelAccent1.withOpacity(0.3)),
                                            ),
                                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                              Icon(Icons.add_rounded, color: AppColors.novelAccent1, size: 32),
                                              const SizedBox(height: 8),
                                              Text('Add new', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                                            ]),
                                          ),
                                        );
                                      }
                                      final project = _store.novels[i];
                                      return GestureDetector(
                                        onTap: () => _openProject(context, project),
                                        child: Container(
                                          width: 140,
                                          decoration: BoxDecoration(
                                            color: AppColors.novelSurface,
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(color: AppColors.novelAccent1.withOpacity(0.2)),
                                          ),
                                          padding: const EdgeInsets.all(14),
                                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Container(
                                              height: 60,
                                              decoration: BoxDecoration(
                                                gradient: LinearGradient(colors: [AppColors.novelAccent2.withOpacity(0.3), AppColors.novelAccent1.withOpacity(0.1)]),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: const Center(child: Icon(Icons.menu_book_rounded, color: AppColors.novelAccent1, size: 28)),
                                            ),
                                            const SizedBox(height: 10),
                                            Text(project.title, maxLines: 2, overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                                            const Spacer(),
                                            Text('${project.wordCount} words', style: TextStyle(color: AppColors.novelAccent1.withOpacity(0.8), fontSize: 11)),
                                          ]),
                                        ),
                                      );
                                    },
                                  ),
                          ),

                          const SizedBox(height: 32),
                          GestureDetector(
                            onTap: () => Navigator.pushNamed(context, '/create-project', arguments: 'novel'),
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [AppColors.novelAccent2, AppColors.novelAccent1]),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [BoxShadow(color: AppColors.novelAccent1.withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6))],
                              ),
                              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Icon(Icons.add_rounded, color: Colors.white),
                                SizedBox(width: 8),
                                Text('New Novel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
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
      ),
    );
  }
}
