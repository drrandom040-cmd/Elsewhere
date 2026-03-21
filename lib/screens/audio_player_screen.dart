import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:just_audio/just_audio.dart';
import '../theme/app_theme.dart';
import '../models/project_model.dart';
import 'package:uuid/uuid.dart';

class AudioPlayerScreen extends StatefulWidget {
  const AudioPlayerScreen({super.key});

  @override
  State<AudioPlayerScreen> createState() => _AudioPlayerScreenState();
}

class _AudioPlayerScreenState extends State<AudioPlayerScreen> with SingleTickerProviderStateMixin {
  bool _showPlayer = false;
  int _currentIndex = 0;
  final _store = ProjectStore();
  final _player = AudioPlayer();
  bool _isPlaying = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);

    _player.positionStream.listen((pos) { if (mounted) setState(() => _position = pos); });
    _player.durationStream.listen((dur) { if (mounted) setState(() => _duration = dur ?? Duration.zero); });
    _player.playerStateStream.listen((state) {
      if (mounted) setState(() => _isPlaying = state.playing);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _addLocalFile() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.audio);
    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    final track = AudioTrack(
      id: Uuid().v4(),
      title: file.name.replaceAll(RegExp(r'\.[^.]+$'), ''),
      source: 'local',
      path: file.path ?? '',
    );

    await _store.addAudioTrack(track);
    setState(() {});
  }

  void _showYouTubeDialog() {
    final ctrl = TextEditingController();
    showDialog(context: context, builder: (_) => AlertDialog(
      backgroundColor: AppColors.audioSurface,
      title: const Text('Add YouTube URL', style: TextStyle(color: Colors.white)),
      content: TextField(
        controller: ctrl,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'https://youtube.com/watch?v=...',
          hintStyle: TextStyle(color: Colors.white.withOpacity(0.4)),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white12)),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.white12)),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: AppColors.audioAccent1)),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.white38))),
        TextButton(onPressed: () async {
          if (ctrl.text.isNotEmpty) {
            final track = AudioTrack(id: Uuid().v4(), title: 'YouTube Track', source: 'youtube', path: ctrl.text);
            await _store.addAudioTrack(track);
            setState(() {});
            Navigator.pop(context);
          }
        }, child: const Text('Add', style: TextStyle(color: AppColors.audioAccent1))),
      ],
    ));
  }

  Future<void> _playTrack(int index) async {
    final tracks = _store.audioTracks;
    if (index >= tracks.length) return;
    final track = tracks[index];
    setState(() { _currentIndex = index; _showPlayer = true; });
    try {
      if (track.source == 'local') {
        await _player.setFilePath(track.path);
      }
      await _player.play();
    } catch (e) {
      // Handle playback error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.audioTheme,
      child: Scaffold(
        backgroundColor: AppColors.audioBg,
        body: _showPlayer ? _buildFullPlayer() : _buildLibrary(),
      ),
    );
  }

  Widget _buildLibrary() {
    final tracks = _store.audioTracks;
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(children: [
              IconButton(icon: const Icon(Icons.arrow_back_rounded, color: Colors.white), onPressed: () => Navigator.pop(context), padding: EdgeInsets.zero),
              const SizedBox(width: 8),
              const Text('Audio Library', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: Colors.white)),
            ]),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 52),
            child: Text('Your writing soundtrack', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 13)),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(height: 2,
              decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.audioAccent1, AppColors.audioAccent2]))),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              GestureDetector(
                onTap: _addLocalFile,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [AppColors.audioAccent1, AppColors.audioAccent2]),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [BoxShadow(color: AppColors.audioAccent1.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))],
                  ),
                  child: const Row(children: [
                    Icon(Icons.add_rounded, color: Colors.white, size: 18),
                    SizedBox(width: 6),
                    Text('Add Song', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ]),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _showYouTubeDialog,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: AppColors.audioSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.audioAccent1.withOpacity(0.4)),
                  ),
                  child: const Row(children: [
                    Icon(Icons.link_rounded, color: AppColors.audioAccent2, size: 18),
                    SizedBox(width: 6),
                    Text('YouTube URL', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w500, fontSize: 13)),
                  ]),
                ),
              ),
            ]),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: tracks.isEmpty
                ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.music_off_rounded, color: AppColors.audioAccent1.withOpacity(0.3), size: 64),
                    const SizedBox(height: 16),
                    Text('No tracks yet', style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 16)),
                    const SizedBox(height: 8),
                    Text('Tap Add Song to import from your device', style: TextStyle(color: Colors.white.withOpacity(0.3), fontSize: 13)),
                  ]))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    itemCount: tracks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, i) {
                      final track = tracks[i];
                      final isActive = _currentIndex == i && _showPlayer;
                      return GestureDetector(
                        onTap: () => _playTrack(i),
                        onLongPress: () {
                          showDialog(context: context, builder: (_) => AlertDialog(
                            backgroundColor: AppColors.audioSurface,
                            title: Text(track.title, style: const TextStyle(color: Colors.white)),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.white38))),
                              TextButton(onPressed: () async {
                                await _store.deleteAudioTrack(track.id);
                                setState(() {});
                                Navigator.pop(context);
                              }, child: const Text('Delete', style: TextStyle(color: Colors.red))),
                            ],
                          ));
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isActive ? AppColors.audioAccent1.withOpacity(0.15) : AppColors.audioSurface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: isActive ? AppColors.audioAccent1 : Colors.white12),
                          ),
                          child: Row(children: [
                            Container(
                              width: 48, height: 48,
                              decoration: BoxDecoration(
                                gradient: isActive ? const LinearGradient(colors: [AppColors.audioAccent1, AppColors.audioAccent2]) : null,
                                color: isActive ? null : Colors.white.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(isActive && _isPlaying ? Icons.equalizer_rounded : Icons.music_note_rounded, color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Text(track.title, style: TextStyle(color: Colors.white, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500, fontSize: 14)),
                              Text(track.source == 'youtube' ? 'YouTube' : track.artist,
                                  style: TextStyle(color: Colors.white.withOpacity(0.45), fontSize: 12)),
                            ])),
                            Icon(Icons.play_arrow_rounded, color: isActive ? AppColors.audioAccent1 : Colors.white30, size: 22),
                          ]),
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
    final tracks = _store.audioTracks;
    final track = tracks.isNotEmpty && _currentIndex < tracks.length ? tracks[_currentIndex] : null;
    final progress = _duration.inMilliseconds > 0 ? _position.inMilliseconds / _duration.inMilliseconds : 0.0;

    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.5,
          colors: [AppColors.audioAccent1.withOpacity(0.4), AppColors.audioBg],
        ),
      ),
      child: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(children: [
              IconButton(icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 30),
                  onPressed: () => setState(() => _showPlayer = false)),
              const Spacer(),
              const Text('Now Playing', style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w500)),
              const Spacer(),
              IconButton(icon: const Icon(Icons.queue_music_rounded, color: Colors.white70),
                  onPressed: () => setState(() => _showPlayer = false)),
            ]),
          ),
          const Spacer(),
          AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) => Transform.scale(
              scale: _isPlaying ? 0.95 + (_pulseController.value * 0.05) : 0.85,
              child: child,
            ),
            child: Container(
              width: 260, height: 260,
              decoration: BoxDecoration(
                gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [AppColors.audioAccent1, AppColors.audioAccent2]),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [BoxShadow(color: AppColors.audioAccent1.withOpacity(0.5), blurRadius: 40, spreadRadius: 5)],
              ),
              child: const Icon(Icons.music_note_rounded, color: Colors.white, size: 80),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(children: [
              Row(children: [
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(track?.title ?? 'No track', style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                  Text(track?.artist ?? '', style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 14)),
                ])),
              ]),
              const SizedBox(height: 28),
              SliderTheme(
                data: SliderThemeData(
                  thumbColor: Colors.white,
                  activeTrackColor: AppColors.audioAccent1,
                  inactiveTrackColor: Colors.white.withOpacity(0.15),
                  trackHeight: 3,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                  overlayShape: SliderComponentShape.noOverlay,
                ),
                child: Slider(
                  value: progress.clamp(0.0, 1.0),
                  onChanged: (val) async {
                    final pos = Duration(milliseconds: (val * _duration.inMilliseconds).round());
                    await _player.seek(pos);
                  },
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(_formatDuration(_position), style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
                Text(_formatDuration(_duration), style: TextStyle(color: Colors.white.withOpacity(0.4), fontSize: 12)),
              ]),
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                IconButton(icon: Icon(Icons.skip_previous_rounded, color: Colors.white.withOpacity(0.8), size: 36),
                    onPressed: () => _playTrack((_currentIndex - 1).clamp(0, tracks.length - 1))),
                GestureDetector(
                  onTap: () async {
                    if (_isPlaying) await _player.pause();
                    else await _player.play();
                  },
                  child: Container(
                    width: 70, height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [AppColors.audioAccent1, AppColors.audioAccent2]),
                    ),
                    child: Icon(_isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded, color: Colors.white, size: 36),
                  ),
                ),
                IconButton(icon: Icon(Icons.skip_next_rounded, color: Colors.white.withOpacity(0.8), size: 36),
                    onPressed: () => _playTrack((_currentIndex + 1) % (tracks.isEmpty ? 1 : tracks.length))),
              ]),
              const SizedBox(height: 32),
            ]),
          ),
        ]),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
