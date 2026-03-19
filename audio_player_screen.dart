import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> with SingleTickerProviderStateMixin {
  bool isPlaying = false;
  bool showPlayer = false;
  int currentIndex = 0;
  late AnimationController _pulseController;

  final List<Map<String, String>> _songs = [
    {'title': 'Dark Ambient Mix', 'artist': 'Unknown', 'duration': '3:42'},
    {'title': 'Writing Atmosphere', 'artist': 'Lo-fi Studio', 'duration': '5:10'},
    {'title': 'Manchester Rain', 'artist': 'Elsewhere', 'duration': '4:23'},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.audioTheme,
      child: Scaffold(
        backgroundColor: AppColors.audioBg,
        body: showPlayer ? _buildFullPlayer() : _buildLibrary(),
      ),
    );
  }

  Widget _buildLibrary() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(width: 8),
                const Text('Audio Library',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child: Text('Your writing soundtrack',
                style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
          ),

          // Neon divider
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              height: 2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.audioAccent1, AppColors.audioAccent2]),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Add song button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {}, // Trigger file picker
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [AppColors.audioAccent1, AppColors.audioAccent2]),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(color: AppColors.audioAccent1.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4)),
                      ],
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add_rounded, color: Colors.white, size: 18),
                        SizedBox(width: 6),
                        Text('Add New Song', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () {}, // YouTube URL input
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.audioSurface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.audioAccent1.withOpacity(0.4)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.link_rounded, color: AppColors.audioAccent2, size: 18),
                        SizedBox(width: 6),
                        Text('YouTube URL', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _songs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final song = _songs[i];
                final isActive = currentIndex == i;
                return GestureDetector(
                  onTap: () {
                    setState(() { currentIndex = i; showPlayer = true; isPlaying = true; });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.audioAccent1.withOpacity(0.15) : AppColors.audioSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isActive ? AppColors.audioAccent1 : Colors.white12,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 48, height: 48,
                          decoration: BoxDecoration(
                            gradient: isActive
                                ? const LinearGradient(colors: [AppColors.audioAccent1, AppColors.audioAccent2])
                                : null,
                            color: isActive ? null : Colors.white.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            isActive && isPlaying ? Icons.equalizer_rounded : Icons.music_note_rounded,
                            color: Colors.white, size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(song['title']!,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                      fontSize: 14)),
                              Text(song['artist']!,
                                  style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 12)),
                            ],
                          ),
                        ),
                        Text(song['duration']!,
                            style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullPlayer() {
    final song = _songs[currentIndex];
    return Container(
      decoration: BoxDecoration(
        // Blurred cover art background effect
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.5,
          colors: [
            AppColors.audioAccent1.withOpacity(0.4),
            AppColors.audioBg,
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 30),
                    onPressed: () => setState(() => showPlayer = false),
                  ),
                  const Spacer(),
                  const Text('Now Playing', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
                  const Spacer(),
                  // Queue button
                  IconButton(
                    icon: const Icon(Icons.queue_music_rounded, color: Colors.white70),
                    onPressed: () => setState(() => showPlayer = false),
                  ),
                ],
              ),
            ),

            const Spacer(),

            // Cover art
            AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Transform.scale(
                  scale: isPlaying ? 0.95 + (_pulseController.value * 0.05) : 0.85,
                  child: child,
                );
              },
              child: Container(
                width: 260, height: 260,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.audioAccent1, AppColors.audioAccent2],
                  ),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.audioAccent1.withOpacity(0.5),
                      blurRadius: 40,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(Icons.music_note_rounded, color: Colors.white, size: 80),
              ),
            ),

            const Spacer(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                children: [
                  // Song info
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(song['title']!,
                                style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                            Text(song['artist']!,
                                style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  // Progress bar
                  Column(
                    children: [
                      SliderTheme(
                        data: SliderThemeData(
                          thumbColor: Colors.white,
                          activeTrackColor: AppColors.audioAccent1,
                          inactiveTrackColor: Colors.white.withOpacity(0.15),
                          trackHeight: 3,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          overlayShape: SliderComponentShape.noOverlay,
                        ),
                        child: Slider(value: 0.35, onChanged: (_) {}),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('1:17', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
                          Text(song['duration']!, style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous_rounded, color: Colors.white.withOpacity(0.8), size: 36),
                        onPressed: () => setState(() => currentIndex = (currentIndex - 1).clamp(0, _songs.length - 1)),
                      ),
                      GestureDetector(
                        onTap: () => setState(() => isPlaying = !isPlaying),
                        child: Container(
                          width: 70, height: 70,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(colors: [AppColors.audioAccent1, AppColors.audioAccent2]),
                          ),
                          child: Icon(
                            isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            color: Colors.white, size: 36,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.skip_next_rounded, color: Colors.white.withOpacity(0.8), size: 36),
                        onPressed: () => setState(() => currentIndex = (currentIndex + 1) % _songs.length),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
