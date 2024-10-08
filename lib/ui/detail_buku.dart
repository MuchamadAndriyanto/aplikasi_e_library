import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart'; // Import library untuk PDF viewer
import '../models/models_buku.dart';
import 'dart:io'; // Untuk file handling
import '../database/database_helper.dart'; // Pastikan untuk mengimpor DatabaseHelper

class DetailBuku extends StatefulWidget {
  final Book book;

  const DetailBuku({super.key, required this.book});

  @override
  _DetailBukuState createState() => _DetailBukuState();
}

class _DetailBukuState extends State<DetailBuku> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.book.isFavorite; // Mengambil status favorit dari buku
  }

  // Fungsi untuk toggle favorit
  void _toggleFavorite() async {
    await DatabaseHelper().toggleFavorite(
        widget.book.id!); // Memanggil fungsi toggleFavorite di DatabaseHelper
    setState(() {
      isFavorite = !isFavorite; // Membalikkan status favorit
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.book.title),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey,
            ),
            onPressed: _toggleFavorite, // Memanggil fungsi toggleFavorite
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.book.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Author: ${widget.book.author}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              widget.book.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        PDFViewerPage(pdfPath: widget.book.pdfPath),
                  ),
                );
              },
              child: const Text('Read Book'),
            ),
          ],
        ),
      ),
    );
  }
}

class PDFViewerPage extends StatelessWidget {
  final String pdfPath;

  const PDFViewerPage({super.key, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
      ),
      body: SfPdfViewer.file(File(pdfPath)), // Menampilkan file PDF
    );
  }
}
