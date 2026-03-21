import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/persistent_audio_bar.dart';
import '../widgets/app_drawer.dart';
import '../models/project_model.dart';

class ArticlesScreen extends StatefulWidget {
  const ArticlesScreen({super.key});

  @override
  State<ArticlesScreen> createState() => _ArticlesScreenState();
}

class _ArticlesScreenState extends State<ArticlesScreen>
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
    return Theme(
      data: AppTheme.articleTheme,
      child: Scaffold(
        backgroundColor: AppColors.articleBg,
        drawer: const AppDrawer(),
        body: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            children: [
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: AppColors.articleBg,
                      elevation: 0,
                      expandedHeight: 110,
                      floating: true,
                      leading: Builder(
                        builder: (ctx) => IconButton(
                          icon: const Icon(Icons.menu_rounded, color: AppColors.articleAccent1),
                          onPressed: () => Scaffold.of(ctx).openDrawer(),
                        ),
                      ),
                      flexibleSpace: const FlexibleSpaceBar(
                        titlePadding: EdgeInsets.only(left: 20, bottom: 16),
                        title: Text('Articles',
                            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.articleAccent1)),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          Container(height: 2, color: AppColors.articleAccent2),
                          const SizedBox(height: 24),
                          Text('Past Projects',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
                                  color: AppColors.articleAccent1.withOpacity(0.6), letterSpacing: 1.2)),
                          const SizedBox(height: 16),

                          SizedBox(
                            height: 160,
                            child: _store.articles.isEmpty
                                ? Center(child: Text('No articles yet', style: TextStyle(color: AppColors.articleAccent1.withOpacity(0.4))))
                                : ListView.separated(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: _store.articles.length + 1,
                                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                                    itemBuilder: (context, i) {
                                      if (i == _store.articles.length) {
                                        return _ArticleAddCard(onTap: () => Navigator.pushNamed(context, '/create-project', arguments: 'article'));
                                      }
                                      final project = _store.articles[i];
                                      return _ArticleCard(
                                        title: project.title,
                                        onTap: () => Navigator.push(context, PageRouteBuilder(
                                          transitionDuration: const Duration(milliseconds: 350),
                                          pageBuilder: (_, __, ___) => ArticleWorkspaceScreen(project: project),
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
                            onTap: () => Navigator.pushNamed(context, '/create-project', arguments: 'article'),
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(color: AppColors.articleAccent1, borderRadius: BorderRadius.circular(16)),
                              child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                                Icon(Icons.add_rounded, color: Colors.white),
                                SizedBox(width: 8),
                                Text('New Article', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
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

// ─── Article Workspace ─────────────────────────────────────────────────────────
class ArticleWorkspaceScreen extends StatefulWidget {
  final ProjectModel project;
  const ArticleWorkspaceScreen({super.key, required this.project});
  @override
  State<ArticleWorkspaceScreen> createState() => _ArticleWorkspaceScreenState();
}

class _ArticleWorkspaceScreenState extends State<ArticleWorkspaceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  late TextEditingController _contentCtrl;
  bool _bold = false, _italic = false, _saved = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);
    _fadeController.forward();
    if (widget.project.chapters.isEmpty) widget.project.chapters.add(ChapterModel(title: 'Article'));
    _contentCtrl = TextEditingController(text: widget.project.chapters[0].content);
  }

  @override
  void dispose() { _fadeController.dispose(); _contentCtrl.dispose(); super.dispose(); }

  int get _wordCount => _contentCtrl.text.trim().isEmpty ? 0 : _contentCtrl.text.trim().split(RegExp(r'\s+')).length;

  void _save() {
    widget.project.chapters[0].content = _contentCtrl.text;
    setState(() => _saved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Article saved!'), backgroundColor: AppColors.articleAccent1));
    Future.delayed(const Duration(seconds: 2), () { if (mounted) setState(() => _saved = false); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.articleBg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(children: [
          AppBar(
            backgroundColor: AppColors.articleSurface,
            elevation: 0,
            leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: AppColors.articleAccent1), onPressed: () => Navigator.pop(context)),
            title: Text(widget.project.title, style: const TextStyle(color: AppColors.articleAccent1, fontWeight: FontWeight.w700)),
            actions: [
              IconButton(
                icon: Icon(_saved ? Icons.check_rounded : Icons.save_rounded,
                    color: _saved ? Colors.green : AppColors.articleAccent1),
                onPressed: _save,
              ),
            ],
          ),

          // Synopsis card
          if (widget.project.description.isNotEmpty)
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.articleAccent2.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.articleAccent2),
              ),
              child: Row(children: [
                const Icon(Icons.info_outline_rounded, color: AppColors.articleAccent1, size: 18),
                const SizedBox(width: 10),
                Expanded(child: Text(widget.project.description,
                    style: const TextStyle(color: AppColors.articleAccent1, fontSize: 13))),
              ]),
            ),

          // Toolbar
          Container(
            color: AppColors.articleSurface,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(children: [
              _ArticleFormatButton(label: 'B', active: _bold, bold: true, onTap: () => setState(() => _bold = !_bold)),
              const SizedBox(width: 8),
              _ArticleFormatButton(label: 'I', active: _italic, italic: true, onTap: () => setState(() => _italic = !_italic)),
              const Spacer(),
              Text('$_wordCount words', style: TextStyle(color: AppColors.articleAccent1.withOpacity(0.6), fontSize: 12)),
            ]),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _contentCtrl,
                maxLines: null,
                expands: true,
                onChanged: (_) => setState(() {}),
                style: TextStyle(
                  color: AppColors.articleText, fontSize: 16, height: 1.8,
                  fontWeight: _bold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: _italic ? FontStyle.italic : FontStyle.normal,
                ),
                decoration: InputDecoration(
                  hintText: 'Start writing your article...',
                  hintStyle: TextStyle(color: AppColors.articleText.withOpacity(0.3), fontSize: 16),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class _ArticleFormatButton extends StatelessWidget {
  final String label;
  final bool active, bold, italic;
  final VoidCallback onTap;
  const _ArticleFormatButton({required this.label, required this.active, this.bold = false, this.italic = false, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: active ? AppColors.articleAccent1.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? AppColors.articleAccent1 : AppColors.articleAccent2.withOpacity(0.4)),
        ),
        child: Center(child: Text(label, style: TextStyle(
          color: active ? AppColors.articleAccent1 : AppColors.articleAccent1.withOpacity(0.6),
          fontWeight: bold ? FontWeight.w900 : FontWeight.w400,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          fontSize: 15,
        ))),
      ),
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  const _ArticleCard({required this.title, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        decoration: BoxDecoration(color: AppColors.articleSurface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.articleAccent2.withOpacity(0.5))),
        padding: const EdgeInsets.all(14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(height: 60, decoration: BoxDecoration(color: AppColors.articleAccent1.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
            child: const Center(child: Icon(Icons.article_rounded, color: AppColors.articleAccent1, size: 28))),
          const SizedBox(height: 10),
          Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: AppColors.articleText, fontSize: 12, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }
}

class _ArticleAddCard extends StatelessWidget {
  final VoidCallback onTap;
  const _ArticleAddCard({required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 100,
        decoration: BoxDecoration(color: AppColors.articleSurface, borderRadius: BorderRadius.circular(16), border: Border.all(color: AppColors.articleAccent1.withOpacity(0.3))),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.add_rounded, color: AppColors.articleAccent1, size: 32),
          const SizedBox(height: 8),
          Text('Add new', style: TextStyle(color: AppColors.articleAccent1.withOpacity(0.7), fontSize: 12)),
        ]),
      ),
    );
  }
}
