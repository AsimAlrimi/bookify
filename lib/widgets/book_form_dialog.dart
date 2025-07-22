import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../services/models/book.dart';

class BookFormDialog extends StatefulWidget {
  final Book? initial;
  const BookFormDialog({Key? key, this.initial}) : super(key: key);

  @override
  State<BookFormDialog> createState() => _BookFormDialogState();
}

class _BookFormDialogState extends State<BookFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _title;
  late TextEditingController _author;
  late TextEditingController _rating;
  late TextEditingController _description;
  bool _available = true;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.initial?.title ?? '');
    _author = TextEditingController(text: widget.initial?.author ?? '');
    _rating = TextEditingController(text: widget.initial?.rating.toString() ?? '0');
    _description = TextEditingController(text: widget.initial?.description ?? '');
    _available = widget.initial?.available ?? true;

    if (widget.initial?.imagePath != null) {
      _selectedImage = File(widget.initial!.imagePath!);
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _author.dispose();
    _rating.dispose();
    _description.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<String?> _saveImage(File image) async {
    final appDir = await getApplicationDocumentsDirectory();
    final fileName = DateTime.now().millisecondsSinceEpoch.toString() + '.png';
    final savedImage = await image.copy('${appDir.path}/$fileName');
    return savedImage.path;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initial == null ? 'Add Book' : 'Edit Book'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _title,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _author,
                decoration: const InputDecoration(labelText: 'Author'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _rating,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Rating (0-5)'),
                validator: (v) {
                  final d = double.tryParse(v ?? '');
                  if (d == null || d < 0 || d > 5) return '0 - 5';
                  return null;
                },
              ),
              TextFormField(
                controller: _description,
                decoration: const InputDecoration(labelText: 'Description'),
                minLines: 2,
                maxLines: 4,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              _selectedImage != null
                  ? Image.file(_selectedImage!, height: 100)
                  : const Text('No image selected'),
              TextButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Select Image'),
                onPressed: _pickImage,
              ),
              SwitchListTile(
                value: _available,
                onChanged: (val) => setState(() => _available = val),
                title: const Text('Available'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              String? imagePath;
              if (_selectedImage != null) {
                imagePath = await _saveImage(_selectedImage!);
              }
              final book = Book(
                id: widget.initial?.id,
                title: _title.text.trim(),
                author: _author.text.trim(),
                rating: double.parse(_rating.text.trim()),
                description: _description.text.trim(),
                available: _available,
                imagePath: imagePath ?? widget.initial?.imagePath,
              );
              Navigator.pop(context, book);
            }
          },
          child: Text(widget.initial == null ? 'Add' : 'Save'),
        )
      ],
    );
  }
}
