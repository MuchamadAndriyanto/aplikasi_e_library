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
  List<Book> _filteredBooks = [];
  String _searchQuery = ''; // Use this field to hold the search query

  @override
  void initState() {
    super.initState();
    _loadBooks(); // Load all books on initialization
  }

  // Load all books from the database
  void _loadBooks() async {
    _books = await DatabaseHelper().getAllBooks();
    setState(() {
      _filteredBooks = _books; // Initialize the filtered list with all books
    });
  }

  // Filter books based on the search query
  void _filterBooks(String query) {
    setState(() {
      _searchQuery = query; // Update the search query
      _filteredBooks = _books.where((book) {
        return book.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
            book.author.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList(); // Filter books based on the updated search query
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
        backgroundColor: backgroundColor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: _filterBooks, // Call filterBooks when the text changes
              decoration: const InputDecoration(
                hintText: 'Search by title or author',
                border: OutlineInputBorder(),
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
                    // Navigate to the book details screen if needed
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
