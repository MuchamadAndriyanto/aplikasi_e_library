import 'package:flutter/material.dart';
import 'package:perpustakaan/themes.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../models/models_buku.dart';
import 'dart:io';
import '../database/database_helper.dart';

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
    isFavorite = widget.book.isFavorite;
  }

  void _toggleFavorite() async {
    await DatabaseHelper().toggleFavorite(widget.book.id!);
    setState(() {
      isFavorite = !isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          'Detail Buku',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? iconKedua : iconPertama,
            ),
            onPressed: _toggleFavorite, // Fungsi toggleFavorite
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Menampilkan gambar buku
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.asset(
                    'assets/icon_pdf.png',
                    height: 250,
                    width: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Menampilkan nama penulis dan judul buku
              Text(
                widget.book.title,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 7),
              Text(
                widget.book.author,
                style: TextStyle(
                  fontSize: 18,
                  color: iconColor,
                ),
              ),
              const SizedBox(height: 40),
              // Menampilkan deskripsi
              Text(
                'Deskripsi',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                widget.book.description,
                style: TextStyle(
                  fontSize: 16,
                  color: iconPertama,
                ),
              ),
              const SizedBox(height: 50),
              // Tombol Read Book
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PDFViewerPage(pdfPath: widget.book.pdfPath),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: 20.0,
                    ),
                  ),
                  child: Text(
                    'Read Book',
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
