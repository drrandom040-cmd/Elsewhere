import 'package:hive/hive.dart';

part 'project_model.g.dart';

@HiveType(typeId: 0)
class ProjectModel extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late String type; // 'novel', 'short_story', 'article'

  @HiveField(3)
  late String genre;

  @HiveField(4)
  late String description;

  @HiveField(5)
  late int wordCount;

  @HiveField(6)
  late int goalWordCount;

  @HiveField(7)
  late List<SceneModel> scenes;

  @HiveField(8)
  late List<CharacterModel> characters;

  @HiveField(9)
  late List<LocationModel> locations;

  @HiveField(10)
  late List<WorldMapNode> worldMapNodes;

  @HiveField(11)
  late List<ChapterModel> chapters;

  @HiveField(12)
  late DateTime createdAt;

  @HiveField(13)
  late DateTime updatedAt;

  ProjectModel({
    required this.id,
    required this.title,
    required this.type,
    this.genre = '',
    this.description = '',
    this.wordCount = 0,
    this.goalWordCount = 50000,
    List<SceneModel>? scenes,
    List<CharacterModel>? characters,
    List<LocationModel>? locations,
    List<WorldMapNode>? worldMapNodes,
    List<ChapterModel>? chapters,
    DateTime? createdAt,
    DateTime? updatedAt,
  })  : scenes = scenes ?? [],
        characters = characters ?? [],
        locations = locations ?? [],
        worldMapNodes = worldMapNodes ?? [],
        chapters = chapters ?? [],
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'genre': genre,
      'description': description,
      'wordCount': wordCount,
      'goalWordCount': goalWordCount,
      'scenes': scenes.map((s) => s.toMap()).toList(),
      'characters': characters.map((c) => c.toMap()).toList(),
      'locations': locations.map((l) => l.toMap()).toList(),
      'worldMapNodes': worldMapNodes.map((n) => n.toMap()).toList(),
      'chapters': chapters.map((ch) => ch.toMap()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    };
  }

  factory ProjectModel.fromFirestore(Map<String, dynamic> data) {
    return ProjectModel(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      type: data['type'] ?? 'novel',
      genre: data['genre'] ?? '',
      description: data['description'] ?? '',
      wordCount: data['wordCount'] ?? 0,
      goalWordCount: data['goalWordCount'] ?? 50000,
      scenes: (data['scenes'] as List<dynamic>?)?.map((s) => SceneModel.fromMap(s)).toList() ?? [],
      characters: (data['characters'] as List<dynamic>?)?.map((c) => CharacterModel.fromMap(c)).toList() ?? [],
      locations: (data['locations'] as List<dynamic>?)?.map((l) => LocationModel.fromMap(l)).toList() ?? [],
      worldMapNodes: (data['worldMapNodes'] as List<dynamic>?)?.map((n) => WorldMapNode.fromMap(n)).toList() ?? [],
      chapters: (data['chapters'] as List<dynamic>?)?.map((ch) => ChapterModel.fromMap(ch)).toList() ?? [],
      createdAt: DateTime.tryParse(data['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(data['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

@HiveType(typeId: 1)
class SceneModel {
  @HiveField(0)
  String title;

  @HiveField(1)
  String notes;

  @HiveField(2)
  String linkedChapter;

  SceneModel({this.title = '', this.notes = '', this.linkedChapter = ''});

  Map<String, dynamic> toMap() => {'title': title, 'notes': notes, 'linkedChapter': linkedChapter};
  factory SceneModel.fromMap(Map<String, dynamic> m) => SceneModel(title: m['title'] ?? '', notes: m['notes'] ?? '', linkedChapter: m['linkedChapter'] ?? '');
}

@HiveType(typeId: 2)
class CharacterModel {
  @HiveField(0) String name;
  @HiveField(1) String role;
  @HiveField(2) String age;
  @HiveField(3) String mannerisms;
  @HiveField(4) String goal;
  @HiveField(5) String backstory;
  @HiveField(6) String gender;
  @HiveField(7) String languageStyle;

  CharacterModel({
    this.name = '', this.role = 'Minor', this.age = '',
    this.mannerisms = '', this.goal = '', this.backstory = '',
    this.gender = '', this.languageStyle = '',
  });

  Map<String, dynamic> toMap() => {
    'name': name, 'role': role, 'age': age, 'mannerisms': mannerisms,
    'goal': goal, 'backstory': backstory, 'gender': gender, 'languageStyle': languageStyle,
  };
  factory CharacterModel.fromMap(Map<String, dynamic> m) => CharacterModel(
    name: m['name'] ?? '', role: m['role'] ?? 'Minor', age: m['age'] ?? '',
    mannerisms: m['mannerisms'] ?? '', goal: m['goal'] ?? '', backstory: m['backstory'] ?? '',
    gender: m['gender'] ?? '', languageStyle: m['languageStyle'] ?? '',
  );
}

@HiveType(typeId: 3)
class LocationModel {
  @HiveField(0) String name;
  @HiveField(1) String description;

  LocationModel({this.name = '', this.description = ''});

  Map<String, dynamic> toMap() => {'name': name, 'description': description};
  factory LocationModel.fromMap(Map<String, dynamic> m) => LocationModel(name: m['name'] ?? '', description: m['description'] ?? '');
}

@HiveType(typeId: 4)
class WorldMapNode {
  @HiveField(0) String label;
  @HiveField(1) double x;
  @HiveField(2) double y;
  @HiveField(3) int colorValue;

  WorldMapNode({required this.label, this.x = 0.5, this.y = 0.5, this.colorValue = 0xFF52E8FF});

  Map<String, dynamic> toMap() => {'label': label, 'x': x, 'y': y, 'colorValue': colorValue};
  factory WorldMapNode.fromMap(Map<String, dynamic> m) => WorldMapNode(
    label: m['label'] ?? '', x: (m['x'] ?? 0.5).toDouble(),
    y: (m['y'] ?? 0.5).toDouble(), colorValue: m['colorValue'] ?? 0xFF52E8FF,
  );
}

@HiveType(typeId: 5)
class ChapterModel {
  @HiveField(0) String title;
  @HiveField(1) String content;

  ChapterModel({this.title = 'Chapter 1', this.content = ''});

  Map<String, dynamic> toMap() => {'title': title, 'content': content};
  factory ChapterModel.fromMap(Map<String, dynamic> m) => ChapterModel(title: m['title'] ?? 'Chapter 1', content: m['content'] ?? '');
}

@HiveType(typeId: 6)
class GalleryItem {
  @HiveField(0) String id;
  @HiveField(1) String imagePath;
  @HiveField(2) List<String> tags;
  @HiveField(3) String pinnedToScene;
  @HiveField(4) String pinnedToChapter;
  @HiveField(5) DateTime addedAt;

  GalleryItem({
    required this.id,
    required this.imagePath,
    List<String>? tags,
    this.pinnedToScene = '',
    this.pinnedToChapter = '',
    DateTime? addedAt,
  })  : tags = tags ?? [],
        addedAt = addedAt ?? DateTime.now();
}

@HiveType(typeId: 7)
class AudioTrack {
  @HiveField(0) String id;
  @HiveField(1) String title;
  @HiveField(2) String artist;
  @HiveField(3) String source; // 'local' or 'youtube'
  @HiveField(4) String path; // file path or youtube URL
  @HiveField(5) String coverPath;

  AudioTrack({
    required this.id,
    required this.title,
    this.artist = 'Unknown',
    required this.source,
    required this.path,
    this.coverPath = '',
  });
}

// Project Store with Hive persistence
class ProjectStore {
  static final ProjectStore _instance = ProjectStore._internal();
  factory ProjectStore() => _instance;
  ProjectStore._internal();

  static const String _boxName = 'projects';
  static const String _galleryBoxName = 'gallery';
  static const String _audioBoxName = 'audio';

  Box<ProjectModel>? _box;
  Box<GalleryItem>? _galleryBox;
  Box<AudioTrack>? _audioBox;

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(ProjectModelAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(SceneModelAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(CharacterModelAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(LocationModelAdapter());
    if (!Hive.isAdapterRegistered(4)) Hive.registerAdapter(WorldMapNodeAdapter());
    if (!Hive.isAdapterRegistered(5)) Hive.registerAdapter(ChapterModelAdapter());
    if (!Hive.isAdapterRegistered(6)) Hive.registerAdapter(GalleryItemAdapter());
    if (!Hive.isAdapterRegistered(7)) Hive.registerAdapter(AudioTrackAdapter());

    _box = await Hive.openBox<ProjectModel>(_boxName);
    _galleryBox = await Hive.openBox<GalleryItem>(_galleryBoxName);
    _audioBox = await Hive.openBox<AudioTrack>(_audioBoxName);
  }

  List<ProjectModel> get novels => _box?.values.where((p) => p.type == 'novel').toList() ?? [];
  List<ProjectModel> get shortStories => _box?.values.where((p) => p.type == 'short_story').toList() ?? [];
  List<ProjectModel> get articles => _box?.values.where((p) => p.type == 'article').toList() ?? [];
  List<GalleryItem> get galleryItems => _galleryBox?.values.toList() ?? [];
  List<AudioTrack> get audioTracks => _audioBox?.values.toList() ?? [];

  Future<void> saveProject(ProjectModel project) async {
    project.updatedAt = DateTime.now();
    await _box?.put(project.id, project);
  }

  Future<void> deleteProject(String id) async {
    await _box?.delete(id);
  }

  Future<void> addGalleryItem(GalleryItem item) async {
    await _galleryBox?.put(item.id, item);
  }

  Future<void> deleteGalleryItem(String id) async {
    await _galleryBox?.delete(id);
  }

  Future<void> addAudioTrack(AudioTrack track) async {
    await _audioBox?.put(track.id, track);
  }

  Future<void> deleteAudioTrack(String id) async {
    await _audioBox?.delete(id);
  }
}
