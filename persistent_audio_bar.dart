import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class PersistentAudioBar extends StatefulWidget {
  const PersistentAudioBar({super.key});

  @override
  State<PersistentAudioBar> createState() => _PersistentAudioBarState();
}

class _PersistentAudioBarState extends State<PersistentAudioBar> {
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/audio-player'),
      child: Container(
        height: 70,
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.audioAccent1, AppColors.audioAccent2],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.audioAccent1.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Cover art placeholder
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.music_note_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('No song playing', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
                    Text('Tap to open library', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white, size: 30),
                onPressed: () => setState(() => isPlaying = !isPlaying),
              ),
              IconButton(
                icon: const Icon(Icons.skip_next_rounded, color: Colors.white, size: 26),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
