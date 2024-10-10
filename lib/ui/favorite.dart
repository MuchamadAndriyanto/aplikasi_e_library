import 'package:flutter/material.dart';
import '../models/models_buku.dart';
import '../database/database_helper.dart';
import 'package:perpustakaan/themes.dart';
import 'detail_buku.dart';

class Favorite extends StatefulWidget {
  const Favorite({super.key});

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  // Daftar buku favorit
  late Future<List<Book>> _favoriteBooks;

  @override
  void initState() {
    super.initState();
    _loadFavoriteBooks();
  }

  // Fungsi untuk memuat daftar buku favorit dari database
  void _loadFavoriteBooks() {
    setState(() {
      _favoriteBooks = DatabaseHelper().getAllFavoriteBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Books',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
      ),
      body: FutureBuilder<List<Book>>(
        future: _favoriteBooks, // Daftar buku favorit
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text(
                'No favorite books found.',
                style: TextStyle(
                  color: iconPertama,
                ),
              ),
            );
          } else {
            final favoriteBooks = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: favoriteBooks.length,
              itemBuilder: (context, index) {
                final book = favoriteBooks[index];

                return GestureDetector(
                  onTap: () async {
                    // Menggunakan async/await untuk menunggu hasil dari halaman detail
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailBuku(book: book),
                      ),
                    );
                    // Memuat ulang daftar favorit setelah kembali dari detail buku
                    _loadFavoriteBooks();
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
