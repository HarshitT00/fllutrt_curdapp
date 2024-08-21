import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import '../models/note.dart';
import '../models/notes_providers.dart'; // Make sure this path is correct
import '../utils/note_dialouge.dart';

class NotesListPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsyncValue = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes App'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _showAddNoteDialog(context, ref),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Add Note'),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: notesAsyncValue.when(
          data: (notes) => ListView.builder(
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
                        onPressed: () => _showEditNoteDialog(context, ref, note),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.blue),
                        onPressed: () => _deleteNote(context, ref, note.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          loading: () => Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
        ),
      ),
    );
  }

  void _showAddNoteDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NoteDialog(
          onSave: (note) async {
            await ref.read(noteManagerProvider).saveNote(note);
            ref.refresh(notesProvider); // Refresh the notesProvider to update the list
          },
        );
      },
    );
  }

  void _showEditNoteDialog(BuildContext context, WidgetRef ref, Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NoteDialog(
          note: note,
          onSave: (updatedNote) async {
            await ref.read(noteManagerProvider).updateNote(updatedNote);
            ref.refresh(notesProvider); // Refresh the notesProvider to update the list
          },
        );
      },
    );
  }

  void _deleteNote(
    BuildContext context,
    WidgetRef ref,
    String noteId,
  ) async {
    try {
      await ref.read(noteManagerProvider).deleteNote(noteId);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Note deleted')),
      );
      ref.refresh(notesProvider); // Refresh the notesProvider to update the list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Something went wrong')),
      );
    }
  }
}
