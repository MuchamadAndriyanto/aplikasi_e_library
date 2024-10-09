import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../database/database_helper.dart';
import 'package:perpustakaan/themes.dart';
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
    TextEditingController authorController = TextEditingController(text: book.author);
    TextEditingController titleController = TextEditingController(text: book.title);
    TextEditingController descriptionController = TextEditingController(text: book.description);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Book'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: authorController,
                decoration: const InputDecoration(labelText: 'Author'),
              ),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
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
                  author: authorController.text,
                  title: titleController.text,
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
        title: Text(
            'Explore Books',
            style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: backgroundColor,
      ),
      body: FutureBuilder<List<Book>>(
        future: _bookList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No books available.'));
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8.0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.75,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final book = snapshot.data![index];

              return GestureDetector(
                onTap: () {
                  // Navigasi ke layar detail ketika buku diklik
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailBuku(book: book),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar PDF dengan ukuran yang lebih besar
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          image: const DecorationImage(
                            image: AssetImage('assets/pdf_icon.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Nama author dengan teks tebal
                            Text(
                              book.title,
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              // Membatasi baris teks nama author
                            ),
                            // Judul buku dengan teks biasa dan pembatasan panjang teks
                            Text(
                              book.author,
                              style: TextStyle(
                                fontSize: 17,
                                color: iconPertama,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,  // Membatasi maksimal 2 baris
                            ),
                            const SizedBox(height: 3),
                            // Ikon edit dan hapus
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
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
              TextEditingController authorController = TextEditingController();
              TextEditingController titleController = TextEditingController();
              TextEditingController descriptionController = TextEditingController();

              await showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Upload Book'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: authorController,
                          decoration: const InputDecoration(labelText: 'Author'),
                        ),
                        TextField(
                          controller: titleController,
                          decoration: const InputDecoration(labelText: 'Title'),
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
                          Book newBook = Book(
                            author: authorController.text,
                            title: titleController.text,
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
