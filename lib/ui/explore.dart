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
  // Menampung daftar buku yang akan diambil dari database
  late Future<List<Book>> _bookList;

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  // Fungsi untuk memuat semua buku dari database
  void _loadBooks() {
    setState(() {
      _bookList = DatabaseHelper().getAllBooks();
    });
  }

  // Fungsi untuk menghapus buku
  void _deleteBook(int id) async {
    await DatabaseHelper().deleteBook(id);
    _loadBooks();
  }

  // Fungsi untuk mengedit informasi buku
  void _editBook(Book book) async {
    TextEditingController titleController = TextEditingController(text: book.title);
    TextEditingController authorController = TextEditingController(text: book.author);
    TextEditingController descriptionController = TextEditingController(text: book.description);

    // Dialog untuk mengedit buku
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
                await DatabaseHelper().updateBook(updatedBook); // Memperbarui buku di database
                Navigator.of(context).pop();
                _loadBooks();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0), // Menambahkan radius
                ),
                primary: backgroundColor,
                onPrimary: textColor,
              ),
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
        centerTitle: true,
        backgroundColor: backgroundColor,
      ),
      body: FutureBuilder<List<Book>>(
        future: _bookList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No books available.',
                style: TextStyle(color: iconPertama),
              ),
            );
          }

          // Tampilkan dalam bentuk grid
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
                      // Gambar placeholder untuk buku dalam grid
                      Container(
                        height: 125,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          ),
                          image: const DecorationImage(
                            image: AssetImage('assets/icon_pdf.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              book.title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: textColor,
                              ),
                              maxLines: 1,
                            ),
                            const SizedBox(height: 7),
                            Text(
                              book.author,
                              style: TextStyle(
                                fontSize: 13,
                                color: iconPertama,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            const SizedBox(height: 5),
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
            allowedExtensions: ['pdf'], // Hanya file PDF yang diperbolehkan
          );

          if (result != null && result.files.isNotEmpty) {
            String? path = result.files.single.path;

            // Pastikan path tidak null dan memiliki ekstensi .pdf
            if (path != null && path.toLowerCase().endsWith('.pdf')) {
              TextEditingController titleController = TextEditingController();
              TextEditingController authorController = TextEditingController();
              TextEditingController descriptionController = TextEditingController();
              bool isValid = true; // Flag untuk mengecek validitas input

              // Dialog untuk menambahkan buku
              await showDialog(
                context: context,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (context, setState) {
                      return AlertDialog(
                        title: Text(
                          'Upload Book',
                          style: TextStyle(
                            color: textColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: titleController,
                              decoration: InputDecoration(
                                labelText: 'Title',
                                errorText: titleController.text.isEmpty && !isValid
                                    ? 'Title is required'
                                    : null,
                              ),
                            ),
                            TextField(
                              controller: authorController,
                              decoration: InputDecoration(
                                labelText: 'Author',
                                errorText: authorController.text.isEmpty && !isValid
                                    ? 'Author is required'
                                    : null,
                              ),
                            ),
                            TextField(
                              controller: descriptionController,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                errorText: descriptionController.text.isEmpty && !isValid
                                    ? 'Description is required'
                                    : null,
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                            style: TextButton.styleFrom(
                              primary: textColor,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              // Validasi input
                              setState(() {
                                isValid = authorController.text.isNotEmpty &&
                                    titleController.text.isNotEmpty &&
                                    descriptionController.text.isNotEmpty;
                              });

                              if (isValid) {
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
                              }
                            },
                            child: const Text('Save'),
                            style: ElevatedButton.styleFrom(
                              primary: backgroundColor,
                              onPrimary: textColor,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              );
            } else {
              // Menampilkan pesan error jika file bukan PDF
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Please select a valid PDF file.'),
                  backgroundColor: textColor,
                ),
              );
            }
          }
        },
        backgroundColor: textColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
