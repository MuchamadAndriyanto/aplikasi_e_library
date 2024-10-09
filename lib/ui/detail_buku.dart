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

  // Fungsi untuk toggle favorit
  void _toggleFavorite() async {
    await DatabaseHelper().toggleFavorite(widget.book.id!); // Memanggil fungsi toggleFavorite di DatabaseHelper
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
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
                  child: Image.asset(
                    'assets/pdf_icon.jpg', // Gambar buku (pastikan path benar)
                    height: 250,
                    width: 200, // Menambahkan lebar gambar untuk menjaga proporsi
                    fit: BoxFit.cover, // Menyesuaikan gambar agar memenuhi kotak
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Menampilkan nama penulis dan judul buku
              Text(
                widget.book.title,
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color : textColor,),
              ),
              Text(
                widget.book.author,
                style: TextStyle(
                    fontSize: 17,
                    color: iconColor),
              ),
              const SizedBox(height: 40),
              // Heading "Deskripsi"
              const Text(
                'Deskripsi',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 2),
              // Menampilkan deskripsi buku
              Text(
                widget.book.description,
                style: const TextStyle(fontSize: 17),
              ),
              const SizedBox(height: 35),
              // Tombol Read Book di bagian tengah
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
                  child: const Text('Read Book'),
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
