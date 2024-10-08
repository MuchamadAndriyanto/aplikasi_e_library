import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/models_buku.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  // Singleton pattern
  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  // Mengambil instance database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  // Menginisialisasi database
  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'books.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE books(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            author TEXT,
            description TEXT,
            pdfPath TEXT,
            isFavorite INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  // Menyisipkan buku baru
  Future<int> insertBook(Book book) async {
    Database db = await database;
    return await db.insert('books', book.toMap());
  }

  // Mengambil semua buku
  Future<List<Book>> getAllBooks() async {
    Database db = await database;
    var res = await db.query('books');
    return res.isNotEmpty ? res.map((b) => Book.fromMap(b)).toList() : [];
  }

  // Mengambil semua buku favorit
  Future<List<Book>> getAllFavoriteBooks() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'books',
      where: 'isFavorite = ?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) {
      return Book.fromMap(maps[i]);
    });
  }

  // Fungsi untuk menandai atau menghapus favorit
  Future<void> toggleFavorite(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> book =
    await db.query('books', where: 'id = ?', whereArgs: [id]);

    if (book.isNotEmpty) {
      bool isFavorite = book.first['isFavorite'] == 1;
      await db.update(
        'books',
        {'isFavorite': isFavorite ? 0 : 1}, // Toggle favorit
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  // Memperbarui buku yang ada
  Future<void> updateBook(Book book) async {
    final db = await database;
    await db.update(
      'books',
      book.toMap(),
      where: 'id = ?',
      whereArgs: [book.id], // Asumsikan Anda memiliki properti id untuk buku
    );
  }

  // Menghapus buku
  Future<int> deleteBook(int id) async {
    Database db = await database;
    return await db.delete('books', where: 'id = ?', whereArgs: [id]);
  }
}
