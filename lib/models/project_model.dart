class ProjectModel {
  final String id;
  final String title;
  final String type;
  final String genre;
  final String description;
  int wordCount;
  final int goalWordCount;
  List<SceneModel> scenes;
  List<CharacterModel> characters;
  List<LocationModel> locations;
  List<WorldMapNode> worldMapNodes;
  List<ChapterModel> chapters;

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
  })  : scenes = scenes ?? [],
        characters = characters ?? [],
        locations = locations ?? [],
        worldMapNodes = worldMapNodes ?? [],
        chapters = chapters ?? [];
}

class SceneModel {
  String title;
  String notes;
  String linkedChapter;

  SceneModel({this.title = '', this.notes = '', this.linkedChapter = ''});
}

class CharacterModel {
  String name;
  String role;
  String age;
  String mannerisms;
  String goal;
  String backstory;
  String gender;
  String languageStyle;

  CharacterModel({
    this.name = '',
    this.role = 'Minor',
    this.age = '',
    this.mannerisms = '',
    this.goal = '',
    this.backstory = '',
    this.gender = '',
    this.languageStyle = '',
  });
}

class LocationModel {
  String name;
  String description;

  LocationModel({this.name = '', this.description = ''});
}

class WorldMapNode {
  String label;
  double x;
  double y;
  int colorValue;

  WorldMapNode({required this.label, this.x = 0.5, this.y = 0.5, this.colorValue = 0xFF52E8FF});
}

class ChapterModel {
  String title;
  String content;

  ChapterModel({this.title = 'Chapter 1', this.content = ''});
}

// Global project store — in memory for now
class ProjectStore {
  static final ProjectStore _instance = ProjectStore._internal();
  factory ProjectStore() => _instance;
  ProjectStore._internal();

  final List<ProjectModel> novels = [];
  final List<ProjectModel> shortStories = [];
  final List<ProjectModel> articles = [];

  void addProject(ProjectModel project) {
    switch (project.type) {
      case 'novel':
        novels.add(project);
        break;
      case 'short_story':
        shortStories.add(project);
        break;
      case 'article':
        articles.add(project);
        break;
    }
  }
}
