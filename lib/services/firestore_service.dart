import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/project_model.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  CollectionReference? get _projectsRef => _uid != null
      ? _db.collection('users').doc(_uid).collection('projects')
      : null;

  CollectionReference? get _galleryRef => _uid != null
      ? _db.collection('users').doc(_uid).collection('gallery')
      : null;

  CollectionReference? get _audioRef => _uid != null
      ? _db.collection('users').doc(_uid).collection('audio')
      : null;

  // ─── Projects ──────────────────────────────────────────────────────────────

  Future<void> syncProject(ProjectModel project) async {
    try {
      await _projectsRef?.doc(project.id).set(project.toFirestore());
    } catch (e) {
      // Silent fail — local storage is primary
    }
  }

  Future<void> deleteProject(String id) async {
    try {
      await _projectsRef?.doc(id).delete();
    } catch (e) {}
  }

  Future<List<ProjectModel>> fetchAllProjects() async {
    try {
      final snap = await _projectsRef?.get();
      if (snap == null) return [];
      return snap.docs
          .map((doc) => ProjectModel.fromFirestore(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // ─── Auto sync on save ─────────────────────────────────────────────────────

  Future<void> saveAndSync(ProjectModel project) async {
    final store = ProjectStore();
    await store.saveProject(project);
    await syncProject(project); // Fire and forget to Firestore
  }

  // ─── Restore from cloud ────────────────────────────────────────────────────

  Future<void> restoreFromCloud() async {
    final cloudProjects = await fetchAllProjects();
    final store = ProjectStore();
    for (final project in cloudProjects) {
      await store.saveProject(project);
    }
  }
}
