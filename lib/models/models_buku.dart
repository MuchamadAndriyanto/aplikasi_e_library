class Book {
  int? id;
  String title;
  String author;
  String description;
  String pdfPath;
  bool isFavorite; // Ubah tipe menjadi bool

  Book({
    this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.pdfPath,
    this.isFavorite = false, // Default nilai bool
  });

  // Konversi dari Map (database) ke Book
  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      description: map['description'],
      pdfPath: map['pdfPath'],
      isFavorite: map['isFavorite'] == 1, // Konversi int ke bool
    );
  }

  // Konversi dari Book ke Map (untuk database)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'description': description,
      'pdfPath': pdfPath,
      'isFavorite': isFavorite ? 1 : 0, // Konversi bool ke int
    };
  }
}
