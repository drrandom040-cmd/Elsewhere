// GENERATED CODE - DO NOT MODIFY BY HAND
// We write this manually since we can't run build_runner in CI without extra setup

part of 'project_model.dart';

class ProjectModelAdapter extends TypeAdapter<ProjectModel> {
  @override
  final int typeId = 0;

  @override
  ProjectModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProjectModel(
      id: fields[0] as String,
      title: fields[1] as String,
      type: fields[2] as String,
      genre: fields[3] as String,
      description: fields[4] as String,
      wordCount: fields[5] as int,
      goalWordCount: fields[6] as int,
      scenes: (fields[7] as List).cast<SceneModel>(),
      characters: (fields[8] as List).cast<CharacterModel>(),
      locations: (fields[9] as List).cast<LocationModel>(),
      worldMapNodes: (fields[10] as List).cast<WorldMapNode>(),
      chapters: (fields[11] as List).cast<ChapterModel>(),
      createdAt: fields[12] as DateTime,
      updatedAt: fields[13] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ProjectModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.title)
      ..writeByte(2)..write(obj.type)
      ..writeByte(3)..write(obj.genre)
      ..writeByte(4)..write(obj.description)
      ..writeByte(5)..write(obj.wordCount)
      ..writeByte(6)..write(obj.goalWordCount)
      ..writeByte(7)..write(obj.scenes)
      ..writeByte(8)..write(obj.characters)
      ..writeByte(9)..write(obj.locations)
      ..writeByte(10)..write(obj.worldMapNodes)
      ..writeByte(11)..write(obj.chapters)
      ..writeByte(12)..write(obj.createdAt)
      ..writeByte(13)..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class SceneModelAdapter extends TypeAdapter<SceneModel> {
  @override
  final int typeId = 1;

  @override
  SceneModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SceneModel(
      title: fields[0] as String,
      notes: fields[1] as String,
      linkedChapter: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, SceneModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)..write(obj.title)
      ..writeByte(1)..write(obj.notes)
      ..writeByte(2)..write(obj.linkedChapter);
  }

  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) => identical(this, other) || other is SceneModelAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class CharacterModelAdapter extends TypeAdapter<CharacterModel> {
  @override
  final int typeId = 2;

  @override
  CharacterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterModel(
      name: fields[0] as String,
      role: fields[1] as String,
      age: fields[2] as String,
      mannerisms: fields[3] as String,
      goal: fields[4] as String,
      backstory: fields[5] as String,
      gender: fields[6] as String,
      languageStyle: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CharacterModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)..write(obj.name)
      ..writeByte(1)..write(obj.role)
      ..writeByte(2)..write(obj.age)
      ..writeByte(3)..write(obj.mannerisms)
      ..writeByte(4)..write(obj.goal)
      ..writeByte(5)..write(obj.backstory)
      ..writeByte(6)..write(obj.gender)
      ..writeByte(7)..write(obj.languageStyle);
  }

  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) => identical(this, other) || other is CharacterModelAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class LocationModelAdapter extends TypeAdapter<LocationModel> {
  @override
  final int typeId = 3;

  @override
  LocationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocationModel(name: fields[0] as String, description: fields[1] as String);
  }

  @override
  void write(BinaryWriter writer, LocationModel obj) {
    writer..writeByte(2)..writeByte(0)..write(obj.name)..writeByte(1)..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) => identical(this, other) || other is LocationModelAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class WorldMapNodeAdapter extends TypeAdapter<WorldMapNode> {
  @override
  final int typeId = 4;

  @override
  WorldMapNode read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WorldMapNode(
      label: fields[0] as String,
      x: fields[1] as double,
      y: fields[2] as double,
      colorValue: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, WorldMapNode obj) {
    writer..writeByte(4)..writeByte(0)..write(obj.label)..writeByte(1)..write(obj.x)..writeByte(2)..write(obj.y)..writeByte(3)..write(obj.colorValue);
  }

  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) => identical(this, other) || other is WorldMapNodeAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class ChapterModelAdapter extends TypeAdapter<ChapterModel> {
  @override
  final int typeId = 5;

  @override
  ChapterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChapterModel(title: fields[0] as String, content: fields[1] as String);
  }

  @override
  void write(BinaryWriter writer, ChapterModel obj) {
    writer..writeByte(2)..writeByte(0)..write(obj.title)..writeByte(1)..write(obj.content);
  }

  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) => identical(this, other) || other is ChapterModelAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class GalleryItemAdapter extends TypeAdapter<GalleryItem> {
  @override
  final int typeId = 6;

  @override
  GalleryItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GalleryItem(
      id: fields[0] as String,
      imagePath: fields[1] as String,
      tags: (fields[2] as List).cast<String>(),
      pinnedToScene: fields[3] as String,
      pinnedToChapter: fields[4] as String,
      addedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, GalleryItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.imagePath)
      ..writeByte(2)..write(obj.tags)
      ..writeByte(3)..write(obj.pinnedToScene)
      ..writeByte(4)..write(obj.pinnedToChapter)
      ..writeByte(5)..write(obj.addedAt);
  }

  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) => identical(this, other) || other is GalleryItemAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class AudioTrackAdapter extends TypeAdapter<AudioTrack> {
  @override
  final int typeId = 7;

  @override
  AudioTrack read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AudioTrack(
      id: fields[0] as String,
      title: fields[1] as String,
      artist: fields[2] as String,
      source: fields[3] as String,
      path: fields[4] as String,
      coverPath: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AudioTrack obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.title)
      ..writeByte(2)..write(obj.artist)
      ..writeByte(3)..write(obj.source)
      ..writeByte(4)..write(obj.path)
      ..writeByte(5)..write(obj.coverPath);
  }

  @override
  int get hashCode => typeId.hashCode;
  @override
  bool operator ==(Object other) => identical(this, other) || other is AudioTrackAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
