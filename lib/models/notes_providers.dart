// note_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'notes_manager.dart';
import 'note.dart';

// NoteManager provider
final noteManagerProvider = Provider<NoteManager>((ref) {
  return NoteManager();
});

// Providers for notes
final notesProvider = FutureProvider<List<Note>>((ref) async {
  final noteManager = ref.read(noteManagerProvider);
  return await noteManager.getAllNotes();
});

final noteProvider = FutureProvider.family<Note?, String>((ref, id) async {
  final noteManager = ref.read(noteManagerProvider);
  return await noteManager.getNote(id);
});
