import 'package:flutter/material.dart';
import 'pages/notes_home_page.dart';
import 'models/note.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample list of notes
    List<Note> sampleNotes = [
      Note(
        title: 'Meeting Notes',
        description: 'Discuss project goals and timelines.',
      ),
      Note(
        title: 'Shopping List',
        description: 'Milk, Eggs, Bread, Butter.',
      ),
      Note(
        title: 'Study Plan',
        description: 'Complete Flutter course and assignments.',
      ),
    ];

    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NotesListPage(notes: sampleNotes),
    );
  }
}
