import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class CreateProjectScreen extends StatefulWidget {
  const CreateProjectScreen({super.key});

  @override
  State<CreateProjectScreen> createState() => _CreateProjectScreenState();
}

class _CreateProjectScreenState extends State<CreateProjectScreen> {
  String? selectedType; // 'novel', 'short_story', 'article'
  int? selectedWordCount; // for novel
  bool customWordCount = false;
  final _nameController = TextEditingController();
  final _genreController = TextEditingController();
  final _descController = TextEditingController();
  final _customWCController = TextEditingController();
  int _step = 0; // 0 = select type, 1 = word count (novel only), 2 = details

  @override
  void dispose() {
    _nameController.dispose();
    _genreController.dispose();
    _descController.dispose();
    _customWCController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step == 0 && selectedType != null) {
      if (selectedType == 'novel') {
        setState(() => _step = 1);
      } else {
        setState(() => _step = 2);
      }
    } else if (_step == 1) {
      setState(() => _step = 2);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.homeBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () {
            if (_step > 0) {
              setState(() => _step--);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text('Create New Project',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _step == 0
            ? _buildTypeSelection()
            : _step == 1
                ? _buildWordCountSelection()
                : _buildDetailsForm(),
      ),
    );
  }

  Widget _buildTypeSelection() {
    return Padding(
      key: const ValueKey(0),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Type',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('What kind of project is this?',
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
          const SizedBox(height: 32),
          _TypeCard(
            title: 'Novel',
            subtitle: '50,000+ words',
            icon: Icons.menu_book_rounded,
            color: AppColors.novelAccent1,
            selected: selectedType == 'novel',
            onTap: () => setState(() => selectedType = 'novel'),
          ),
          const SizedBox(height: 16),
          _TypeCard(
            title: 'Short Story',
            subtitle: 'Under 10,000 words',
            icon: Icons.short_text_rounded,
            color: AppColors.storyAccent1,
            selected: selectedType == 'short_story',
            onTap: () => setState(() => selectedType = 'short_story'),
          ),
          const SizedBox(height: 16),
          _TypeCard(
            title: 'Article',
            subtitle: 'Essays & non-fiction',
            icon: Icons.article_rounded,
            color: AppColors.articleAccent2,
            selected: selectedType == 'article',
            onTap: () => setState(() => selectedType = 'article'),
          ),
          const Spacer(),
          if (selectedType != null)
            GestureDetector(
              onTap: _next,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.homeAccent1, AppColors.homeAccent2],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text('Continue',
                      style: TextStyle(color: Color(0xFF312C51), fontWeight: FontWeight.w700, fontSize: 16)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildWordCountSelection() {
    return Padding(
      key: const ValueKey(1),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Select Word Count',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text('Set your writing goal',
              style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
          const SizedBox(height: 32),

          _WordCountOption(label: '50,000 words', value: 50000,
              selected: selectedWordCount == 50000,
              onTap: () => setState(() { selectedWordCount = 50000; customWordCount = false; })),
          const SizedBox(height: 12),
          _WordCountOption(label: '100,000 words', value: 100000,
              selected: selectedWordCount == 100000,
              onTap: () => setState(() { selectedWordCount = 100000; customWordCount = false; })),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => setState(() { customWordCount = true; selectedWordCount = null; }),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: customWordCount ? AppColors.novelAccent1.withOpacity(0.15) : AppColors.novelSurface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: customWordCount ? AppColors.novelAccent1 : Colors.white12,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Type Your Own',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
                  if (customWordCount) ...[
                    const SizedBox(height: 10),
                    TextField(
                      controller: _customWCController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Enter word count',
                        hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
                        border: InputBorder.none,
                      ),
                    ),
                  ]
                ],
              ),
            ),
          ),

          const Spacer(),
          if (selectedWordCount != null || (customWordCount && _customWCController.text.isNotEmpty))
            GestureDetector(
              onTap: _next,
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.novelAccent2, AppColors.novelAccent1],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text('Continue',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDetailsForm() {
    final isArticle = selectedType == 'article';
    final isShortStory = selectedType == 'short_story';

    return SingleChildScrollView(
      key: const ValueKey(2),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selectedType == 'novel'
                ? 'Novel Details'
                : selectedType == 'short_story'
                    ? 'Story Details'
                    : 'Article Details',
            style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 32),

          _FormField(label: 'Name', controller: _nameController, hint: 'Project title'),
          const SizedBox(height: 20),

          if (!isArticle)
            _FormField(label: 'Genre', controller: _genreController, hint: 'e.g. Thriller, Fantasy...'),

          if (!isArticle) const SizedBox(height: 20),

          if (isShortStory)
            _FormField(label: 'Logline', controller: _descController,
                hint: 'One sentence summary', maxLines: 2),

          if (!isShortStory && !isArticle)
            _FormField(label: 'Description', controller: _descController,
                hint: 'Brief description of your novel...', maxLines: 4),

          if (isArticle)
            _FormField(label: 'Synopsis', controller: _descController,
                hint: 'What is this article about?', maxLines: 4),

          const SizedBox(height: 40),

          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, '/novel-workspace');
            },
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isArticle
                      ? [AppColors.articleAccent1, AppColors.articleAccent2]
                      : isShortStory
                          ? [AppColors.storyAccent2, AppColors.storyAccent1]
                          : [AppColors.novelAccent2, AppColors.novelAccent1],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Center(
                child: Text('Create Project',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _TypeCard({
    required this.title, required this.subtitle, required this.icon,
    required this.color, required this.selected, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.15) : AppColors.homeSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? color : Colors.white12, width: selected ? 2 : 1),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
                Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13)),
              ],
            ),
            const Spacer(),
            if (selected) Icon(Icons.check_circle_rounded, color: color),
          ],
        ),
      ),
    );
  }
}

class _WordCountOption extends StatelessWidget {
  final String label;
  final int value;
  final bool selected;
  final VoidCallback onTap;

  const _WordCountOption({required this.label, required this.value, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? AppColors.novelAccent1.withOpacity(0.15) : AppColors.novelSurface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: selected ? AppColors.novelAccent1 : Colors.white12),
        ),
        child: Row(
          children: [
            Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 15)),
            const Spacer(),
            if (selected) const Icon(Icons.check_circle_rounded, color: AppColors.novelAccent1),
          ],
        ),
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final int maxLines;

  const _FormField({required this.label, required this.controller, required this.hint, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.3)),
            filled: true,
            fillColor: AppColors.homeSurface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.white12),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.homeAccent1),
            ),
          ),
        ),
      ],
    );
  }
}
