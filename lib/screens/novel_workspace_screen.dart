import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/persistent_audio_bar.dart';

class NovelWorkspaceScreen extends StatefulWidget {
  final Map<String, String>? project;
  const NovelWorkspaceScreen({super.key, this.project});

  @override
  State<NovelWorkspaceScreen> createState() => _NovelWorkspaceScreenState();
}

class _NovelWorkspaceScreenState extends State<NovelWorkspaceScreen>
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
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  String get projectTitle => widget.project?['title'] ?? 'No Salvation The Second Time';

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
                        title: Text(projectTitle,
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
                            _StatChip(label: 'Words', value: widget.project?['words'] ?? '0', color: AppColors.novelAccent1),
                            const SizedBox(width: 12),
                            _StatChip(label: 'Scenes', value: '0', color: AppColors.novelAccent2),
                            const SizedBox(width: 12),
                            _StatChip(label: 'Chapters', value: '0', color: const Color(0xFF7030EF)),
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
                              _WorkspaceModule(title: 'Chapters', subtitle: 'Write your story',
                                  icon: Icons.edit_rounded, color: AppColors.novelAccent1,
                                  onTap: () => _openScreen(context, const ChapterEditorScreen())),
                              _WorkspaceModule(title: 'Scenes Planner', subtitle: 'Plan your scenes',
                                  icon: Icons.view_timeline_rounded, color: AppColors.novelAccent2,
                                  onTap: () => _openScreen(context, const ScenesPlannerScreen())),
                              _WorkspaceModule(title: 'Characters', subtitle: 'Character data',
                                  icon: Icons.people_alt_rounded, color: const Color(0xFF7030EF),
                                  onTap: () => _openScreen(context, const CharacterDataScreen())),
                              _WorkspaceModule(title: 'World Map', subtitle: 'Visual graph',
                                  icon: Icons.hub_rounded, color: const Color(0xFF00E5CC),
                                  onTap: () => _openScreen(context, const WorldMapScreen())),
                              _WorkspaceModule(title: 'Locations', subtitle: 'Places & settings',
                                  icon: Icons.location_on_rounded, color: const Color(0xFFFF6B6B),
                                  onTap: () => _openScreen(context, const LocationsScreen())),
                              _WorkspaceModule(title: 'Word Count', subtitle: 'Goal tracker',
                                  icon: Icons.bar_chart_rounded, color: const Color(0xFFFFD93D),
                                  onTap: () => _openScreen(context, const WordCountScreen())),
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
        Text("Lock yourself in until you hit your goal.",
            style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
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
              child: const Center(child: Text('Activate Focus Mode',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
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
  const ChapterEditorScreen({super.key});

  @override
  State<ChapterEditorScreen> createState() => _ChapterEditorScreenState();
}

class _ChapterEditorScreenState extends State<ChapterEditorScreen> {
  bool _bold = false, _italic = false;
  final _controller = TextEditingController();
  int _wordCount = 0;
  bool _saved = false;

  void _countWords(String text) {
    setState(() => _wordCount = text.trim().isEmpty ? 0 : text.trim().split(RegExp(r'\s+')).length);
  }

  void _save() {
    setState(() => _saved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Chapter saved!'), backgroundColor: AppColors.novelAccent2),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _saved = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.novelBg,
      appBar: AppBar(
        backgroundColor: AppColors.novelSurface,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('Chapter 1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        actions: [
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
            const SizedBox(width: 8),
            IconButton(icon: const Icon(Icons.image_rounded, color: Colors.white70, size: 22), onPressed: () {}, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
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
              onChanged: _countWords,
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
  const ScenesPlannerScreen({super.key});

  @override
  State<ScenesPlannerScreen> createState() => _ScenesPlannerScreenState();
}

class _ScenesPlannerScreenState extends State<ScenesPlannerScreen> {
  final List<Map<String, String>> _scenes = [];

  void _addScene() {
    setState(() => _scenes.add({'title': 'Scene ${_scenes.length + 1}', 'notes': ''}));
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
        actions: [
          IconButton(icon: const Icon(Icons.add_rounded, color: AppColors.novelAccent1), onPressed: _addScene),
        ],
      ),
      body: _scenes.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(Icons.view_timeline_rounded, color: AppColors.novelAccent1.withOpacity(0.4), size: 64),
              const SizedBox(height: 16),
              Text('No scenes yet', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16)),
              const SizedBox(height: 8),
              Text('Tap + to add your first scene', style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13)),
            ]))
          : ReorderableListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _scenes.length,
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = _scenes.removeAt(oldIndex);
                  _scenes.insert(newIndex, item);
                });
              },
              itemBuilder: (context, i) {
                return Container(
                  key: ValueKey(i),
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
                    Expanded(child: Text(_scenes[i]['title']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600))),
                    const Icon(Icons.drag_handle_rounded, color: Colors.white30),
                  ]),
                );
              },
            ),
    );
  }
}

// ─── Character Data ────────────────────────────────────────────────────────────
class CharacterDataScreen extends StatefulWidget {
  const CharacterDataScreen({super.key});

  @override
  State<CharacterDataScreen> createState() => _CharacterDataScreenState();
}

class _CharacterDataScreenState extends State<CharacterDataScreen> {
  final List<Map<String, String>> _characters = [
    {'name': 'Floyd', 'role': 'Main', 'age': '', 'backstory': ''},
    {'name': 'Amelia', 'role': 'Supporting', 'age': '', 'backstory': ''},
    {'name': 'Kaoru Kiken', 'role': 'Supporting', 'age': '', 'backstory': ''},
  ];

  final List<Color> _colors = [AppColors.novelAccent1, const Color(0xFFDB1FFF), const Color(0xFFFF6B6B)];

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
            onPressed: () => setState(() => _characters.add({'name': 'New Character', 'role': 'Minor', 'age': '', 'backstory': ''}))),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _characters.length,
        itemBuilder: (context, i) {
          final color = _colors[i % _colors.length];
          return GestureDetector(
            onTap: () => _openCharacter(context, i),
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
                    child: Text(_characters[i]['name']![0], style: TextStyle(color: color, fontWeight: FontWeight.w700))),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(_characters[i]['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                  Text(_characters[i]['role']!, style: TextStyle(color: color.withOpacity(0.8), fontSize: 12)),
                ])),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white30, size: 14),
              ]),
            ),
          );
        },
      ),
    );
  }

  void _openCharacter(BuildContext context, int index) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => CharacterDetailScreen(
      character: _characters[index],
      onSave: (updated) => setState(() => _characters[index] = updated),
    )));
  }
}

class CharacterDetailScreen extends StatefulWidget {
  final Map<String, String> character;
  final Function(Map<String, String>) onSave;

  const CharacterDetailScreen({super.key, required this.character, required this.onSave});

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  late TextEditingController _nameCtrl, _ageCtrl, _backstoryCtrl, _goalCtrl, _mannerismCtrl;
  late String _selectedRole;
  final _roles = ['Main', 'Supporting', 'Minor'];

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.character['name']);
    _ageCtrl = TextEditingController(text: widget.character['age']);
    _backstoryCtrl = TextEditingController(text: widget.character['backstory']);
    _goalCtrl = TextEditingController(text: widget.character['goal'] ?? '');
    _mannerismCtrl = TextEditingController(text: widget.character['mannerisms'] ?? '');
    _selectedRole = widget.character['role'] ?? 'Minor';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.novelBg,
      appBar: AppBar(
        backgroundColor: AppColors.novelSurface,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: Text(_nameCtrl.text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        actions: [
          TextButton(
            onPressed: () {
              widget.onSave({
                'name': _nameCtrl.text, 'age': _ageCtrl.text,
                'backstory': _backstoryCtrl.text, 'goal': _goalCtrl.text,
                'mannerisms': _mannerismCtrl.text, 'role': _selectedRole,
              });
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
      TextField(
        controller: ctrl,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          filled: true, fillColor: AppColors.novelSurface,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white12)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white12)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.novelAccent1)),
        ),
      ),
    ]);
  }
}

// ─── World Map ─────────────────────────────────────────────────────────────────
class WorldMapScreen extends StatefulWidget {
  const WorldMapScreen({super.key});

  @override
  State<WorldMapScreen> createState() => _WorldMapScreenState();
}

class _WorldMapScreenState extends State<WorldMapScreen> {
  final List<Map<String, dynamic>> _nodes = [
    {'label': 'Chapter 1', 'x': 0.2, 'y': 0.2, 'color': AppColors.novelAccent1},
    {'label': 'Floyd', 'x': 0.5, 'y': 0.4, 'color': Color(0xFF7030EF)},
    {'label': 'Manchester', 'x': 0.75, 'y': 0.3, 'color': Color(0xFFFF6B6B)},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.novelBg,
      appBar: AppBar(
        backgroundColor: AppColors.novelSurface,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => Navigator.pop(context)),
        title: const Text('World Map', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(icon: const Icon(Icons.add_rounded, color: AppColors.novelAccent1), onPressed: () {
            setState(() => _nodes.add({'label': 'New Node', 'x': 0.5, 'y': 0.5, 'color': AppColors.novelAccent2}));
          }),
        ],
      ),
      body: Column(children: [
        Expanded(
          child: Stack(
            children: [
              CustomPaint(painter: _ConnectionPainter(_nodes), size: Size.infinite),
              ..._nodes.asMap().entries.map((entry) {
                final node = entry.value;
                return Positioned(
                  left: (MediaQuery.of(context).size.width * (node['x'] as double)) - 40,
                  top: (MediaQuery.of(context).size.height * 0.6 * (node['y'] as double)) - 20,
                  child: Draggable(
                    feedback: _NodeWidget(label: node['label'], color: node['color']),
                    childWhenDragging: Opacity(opacity: 0.3, child: _NodeWidget(label: node['label'], color: node['color'])),
                    onDragEnd: (details) {
                      setState(() {
                        _nodes[entry.key]['x'] = (details.offset.dx + 40) / MediaQuery.of(context).size.width;
                        _nodes[entry.key]['y'] = (details.offset.dy + 20) / (MediaQuery.of(context).size.height * 0.6);
                      });
                    },
                    child: _NodeWidget(label: node['label'], color: node['color']),
                  ),
                );
              }),
            ],
          ),
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
  final List<Map<String, dynamic>> nodes;
  _ConnectionPainter(this.nodes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white12..strokeWidth = 1;
    for (int i = 0; i < nodes.length - 1; i++) {
      final a = Offset(size.width * (nodes[i]['x'] as double), size.height * (nodes[i]['y'] as double));
      final b = Offset(size.width * (nodes[i + 1]['x'] as double), size.height * (nodes[i + 1]['y'] as double));
      canvas.drawLine(a, b, paint);
    }
  }

  @override
  bool shouldRepaint(_) => true;
}

// ─── Locations ─────────────────────────────────────────────────────────────────
class LocationsScreen extends StatefulWidget {
  const LocationsScreen({super.key});

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  final List<Map<String, String>> _locations = [
    {'name': 'Manchester City Centre', 'description': 'Main setting'},
    {'name': 'The Apartment', 'description': 'Floyd\'s residence'},
  ];

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
          IconButton(icon: const Icon(Icons.add_rounded, color: const Color(0xFFFF6B6B)),
            onPressed: () => _addLocation(context)),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _locations.length,
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
              child: const Icon(Icons.location_on_rounded, color: Color(0xFFFF6B6B), size: 22)),
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(_locations[i]['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              Text(_locations[i]['description']!, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
            ])),
          ]),
        ),
      ),
    );
  }

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
          setState(() => _locations.add({'name': nameCtrl.text, 'description': descCtrl.text}));
          Navigator.pop(context);
        }, child: const Text('Add', style: TextStyle(color: AppColors.novelAccent1))),
      ],
    ));
  }
}

// ─── Word Count ─────────────────────────────────────────────────────────────────
class WordCountScreen extends StatefulWidget {
  const WordCountScreen({super.key});

  @override
  State<WordCountScreen> createState() => _WordCountScreenState();
}

class _WordCountScreenState extends State<WordCountScreen> {
  int _current = 0;
  int _goal = 50000;
  final _ctrl = TextEditingController();

  double get _progress => (_current / _goal).clamp(0.0, 1.0);

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
          Text('$_current', style: const TextStyle(color: Colors.white, fontSize: 64, fontWeight: FontWeight.w800)),
          Text('of $_goal words', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 16)),
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
              if (val != null) setState(() => _current = val);
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
