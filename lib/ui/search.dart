import 'package:flutter/material.dart';
import '../models/models_buku.dart';
import '../database/database_helper.dart';
import 'package:perpustakaan/themes.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<Book> _books = [];
  List<Book> _filteredBooks = []; // Menyimpan buku yang sudah difilter berdasarkan pencarian
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadBooks();
  }

  // Fungsi untuk mengambil semua buku dari database
  void _loadBooks() async {
    _books = await DatabaseHelper().getAllBooks();
    setState(() {
      _filteredBooks = _books;
    });
  }

  // Fungsi untuk memfilter buku berdasarkan pencarian
  void _filterBooks(String query) {
    setState(() {
      _searchQuery = query;
      _filteredBooks = _books.where((book) {
        return book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            book.author.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Books',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterBooks, // Fungsi pemfilteran
              decoration: InputDecoration(
                hintText: 'Search by title or author',
                hintStyle: TextStyle(color: iconPertama),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: iconPertama,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide(
                    color: textColor,
                    width: 2.0,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredBooks.length,
              itemBuilder: (context, index) {
                final book = _filteredBooks[index];
                return ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  onTap: () {
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
