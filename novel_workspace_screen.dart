import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/persistent_audio_bar.dart';

class NovelWorkspaceScreen extends StatelessWidget {
  const NovelWorkspaceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.novelTheme,
      child: Scaffold(
        backgroundColor: AppColors.novelBg,
        body: Column(
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
                    flexibleSpace: const FlexibleSpaceBar(
                      titlePadding: EdgeInsets.only(left: 20, bottom: 16),
                      title: Text('No Salvation The Second Time',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white)),
                    ),
                  ),

                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        // Neon divider
                        Container(height: 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [AppColors.novelAccent1, AppColors.novelAccent2.withOpacity(0)],
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Stats row
                        Row(
                          children: [
                            _StatChip(label: 'Words', value: '12,400', color: AppColors.novelAccent1),
                            const SizedBox(width: 12),
                            _StatChip(label: 'Scenes', value: '8', color: AppColors.novelAccent2),
                            const SizedBox(width: 12),
                            _StatChip(label: 'Chapters', value: '3', color: const Color(0xFF7030EF)),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // Workspace modules grid
                        GridView.count(
                          crossAxisCount: 2,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          childAspectRatio: 1.1,
                          children: [
                            _WorkspaceModule(
                              title: 'Chapters',
                              subtitle: 'Write your story',
                              icon: Icons.edit_rounded,
                              color: AppColors.novelAccent1,
                              onTap: () => _openChapterEditor(context),
                            ),
                            _WorkspaceModule(
                              title: 'Scenes Planner',
                              subtitle: '8 scenes',
                              icon: Icons.view_timeline_rounded,
                              color: AppColors.novelAccent2,
                              onTap: () => _openScenesPlanner(context),
                            ),
                            _WorkspaceModule(
                              title: 'Characters',
                              subtitle: 'Character data',
                              icon: Icons.people_alt_rounded,
                              color: const Color(0xFF7030EF),
                              onTap: () => _openCharacters(context),
                            ),
                            _WorkspaceModule(
                              title: 'World Map',
                              subtitle: 'Visual graph',
                              icon: Icons.hub_rounded,
                              color: const Color(0xFF00E5CC),
                              onTap: () {},
                            ),
                            _WorkspaceModule(
                              title: 'Locations',
                              subtitle: 'Places & settings',
                              icon: Icons.location_on_rounded,
                              color: const Color(0xFFFF6B6B),
                              onTap: () {},
                            ),
                            _WorkspaceModule(
                              title: 'Word Count',
                              subtitle: 'Goal tracker',
                              icon: Icons.bar_chart_rounded,
                              color: const Color(0xFFFFD93D),
                              onTap: () {},
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // Focus Mode
                        _FocusModeCard(),

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

  void _openChapterEditor(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ChapterEditorScreen()));
  }

  void _openScenesPlanner(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const ScenesPlannerScreen()));
  }

  void _openCharacters(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const CharacterDataScreen()));
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;
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
        child: Column(
          children: [
            Text(value, style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.w800)),
            Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _WorkspaceModule extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _WorkspaceModule({
    required this.title, required this.subtitle, required this.icon,
    required this.color, required this.onTap,
  });

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const Spacer(),
            Text(title, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class _FocusModeCard extends StatefulWidget {
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
        gradient: LinearGradient(
          colors: [Colors.red.shade900.withOpacity(0.4), Colors.orange.shade900.withOpacity(0.3)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lock_clock_rounded, color: Colors.orange, size: 20),
              SizedBox(width: 8),
              Text('Focus Mode', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 4),
          Text("Lock yourself in until you hit your goal.",
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
          const SizedBox(height: 16),
          Row(
            children: [
              _FocusOption(
                label: 'Soft Lock',
                subtitle: 'Fullscreen\nfocus',
                selected: _selectedMode == 'soft',
                onTap: () => setState(() => _selectedMode = 'soft'),
              ),
              const SizedBox(width: 12),
              _FocusOption(
                label: 'Hard Lock',
                subtitle: 'Full phone\nlock',
                selected: _selectedMode == 'hard',
                onTap: () => setState(() => _selectedMode = 'hard'),
              ),
            ],
          ),
          if (_selectedMode != null) ...[
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {},
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text('Activate Focus Mode',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FocusOption extends StatelessWidget {
  final String label;
  final String subtitle;
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
              Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 11)),
            ],
          ),
        ),
      ),
    );
  }
}

// Chapter Editor Screen
class ChapterEditorScreen extends StatefulWidget {
  const ChapterEditorScreen({super.key});

  @override
  State<ChapterEditorScreen> createState() => _ChapterEditorScreenState();
}

class _ChapterEditorScreenState extends State<ChapterEditorScreen> {
  bool _bold = false;
  bool _italic = false;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.novelBg,
      appBar: AppBar(
        backgroundColor: AppColors.novelSurface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Chapter 1', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        actions: [
          IconButton(icon: const Icon(Icons.save_rounded, color: AppColors.novelAccent1), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // Formatting toolbar
          Container(
            color: AppColors.novelSurface,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _FormatButton(label: 'B', active: _bold, bold: true, onTap: () => setState(() => _bold = !_bold)),
                const SizedBox(width: 8),
                _FormatButton(label: 'I', active: _italic, italic: true, onTap: () => setState(() => _italic = !_italic)),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.image_rounded, color: Colors.white70, size: 22),
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const Spacer(),
                Text('0 words', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: _bold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: _italic ? FontStyle.italic : FontStyle.normal,
                  height: 1.7,
                ),
                decoration: InputDecoration(
                  hintText: 'Begin writing...',
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.2), fontSize: 16),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormatButton extends StatelessWidget {
  final String label;
  final bool active;
  final bool bold;
  final bool italic;
  final VoidCallback onTap;

  const _FormatButton({required this.label, required this.active, this.bold = false, this.italic = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36, height: 36,
        decoration: BoxDecoration(
          color: active ? AppColors.novelAccent1.withOpacity(0.2) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: active ? AppColors.novelAccent1 : Colors.white12),
        ),
        child: Center(
          child: Text(label,
              style: TextStyle(
                color: active ? AppColors.novelAccent1 : Colors.white,
                fontWeight: bold ? FontWeight.w900 : FontWeight.w400,
                fontStyle: italic ? FontStyle.italic : FontStyle.normal,
                fontSize: 15,
              )),
        ),
      ),
    );
  }
}

// Scenes Planner Screen
class ScenesPlannerScreen extends StatelessWidget {
  const ScenesPlannerScreen({super.key});

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
          IconButton(icon: const Icon(Icons.add_rounded, color: AppColors.novelAccent1), onPressed: () {}),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 8,
        itemBuilder: (context, i) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.novelSurface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.novelAccent1.withOpacity(0.15)),
          ),
          child: Row(
            children: [
              Container(
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: AppColors.novelAccent1.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(child: Text('${i + 1}', style: const TextStyle(color: AppColors.novelAccent1, fontWeight: FontWeight.w700))),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Scene ${i + 1}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    Text('Tap to edit', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
                  ],
                ),
              ),
              const Icon(Icons.drag_handle_rounded, color: Colors.white30),
            ],
          ),
        ),
      ),
    );
  }
}

// Character Data Screen
class CharacterDataScreen extends StatelessWidget {
  const CharacterDataScreen({super.key});

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
          IconButton(icon: const Icon(Icons.add_rounded, color: AppColors.novelAccent1), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _CharacterCard(name: 'Floyd', role: 'Main', color: AppColors.novelAccent1),
          _CharacterCard(name: 'Amelia', role: 'Supporting', color: const Color(0xFFDB1FFF)),
          _CharacterCard(name: 'Kaoru Kiken', role: 'Supporting', color: const Color(0xFFFF6B6B)),
        ],
      ),
    );
  }
}

class _CharacterCard extends StatelessWidget {
  final String name;
  final String role;
  final Color color;

  const _CharacterCard({required this.name, required this.role, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.novelSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: color.withOpacity(0.2),
              child: Text(name[0], style: TextStyle(color: color, fontWeight: FontWeight.w700))),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                Text(role, style: TextStyle(color: color.withOpacity(0.8), fontSize: 12)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white30, size: 14),
        ],
      ),
    );
  }
}
