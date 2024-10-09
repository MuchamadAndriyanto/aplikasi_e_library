import 'package:flutter/material.dart';
import '../models/models_buku.dart';
import '../database/database_helper.dart';
import 'package:perpustakaan/themes.dart';
import 'detail_buku.dart';

class Favorite extends StatelessWidget {
  const Favorite({super.key});

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
        backgroundColor: backgroundColor,
      ),
      body: FutureBuilder<List<Book>>(
        future: DatabaseHelper()
            .getAllFavoriteBooks(), // Mengambil daftar buku favorit dari database
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No favorite books found.'));
          } else {
            final favoriteBooks = snapshot.data!;
            return ListView.builder(
              itemCount: favoriteBooks.length,
              itemBuilder: (context, index) {
                final book = favoriteBooks[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  onTap: () {
                    // Navigasi ke detail buku
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailBuku(
                            book: book), // Menggunakan BookDetailScreen
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
