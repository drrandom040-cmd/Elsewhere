import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/persistent_audio_bar.dart';
import '../models/project_model.dart';

class NovelWorkspaceScreen extends StatefulWidget {
  final ProjectModel? project;
  const NovelWorkspaceScreen({super.key, this.project});

  @override
  State<NovelWorkspaceScreen> createState() => _NovelWorkspaceScreenState();
}

class _NovelWorkspaceScreenState extends State<NovelWorkspaceScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnim;
  late ProjectModel _project;

  @override
  void initState() {
    super.initState();
    _project = widget.project ??
        ProjectModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: 'No Salvation The Second Time',
          type: 'novel',
          characters: [
            CharacterModel(name: 'Floyd', role: 'Main'),
            CharacterModel(name: 'Amelia', role: 'Supporting'),
            CharacterModel(name: 'Kaoru Kiken', role: 'Supporting'),
          ],
          locations: [
            LocationModel(name: 'Manchester City Centre', description: 'Main setting'),
            LocationModel(name: 'The Apartment', description: "Floyd's residence"),
          ],
          worldMapNodes: [
            WorldMapNode(label: 'Chapter 1', x: 0.2, y: 0.2, colorValue: 0xFF52E8FF),
            WorldMapNode(label: 'Floyd', x: 0.5, y: 0.4, colorValue: 0xFF7030EF),
            WorldMapNode(label: 'Manchester', x: 0.75, y: 0.3, colorValue: 0xFFFF6B6B),
          ],
        );
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
      data: AppTheme.novelTheme,
      child: Scaffold(
        backgroundColor: AppColors.novelBg,
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
                      expandedHeight: 100,
                      floating: true,
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: const EdgeInsets.only(left: 60, bottom: 16),
                        title: Text(_project.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          Container(height: 2,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [AppColors.novelAccent1, AppColors.novelAccent2.withOpacity(0)],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(children: [
                            _StatChip(label: 'Words', value: _project.wordCount.toString(), color: AppColors.novelAccent1),
                            const SizedBox(width: 12),
                            _StatChip(label: 'Scenes', value: _project.scenes.length.toString(), color: AppColors.novelAccent2),
                            const SizedBox(width: 12),
                            _StatChip(label: 'Chapters', value: _project.chapters.length.toString(), color: const Color(0xFF7030EF)),
                          ]),
                          const SizedBox(height: 28),
                          GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            childAspectRatio: 1.1,
                            children: [
                              _WorkspaceModule(title: 'Chapters', subtitle: '${_project.chapters.length} chapters',
                                  icon: Icons.edit_rounded, color: AppColors.novelAccent1,
                                  onTap: () => _openScreen(context, ChapterEditorScreen(project: _project, onUpdate: () => setState(() {})))),
                              _WorkspaceModule(title: 'Scenes Planner', subtitle: '${_project.scenes.length} scenes',
                                  icon: Icons.view_timeline_rounded, color: AppColors.novelAccent2,
                                  onTap: () => _openScreen(context, ScenesPlannerScreen(project: _project, onUpdate: () => setState(() {})))),
                              _WorkspaceModule(title: 'Characters', subtitle: '${_project.characters.length} characters',
                                  icon: Icons.people_alt_rounded, color: const Color(0xFF7030EF),
                                  onTap: () => _openScreen(context, CharacterDataScreen(project: _project, onUpdate: () => setState(() {})))),
                              _WorkspaceModule(title: 'World Map', subtitle: 'Visual graph',
                                  icon: Icons.hub_rounded, color: const Color(0xFF00E5CC),
                                  onTap: () => _openScreen(context, WorldMapScreen(project: _project, onUpdate: () => setState(() {})))),
                              _WorkspaceModule(title: 'Locations', subtitle: '${_project.locations.length} locations',
                                  icon: Icons.location_on_rounded, color: const Color(0xFFFF6B6B),
                                  onTap: () => _openScreen(context, LocationsScreen(project: _project, onUpdate: () => setState(() {})))),
                              _WorkspaceModule(title: 'Word Count', subtitle: 'Goal tracker',
                                  icon: Icons.bar_chart_rounded, color: const Color(0xFFFFD93D),
                                  onTap: () => _openScreen(context, WordCountScreen(project: _project, onUpdate: () => setState(() {})))),
                            ],
                          ),
                          const SizedBox(height: 28),
                          const _FocusModeCard(),
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

  void _openScreen(BuildContext context, Widget screen) {
    Navigator.push(context, PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) => screen,
      transitionsBuilder: (_, animation, __, child) {
        final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(scale: Tween<double>(begin: 0.93, end: 1.0).animate(curved), child: child),
        );
      },
    ));
  }
}

class _StatChip extends StatelessWidget {
  final String label, value;
  final Color color;
  const _StatChip({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(children: [
          Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11)),
        ]),
      ),
    );
  }
}

class _WorkspaceModule extends StatelessWidget {
  final String title, subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _WorkspaceModule({required this.title, required this.subtitle, required this.icon,
      required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.novelSurface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(width: 44, height: 44,
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 22)),
          const Spacer(),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 12)),
        ]),
      ),
    );
  }
}

class _FocusModeCard extends StatefulWidget {
  const _FocusModeCard();
  @override
  State<_FocusModeCard> createState() => _FocusModeCardState();
}

class _FocusModeCardState extends State<_FocusModeCard> {
  String? _selectedMode;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.red.shade900.withOpacity(0.4), Colors.orange.shade900.withOpacity(0.3)]),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [
          Icon(Icons.lock_clock_rounded, color: Colors.orange, size: 20),
          SizedBox(width: 8),
          Text('Focus Mode', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
        ]),
        const SizedBox(height: 4),
        Text("Lock yourself in until you hit your goal.", style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
        const SizedBox(height: 16),
        Row(children: [
          _FocusOption(label: 'Soft Lock', subtitle: 'Fullscreen\nfocus',
              selected: _selectedMode == 'soft', onTap: () => setState(() => _selectedMode = 'soft')),
          const SizedBox(width: 12),
          _FocusOption(label: 'Hard Lock', subtitle: 'Full phone\nlock',
              selected: _selectedMode == 'hard', onTap: () => setState(() => _selectedMode = 'hard')),
        ]),
        if (_selectedMode != null) ...[
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 48,
              decoration: BoxDecoration(color: Colors.orange.withOpacity(0.8), borderRadius: BorderRadius.circular(12)),
              child: const Center(child: Text('Activate Focus Mode', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
            ),
          ),
        ],
      ]),
    );
  }
}

class _FocusOption extends StatelessWidget {
  final String label, subtitle;
  final bool selected;
  final VoidCallback onTap;
  const _FocusOption({required this.label, required this.subtitle, required this.selected, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? Colors.orange.withOpacity(0.2) : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: selected ? Colors.orange : Colors.white12),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
            Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 11)),
          ]),
        ),
      ),
    );
  }
}

// ─── Chapter Editor ───────────────────────────────────────────────────────────
class ChapterEditorScreen extends StatefulWidget {
  final ProjectModel project;
  final VoidCallback onUpdate;
  const ChapterEditorScreen({super.key, required this.project, required this.onUpdate});
  @override
  State<ChapterEditorScreen> createState() => _ChapterEditorScreenState();
}

class _ChapterEditorScreenState extends State<ChapterEditorScreen> {
  bool _bold = false, _italic = false;
  int _currentChapter = 0;
  late TextEditingController _controller;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    if (widget.project.chapters.isEmpty) {
      widget.project.chapters.add(ChapterModel(title: 'Chapter 1'));
    }
    _controller = TextEditingController(text: widget.project.chapters[_currentChapter].content);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _wordCount => _controller.text.trim().isEmpty ? 0 : _controller.text.trim().split(RegExp(r'\s+')).length;

  void _save() {
    widget.project.chapters[_currentChapter].content = _controller.text;
    setState(() => _saved = true);
    widget.onUpdate();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chapter saved!'), backgroundColor: AppColors.novelAccent2));
    Future.delayed(const Duration(seconds: 2), () { if (mounted) setState(() => _saved = false); });
  }

  void _addChapter() {
    final num = widget.project.chapters.length + 1;
    widget.project.chapters.add(ChapterModel(title: 'Chapter $num'));
    setState(() { _currentChapter = widget.project.chapters.length - 1; _controller.text = ''; });
    widget.onUpdate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.novelBg,
      appBar: AppBar(
        backgroundColor: AppColors.novelSurface,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: DropdownButton<int>(
          value: _currentChapter,
          dropdownColor: AppColors.novelSurface,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          underline: const SizedBox(),
          items: widget.project.chapters.asMap().entries.map((e) =>
            DropdownMenuItem(value: e.key, child: Text(e.value.title))).toList(),
          onChanged: (val) {
            if (val != null) {
              widget.project.chapters[_currentChapter].content = _controller.text;
              setState(() { _currentChapter = val; _controller.text = widget.project.chapters[val].content; });
            }
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.add_rounded, color: AppColors.novelAccent1), onPressed: _addChapter),
          IconButton(
            icon: Icon(_saved ? Icons.check_rounded : Icons.save_rounded,
                color: _saved ? Colors.green : AppColors.novelAccent1),
            onPressed: _save,
          ),
        ],
      ),
      body: Column(children: [
        Container(
          color: AppColors.novelSurface,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(children: [
            _FormatButton(label: 'B', active: _bold, bold: true, onTap: () => setState(() => _bold = !_bold)),
            const SizedBox(width: 8),
            _FormatButton(label: 'I', active: _italic, italic: true, onTap: () => setState(() => _italic = !_italic)),
            const SizedBox(width: 16),
            Icon(Icons.image_rounded, color: Colors.white.withOpacity(0.5), size: 22),
            const Spacer(),
            Text('$_wordCount words', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
          ]),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              controller: _controller,
              maxLines: null,
              expands: true,
              onChanged: (_) => setState(() {}),
              style: TextStyle(
                color: Colors.white, fontSize: 16, height: 1.7,
                fontWeight: _bold ? FontWeight.bold : FontWeight.normal,
                fontStyle: _italic ? FontStyle.italic : FontStyle.normal,
              ),
              decoration: InputDecoration(
                hintText: 'Begin writing...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 16),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class _FormatButton extends StatelessWidget {
  final String label;
  final bool active, bold, italic;
  final VoidCallback onTap;
  const _FormatButton({required this.label, required this.active, this.bold = false, this.italic = false, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: active ? AppColors.novelAccent1.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? AppColors.novelAccent1 : Colors.white12),
        ),
        child: Center(child: Text(label, style: TextStyle(
          color: active ? AppColors.novelAccent1 : Colors.white,
          fontWeight: bold ? FontWeight.w900 : FontWeight.w400,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          fontSize: 15,
        ))),
      ),
    );
  }
}

// ─── Scenes Planner ───────────────────────────────────────────────────────────
class ScenesPlannerScreen extends StatefulWidget {
  final ProjectModel project;
  final VoidCallback onUpdate;
  const ScenesPlannerScreen({super.key, required this.project, required this.onUpdate});
  @override
  State<ScenesPlannerScreen> createState() => _ScenesPlannerScreenState();
}

class _ScenesPlannerScreenState extends State<ScenesPlannerScreen> {
  void _addScene() {
    setState(() => widget.project.scenes.add(SceneModel(title: 'Scene ${widget.project.scenes.length + 1}')));
    widget.onUpdate();
  }

  void _editScene(int index) {
    final titleCtrl = TextEditingController(text: widget.project.scenes[index].title);
    final notesCtrl = TextEditingController(text: widget.project.scenes[index].notes);
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.novelSurface,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, left: 20, right: 20, top: 20),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Edit Scene', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 16),
          TextField(controller: titleCtrl, style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(labelText: 'Scene title', labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              filled: true, fillColor: AppColors.novelBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
          const SizedBox(height: 12),
          TextField(controller: notesCtrl, maxLines: 4, style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(labelText: 'What happens in this scene?', labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              filled: true, fillColor: AppColors.novelBg,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none))),
          const SizedBox(height: 16),
          Row(children: [
            Expanded(child: TextButton(onPressed: () => Navigator.pop(context),
              child: const Text('Cancel', style: TextStyle(color: Colors.white38)))),
            Expanded(child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.novelAccent1),
              onPressed: () {
                setState(() {
                  widget.project.scenes[index].title = titleCtrl.text;
                  widget.project.scenes[index].notes = notesCtrl.text;
                });
                widget.onUpdate();
                Navigator.pop(context);
              },
              child: const Text('Save', style: TextStyle(color: Colors.white)))),
          ]),
          const SizedBox(height: 20),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.novelBg,
      appBar: AppBar(
        backgroundColor: AppColors.novelSurface,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('Scenes Planner', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        actions: [IconButton(icon: const Icon(Icons.add_rounded, color: AppColors.novelAccent1), onPressed: _addScene)],
      ),
      body: widget.project.scenes.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.view_timeline_rounded, color: AppColors.novelAccent1.withOpacity(0.4), size: 64),
              const SizedBox(height: 16),
              Text('No scenes yet', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16)),
              const SizedBox(height: 8),
              Text('Tap + to add your first scene', style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13)),
            ]))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: widget.project.scenes.length,
              itemBuilder: (context, i) {
                final scene = widget.project.scenes[i];
                return GestureDetector(
                  onTap: () => _editScene(i),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.novelSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.novelAccent1.withOpacity(0.15)),
                    ),
                    child: Row(children: [
                      Container(width: 32, height: 32,
                        decoration: BoxDecoration(color: AppColors.novelAccent1.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
                        child: Center(child: Text('${i + 1}', style: const TextStyle(color: AppColors.novelAccent1, fontWeight: FontWeight.w700)))),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(scene.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        if (scene.notes.isNotEmpty)
                          Text(scene.notes, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
                      ])),
                      const Icon(Icons.edit_rounded, color: Colors.white30, size: 16),
                    ]),
                  ),
                );
              },
            ),
    );
  }
}

// ─── Character Data ────────────────────────────────────────────────────────────
class CharacterDataScreen extends StatefulWidget {
  final ProjectModel project;
  final VoidCallback onUpdate;
  const CharacterDataScreen({super.key, required this.project, required this.onUpdate});
  @override
  State<CharacterDataScreen> createState() => _CharacterDataScreenState();
}

class _CharacterDataScreenState extends State<CharacterDataScreen> {
  final List<Color> _colors = [AppColors.novelAccent1, const Color(0xFFDB1FFF), const Color(0xFFFF6B6B), const Color(0xFFFFD93D)];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.novelBg,
      appBar: AppBar(
        backgroundColor: AppColors.novelSurface,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('Characters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(icon: const Icon(Icons.add_rounded, color: AppColors.novelAccent1),
            onPressed: () {
              setState(() => widget.project.characters.add(CharacterModel(name: 'New Character')));
              widget.onUpdate();
            }),
        ],
      ),
      body: widget.project.characters.isEmpty
          ? Center(child: Text('No characters yet. Tap + to add.', style: TextStyle(color: Colors.white.withOpacity(0.5))))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: widget.project.characters.length,
              itemBuilder: (context, i) {
                final color = _colors[i % _colors.length];
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) =>
                    CharacterDetailScreen(character: widget.project.characters[i], onSave: (c) {
                      setState(() => widget.project.characters[i] = c);
                      widget.onUpdate();
                    }))),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.novelSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Row(children: [
                      CircleAvatar(backgroundColor: color.withOpacity(0.2),
                          child: Text(widget.project.characters[i].name.isEmpty ? '?' : widget.project.characters[i].name[0],
                              style: TextStyle(color: color, fontWeight: FontWeight.w700))),
                      const SizedBox(width: 14),
                      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(widget.project.characters[i].name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                        Text(widget.project.characters[i].role, style: TextStyle(color: color.withOpacity(0.8), fontSize: 12)),
                      ])),
                      const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white30, size: 14),
                    ]),
                  ),
                );
              },
            ),
    );
  }
}

class CharacterDetailScreen extends StatefulWidget {
  final CharacterModel character;
  final Function(CharacterModel) onSave;
  const CharacterDetailScreen({super.key, required this.character, required this.onSave});
  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  late TextEditingController _nameCtrl, _ageCtrl, _backstoryCtrl, _goalCtrl, _mannerismCtrl, _genderCtrl, _langCtrl;
  late String _selectedRole;
  final _roles = ['Main', 'Supporting', 'Minor'];

  @override
  void initState() {
    super.initState();
    final c = widget.character;
    _nameCtrl = TextEditingController(text: c.name);
    _ageCtrl = TextEditingController(text: c.age);
    _backstoryCtrl = TextEditingController(text: c.backstory);
    _goalCtrl = TextEditingController(text: c.goal);
    _mannerismCtrl = TextEditingController(text: c.mannerisms);
    _genderCtrl = TextEditingController(text: c.gender);
    _langCtrl = TextEditingController(text: c.languageStyle);
    _selectedRole = c.role;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.novelBg,
      appBar: AppBar(
        backgroundColor: AppColors.novelSurface,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text(_nameCtrl.text.isEmpty ? 'Character' : _nameCtrl.text,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
            onPressed: () {
              widget.onSave(CharacterModel(
                name: _nameCtrl.text, age: _ageCtrl.text, backstory: _backstoryCtrl.text,
                goal: _goalCtrl.text, mannerisms: _mannerismCtrl.text,
                gender: _genderCtrl.text, languageStyle: _langCtrl.text, role: _selectedRole,
              ));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Character saved!'), backgroundColor: AppColors.novelAccent2));
            },
            child: const Text('Save', style: TextStyle(color: AppColors.novelAccent1, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _field('Name', _nameCtrl),
          const SizedBox(height: 16),
          _field('Age', _ageCtrl),
          const SizedBox(height: 16),
          _field('Gender', _genderCtrl),
          const SizedBox(height: 16),
          Text('Role', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Row(children: _roles.map((role) {
            final selected = _selectedRole == role;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => setState(() => _selectedRole = role),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.novelAccent1.withOpacity(0.2) : AppColors.novelSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: selected ? AppColors.novelAccent1 : Colors.white12),
                  ),
                  child: Text(role, style: TextStyle(color: selected ? AppColors.novelAccent1 : Colors.white, fontWeight: FontWeight.w600)),
                ),
              ),
            );
          }).toList()),
          const SizedBox(height: 16),
          _field('Language Style', _langCtrl),
          const SizedBox(height: 16),
          _field('Mannerisms', _mannerismCtrl, maxLines: 2),
          const SizedBox(height: 16),
          _field('Goal', _goalCtrl, maxLines: 2),
          const SizedBox(height: 16),
          _field('Backstory', _backstoryCtrl, maxLines: 4),
        ]),
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, {int maxLines = 1}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      TextField(controller: ctrl, maxLines: maxLines, style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true, fillColor: AppColors.novelSurface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white12)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white12)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.novelAccent1)),
        )),
    ]);
  }
}

// ─── World Map ─────────────────────────────────────────────────────────────────
class WorldMapScreen extends StatefulWidget {
  final ProjectModel project;
  final VoidCallback onUpdate;
  const WorldMapScreen({super.key, required this.project, required this.onUpdate});
  @override
  State<WorldMapScreen> createState() => _WorldMapScreenState();
}

class _WorldMapScreenState extends State<WorldMapScreen> {
  @override
  Widget build(BuildContext context) {
    final nodes = widget.project.worldMapNodes;
    return Scaffold(
      backgroundColor: AppColors.novelBg,
      appBar: AppBar(
        backgroundColor: AppColors.novelSurface,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('World Map', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(icon: const Icon(Icons.add_rounded, color: AppColors.novelAccent1), onPressed: () {
            setState(() => nodes.add(WorldMapNode(label: 'New Node', x: 0.5, y: 0.5)));
            widget.onUpdate();
          }),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            return Stack(children: [
              CustomPaint(painter: _ConnectionPainter(nodes, constraints.maxWidth, constraints.maxHeight), size: Size.infinite),
              ...nodes.asMap().entries.map((entry) {
                final node = entry.value;
                return Positioned(
                  left: constraints.maxWidth * node.x - 40,
                  top: constraints.maxHeight * node.y - 20,
                  child: Draggable(
                    feedback: _NodeWidget(label: node.label, color: Color(node.colorValue)),
                    childWhenDragging: Opacity(opacity: 0.3, child: _NodeWidget(label: node.label, color: Color(node.colorValue))),
                    onDragEnd: (details) {
                      final box = context.findRenderObject() as RenderBox;
                      final local = box.globalToLocal(details.offset);
                      setState(() {
                        nodes[entry.key].x = (local.dx / constraints.maxWidth).clamp(0.05, 0.95);
                        nodes[entry.key].y = (local.dy / constraints.maxHeight).clamp(0.05, 0.95);
                      });
                      widget.onUpdate();
                    },
                    child: _NodeWidget(label: node.label, color: Color(node.colorValue)),
                  ),
                );
              }),
            ]);
          }),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text('Drag nodes to rearrange. Tap + to add elements.',
              style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12), textAlign: TextAlign.center),
        ),
      ]),
    );
  }
}

class _NodeWidget extends StatelessWidget {
  final String label;
  final Color color;
  const _NodeWidget({required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12)),
    );
  }
}

class _ConnectionPainter extends CustomPainter {
  final List<WorldMapNode> nodes;
  final double width, height;
  _ConnectionPainter(this.nodes, this.width, this.height);
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white12..strokeWidth = 1;
    for (int i = 0; i < nodes.length - 1; i++) {
      final a = Offset(width * nodes[i].x, height * nodes[i].y);
      final b = Offset(width * nodes[i + 1].x, height * nodes[i + 1].y);
      canvas.drawLine(a, b, paint);
    }
  }
  @override
  bool shouldRepaint(_) => true;
}

// ─── Locations ─────────────────────────────────────────────────────────────────
class LocationsScreen extends StatefulWidget {
  final ProjectModel project;
  final VoidCallback onUpdate;
  const LocationsScreen({super.key, required this.project, required this.onUpdate});
  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  void _addLocation(BuildContext context) {
    final nameCtrl = TextEditingController();
    final descCtrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: AppColors.novelSurface,
      title: const Text('Add Location', style: TextStyle(color: Colors.white)),
      content: Column(mainAxisSize: MainAxisSize.min, children: [
        TextField(controller: nameCtrl, style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(hintText: 'Location name', hintStyle: TextStyle(color: Colors.white38))),
        TextField(controller: descCtrl, style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(hintText: 'Description', hintStyle: TextStyle(color: Colors.white38))),
      ]),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.white38))),
        TextButton(onPressed: () {
          setState(() => widget.project.locations.add(LocationModel(name: nameCtrl.text, description: descCtrl.text)));
          widget.onUpdate();
          Navigator.pop(context);
        }, child: const Text('Add', style: TextStyle(color: AppColors.novelAccent1))),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.novelBg,
      appBar: AppBar(
        backgroundColor: AppColors.novelSurface,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('Locations', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(icon: Icon(Icons.add_rounded, color: Color(0xFFFF6B6B)), onPressed: () => _addLocation(context)),
        ],
      ),
      body: widget.project.locations.isEmpty
          ? Center(child: Text('No locations yet. Tap + to add.', style: TextStyle(color: Colors.white.withOpacity(0.5))))
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: widget.project.locations.length,
              itemBuilder: (context, i) => Container(
                margin: const EdgeInsets.only(bottom: 14),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.novelSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFFF6B6B).withOpacity(0.3)),
                ),
                child: Row(children: [
                  Container(width: 44, height: 44,
                    decoration: BoxDecoration(color: const Color(0xFFFF6B6B).withOpacity(0.15), borderRadius: BorderRadius.circular(12)),
                    child: Icon(Icons.location_on_rounded, color: Color(0xFFFF6B6B), size: 22)),
                  const SizedBox(width: 14),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(widget.project.locations[i].name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                    Text(widget.project.locations[i].description, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
                  ])),
                ]),
              ),
            ),
    );
  }
}

// ─── Word Count ─────────────────────────────────────────────────────────────────
class WordCountScreen extends StatefulWidget {
  final ProjectModel project;
  final VoidCallback onUpdate;
  const WordCountScreen({super.key, required this.project, required this.onUpdate});
  @override
  State<WordCountScreen> createState() => _WordCountScreenState();
}

class _WordCountScreenState extends State<WordCountScreen> {
  final _ctrl = TextEditingController();
  double get _progress => (widget.project.wordCount / widget.project.goalWordCount).clamp(0.0, 1.0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.novelBg,
      appBar: AppBar(
        backgroundColor: AppColors.novelSurface,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('Word Count', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          const SizedBox(height: 20),
          Text('${widget.project.wordCount}', style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.w800)),
          Text('of ${widget.project.goalWordCount} words', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16)),
          const SizedBox(height: 32),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation(AppColors.novelAccent1),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text('${(_progress * 100).toStringAsFixed(1)}% complete',
              style: TextStyle(color: AppColors.novelAccent1.withOpacity(0.8), fontSize: 13)),
          const SizedBox(height: 40),
          TextField(
            controller: _ctrl,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              labelText: 'Update word count',
              labelStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
              filled: true, fillColor: AppColors.novelSurface,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            ),
          ),
          const SizedBox(height: 16),
          GestureDetector(
            onTap: () {
              final val = int.tryParse(_ctrl.text);
              if (val != null) {
                setState(() => widget.project.wordCount = val);
                widget.onUpdate();
              }
            },
            child: Container(
              width: double.infinity, height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [AppColors.novelAccent2, AppColors.novelAccent1]),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Center(child: Text('Update', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16))),
            ),
          ),
        ]),
      ),
    );
  }
}
