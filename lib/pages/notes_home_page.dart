import 'package:flutter/material.dart';
import 'dart:io';
import '../models/notes_manager.dart';
import '../utils/note_dialouge.dart';

class NotesListPage extends StatefulWidget {

  @override
  State<NotesListPage> createState() => NotesListPageState();
}

class NotesListPageState extends State<NotesListPage> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    final loadedNotes = await NoteManager.getAllNotes();
    setState(() {
      notes = loadedNotes;
    });
  }

  void _addNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NoteDialog(
          onSave: (note) async {
            await NoteManager.saveNote(note);
          _loadNotes();
          },
        );
      },
    );
  }

  void _editNote(int index) {
    final note = notes[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NoteDialog(
          note: note,
          onSave: (updatedNote) async {
            updatedNote.id = note.id;
            await NoteManager.updateNote(updatedNote);
            _loadNotes();
          },
        );
      },
    );
  }

void _deleteNote(int index) async {
  final id = notes[index].id;
  try {
    await NoteManager.deleteNote(id);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note deleted')),
      );
      _loadNotes();
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _addNote(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Note'),
            )
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // List Section
            Expanded(
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: note.imagePath != null
                          ? Image.file(
                              File(note.imagePath!),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : null,
                      title: Text(note.title),
                      subtitle: Text(note.content),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _editNote(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.blue),
                            onPressed: () => _deleteNote(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}