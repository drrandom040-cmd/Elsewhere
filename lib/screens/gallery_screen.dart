import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/app_theme.dart';
import '../widgets/persistent_audio_bar.dart';
import '../models/project_model.dart';
import 'package:uuid/uuid.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> with SingleTickerProviderStateMixin {
  String _selectedTag = 'All';
  final List<String> _tags = ['All', 'Character', 'Location', 'Mood', 'Reference'];
  final _store = ProjectStore();
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

  List<GalleryItem> get _filteredItems {
    if (_selectedTag == 'All') return _store.galleryItems;
    return _store.galleryItems.where((item) => item.tags.contains(_selectedTag)).toList();
  }

  Future<void> _addImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked == null) return;

    final item = GalleryItem(
      id: const Uuid().v4(),
      imagePath: picked.path,
      tags: [],
    );

    await _store.addGalleryItem(item);
    setState(() {});
  }

  void _showImageOptions(GalleryItem item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.audioSurface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => _ImageOptionsSheet(
        item: item,
        tags: _tags.where((t) => t != 'All').toList(),
        onTagsUpdated: (updatedTags) async {
          item.tags = updatedTags;
          await _store.addGalleryItem(item);
          setState(() {});
        },
        onDelete: () async {
          await _store.deleteGalleryItem(item.id);
          setState(() {});
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.audioBg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Column(
          children: [
            Expanded(
              child: CustomScrollView(
                slivers: [
                  SliverAppBar(
                    backgroundColor: AppColors.audioBg,
                    elevation: 0,
                    expandedHeight: 110,
                    floating: true,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    actions: [
                      GestureDetector(
                        onTap: _addImage,
                        child: Container(
                          margin: const EdgeInsets.only(right: 16),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [AppColors.audioAccent1, AppColors.audioAccent2]),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Row(children: [
                            Icon(Icons.add_photo_alternate_rounded, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                          ]),
                        ),
                      ),
                    ],
                    flexibleSpace: const FlexibleSpaceBar(
                      titlePadding: EdgeInsets.only(left: 20, bottom: 16),
                      title: Text('Gallery', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        Container(height: 2,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [AppColors.audioAccent1, AppColors.audioAccent2]),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Tag filters
                        SizedBox(
                          height: 36,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _tags.length,
                            separatorBuilder: (_, __) => const SizedBox(width: 8),
                            itemBuilder: (context, i) {
                              final tag = _tags[i];
                              final selected = _selectedTag == tag;
                              return GestureDetector(
                                onTap: () => setState(() => _selectedTag = tag),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  decoration: BoxDecoration(
                                    gradient: selected ? const LinearGradient(colors: [AppColors.audioAccent1, AppColors.audioAccent2]) : null,
                                    color: selected ? null : AppColors.audioSurface,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: selected ? Colors.transparent : Colors.white12),
                                  ),
                                  child: Center(child: Text(tag,
                                      style: TextStyle(color: Colors.white, fontSize: 13,
                                          fontWeight: selected ? FontWeight.w700 : FontWeight.w400))),
                                ),
                              );
                            },
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Image grid
                        _filteredItems.isEmpty
                            ? Container(
                                height: 200,
                                decoration: BoxDecoration(
                                  color: AppColors.audioSurface,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: AppColors.audioAccent1.withOpacity(0.2)),
                                ),
                                child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Icon(Icons.photo_library_outlined, color: AppColors.audioAccent1.withOpacity(0.5), size: 48),
                                  const SizedBox(height: 12),
                                  Text('No images yet', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 15)),
                                  const SizedBox(height: 6),
                                  Text('Tap Add to bring in visual inspiration',
                                      style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12)),
                                ]),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                                itemCount: _filteredItems.length,
                                itemBuilder: (context, i) {
                                  final item = _filteredItems[i];
                                  return GestureDetector(
                                    onLongPress: () => _showImageOptions(item),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.file(File(item.imagePath), fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Container(color: AppColors.audioSurface,
                                                child: const Icon(Icons.broken_image_rounded, color: Colors.white30))),
                                        ),
                                        if (item.tags.isNotEmpty)
                                          Positioned(bottom: 4, left: 4,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: AppColors.audioAccent1.withOpacity(0.8),
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: Text(item.tags.first, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w600)),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),

                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.audioAccent1.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.audioAccent1.withOpacity(0.3)),
                          ),
                          child: Row(children: [
                            const Icon(Icons.push_pin_rounded, color: AppColors.audioAccent1, size: 20),
                            const SizedBox(width: 10),
                            Expanded(child: Text('Long press any image to tag it or pin it to a scene.',
                                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13))),
                          ]),
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

class _ImageOptionsSheet extends StatefulWidget {
  final GalleryItem item;
  final List<String> tags;
  final Function(List<String>) onTagsUpdated;
  final VoidCallback onDelete;

  const _ImageOptionsSheet({required this.item, required this.tags, required this.onTagsUpdated, required this.onDelete});

  @override
  State<_ImageOptionsSheet> createState() => _ImageOptionsSheetState();
}

class _ImageOptionsSheetState extends State<_ImageOptionsSheet> {
  late List<String> _selectedTags;

  @override
  void initState() {
    super.initState();
    _selectedTags = List.from(widget.item.tags);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Image Options', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        const Text('Tags', style: TextStyle(color: Colors.white70, fontSize: 13)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: widget.tags.map((tag) {
            final selected = _selectedTags.contains(tag);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (selected) _selectedTags.remove(tag);
                  else _selectedTags.add(tag);
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: selected ? AppColors.audioAccent1.withOpacity(0.2) : AppColors.audioBg,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: selected ? AppColors.audioAccent1 : Colors.white12),
                ),
                child: Text(tag, style: TextStyle(color: selected ? AppColors.audioAccent1 : Colors.white70, fontWeight: FontWeight.w600)),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 20),
        Row(children: [
          Expanded(
            child: GestureDetector(
              onTap: widget.onDelete,
              child: Container(
                height: 48,
                decoration: BoxDecoration(color: Colors.red.withOpacity(0.2), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.red.withOpacity(0.4))),
                child: const Center(child: Text('Delete', style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600))),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                widget.onTagsUpdated(_selectedTags);
                Navigator.pop(context);
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [AppColors.audioAccent1, AppColors.audioAccent2]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
              ),
            ),
          ),
        ]),
        const SizedBox(height: 20),
      ]),
    );
  }
}
