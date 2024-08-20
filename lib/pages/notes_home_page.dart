import 'dart:io';
import 'package:flutter/material.dart';
import '../models/note.dart';
import '../utils/note_dialouge.dart';

class NotesListPage extends StatefulWidget {
  final List<Note> notes;

  const NotesListPage({Key? key, required this.notes}) : super(key: key);

  @override
  State<NotesListPage> createState() => NotesListPageState();
}

class NotesListPageState extends State<NotesListPage> {
  void _addNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NoteDialog(
          onSave: (note) {
            setState(() {
              widget.notes.add(note);
            });
          },
        );
      },
    );
  }

  void _editNote(int index) {
    final note = widget.notes[index];
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NoteDialog(
          note: note,
          onSave: (updatedNote) {
            setState(() {
              widget.notes[index] = updatedNote;
            });
          },
        );
      },
    );
  }

  void _deleteNote(int index) {
    setState(() {
      widget.notes.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Note deleted')),
    );
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
                itemCount: widget.notes.length,
                itemBuilder: (context, index) {
                  final note = widget.notes[index];
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
                      subtitle: Text(note.description),
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