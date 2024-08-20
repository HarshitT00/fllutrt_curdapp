import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/note.dart';

class NoteDialog extends StatefulWidget {
  final Note? note;
  final Function(Note) onSave;

  const NoteDialog({Key? key, this.note, required this.onSave}) : super(key: key);

  @override
  State<NoteDialog> createState() => NoteDialogState();
}


class NoteDialogState extends State<NoteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  XFile? _image;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _descriptionController.text = widget.note!.description;
      _image = widget.note!.imagePath != null ? XFile(widget.note!.imagePath!) : null;
    }
  }

  Future<void> _getImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.note == null ? 'Add New Note' : 'Edit Note'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await _getImage();
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    foregroundColor: Colors.black,
                  ),
                  child: const Text('Add Image'),
                ),
                const SizedBox(width: 16),
                _image != null
                    ? Image.file(File(_image!.path), width: 50, height: 50)
                    : const Text('No image selected'),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          style:  TextButton.styleFrom(
            foregroundColor: Colors.blue,
          ),
          child: const Text('Save'),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              widget.onSave(
                Note(
                  title: _titleController.text,
                  description: _descriptionController.text,
                  imagePath: _image?.path,
                ),
              );
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(widget.note == null ? 'Note added' : 'Note updated')),
              );
            }
          },
        ),
      ],
    );
  }
}
