import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../database/database_helper.dart';
import '../models/models_buku.dart';
import 'detail_buku.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  late Future<List<Book>> _bookList;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  void _loadBooks() {
    setState(() {
      _bookList = DatabaseHelper().getAllBooks();
    });
  }

  void _deleteBook(int id) async {
    await DatabaseHelper().deleteBook(id);
    _loadBooks();
  }

  void _editBook(Book book) async {
    TextEditingController titleController =
    TextEditingController(text: book.title);
    TextEditingController authorController =
    TextEditingController(text: book.author);
    TextEditingController descriptionController =
    TextEditingController(text: book.description);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Book'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Author'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Book updatedBook = Book(
                  id: book.id,
                  title: titleController.text,
                  author: authorController.text,
                  description: descriptionController.text,
                  pdfPath: book.pdfPath,
                  isFavorite: book.isFavorite,
                );
                await DatabaseHelper().updateBook(updatedBook);
                Navigator.of(context).pop();
                _loadBooks();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Explore Books'),
      ),
      body: FutureBuilder<List<Book>>(
        future: _bookList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(child: Text('No books available.'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final book = snapshot.data![index];

              return ListTile(
                title: Text(book.title),
                subtitle: Text(book.author),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _editBook(book);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteBook(book.id!);
                      },
                    ),
                  ],
                ),
                onTap: () {
                  // Navigasi ke layar detail ketika buku diklik
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailBuku(book: book),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          FilePickerResult? result = await FilePicker.platform.pickFiles(
            type: FileType.custom,
            allowedExtensions: ['pdf'],
          );

          if (result != null) {
            String? path = result.files.single.path;

            if (path != null) {
              TextEditingController titleController = TextEditingController();
              TextEditingController authorController = TextEditingController();
              TextEditingController descriptionController =
              TextEditingController();

              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Upload Book'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(labelText: 'Title'),
                        ),
                        TextField(
                          controller: authorController,
                          decoration:
                          const InputDecoration(labelText: 'Author'),
                        ),
                        TextField(
                          controller: descriptionController,
                          decoration:
                          const InputDecoration(labelText: 'Description'),
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          Book newBook = Book(
                            title: titleController.text,
                            author: authorController.text,
                            description: descriptionController.text,
                            pdfPath: path,
                            isFavorite: false,
                          );
                          await DatabaseHelper().insertBook(newBook);
                          Navigator.of(context).pop();
                          _loadBooks();
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  );
                },
              );
            }
          }
        },
        tooltip: 'Upload Book',
        child: const Icon(Icons.add),
      ),
    );
  }
}
