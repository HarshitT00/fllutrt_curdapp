class Note {
  final String title;
  final String description;
  final String? imagePath;

  Note({required this.title, required this.description, this.imagePath});

  Note copyWith({String? title, String? description, String? imagePath}) {
    return Note(
      title: title ?? this.title,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
    );
  }
}