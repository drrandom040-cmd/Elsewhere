import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/persistent_audio_bar.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  String _selectedTag = 'All';
  final List<String> _tags = ['All', 'Character', 'Location', 'Mood', 'Reference'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.audioBg,
      body: Column(
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
                    // Add image button
                    GestureDetector(
                      onTap: () {}, // Trigger image picker
                      child: Container(
                        margin: const EdgeInsets.only(right: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [AppColors.audioAccent1, AppColors.audioAccent2]),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.add_photo_alternate_rounded, color: Colors.white, size: 18),
                            SizedBox(width: 6),
                            Text('Add', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13)),
                          ],
                        ),
                      ),
                    ),
                  ],
                  flexibleSpace: const FlexibleSpaceBar(
                    titlePadding: EdgeInsets.only(left: 20, bottom: 16),
                    title: Text('Gallery',
                        style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)),
                  ),
                ),

                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Neon divider
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
                                  gradient: selected
                                      ? const LinearGradient(colors: [AppColors.audioAccent1, AppColors.audioAccent2])
                                      : null,
                                  color: selected ? null : AppColors.audioSurface,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: selected ? Colors.transparent : Colors.white12,
                                  ),
                                ),
                                child: Center(
                                  child: Text(tag,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          fontWeight: selected ? FontWeight.w700 : FontWeight.w400)),
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Empty state with prompt to add
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppColors.audioSurface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.audioAccent1.withOpacity(0.2)),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.photo_library_outlined,
                                color: AppColors.audioAccent1.withOpacity(0.5), size: 48),
                            const SizedBox(height: 12),
                            Text('No images yet',
                                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 15)),
                            const SizedBox(height: 6),
                            Text('Tap Add to bring in visual inspiration',
                                style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 12)),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Info card about pinning
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.audioAccent1.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: AppColors.audioAccent1.withOpacity(0.3)),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.push_pin_rounded, color: AppColors.audioAccent1, size: 20),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Long press any image to tag it or pin it to a scene or chapter.',
                                style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 13),
                              ),
                            ),
                          ],
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
    );
  }
}
