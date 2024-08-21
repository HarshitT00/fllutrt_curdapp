// note_manager.dart
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'note.dart';

class NoteManager {
  Future<String> get _directoryPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getFile(String fileName) async {
    final path = await _directoryPath;
    return File('$path/$fileName');
  }

  Future<void> saveNote(Note note) async {
    final file = await _getFile('${note.id}.json');
    await file.writeAsString(json.encode(note.toJson()));
  }

  Future<Note?> getNote(String id) async {
    try {
      final file = await _getFile('$id.json');
      final contents = await file.readAsString();
      return Note.fromJson(json.decode(contents));
    } catch (e) {
      return null;
    }
  }

  Future<List<Note>> getAllNotes() async {
    final path = await _directoryPath;
    final dir = Directory(path);
    List<Note> notes = [];

    await for (final file in dir.list()) {
      if (file.path.endsWith('.json')) {
        final contents = await File(file.path).readAsString();
        notes.add(Note.fromJson(json.decode(contents)));
      }
    }

    return notes;
  }

  Future<void> deleteNote(String id) async {
    final file = await _getFile('$id.json');
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<String> saveImage(XFile image) async {
    final path = await _directoryPath;
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final filePath = '$path/$fileName';
    await File(image.path).copy(filePath);
    return filePath;
  }

  Future<void> updateNote(Note note) async {
    final file = await _getFile('${note.id}.json');
    await file.writeAsString(json.encode(note.toJson()));
  }
}
