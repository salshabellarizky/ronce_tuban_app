import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:ronce_tuban_app/models/tradition_model.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;
  static Future<Database>? _databaseOpening;

  DBHelper._init();

  static void _initializeDatabaseFactory() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _databaseOpening ??= _initDB('ronce_tuban.db').then(
      (database) {
        _database = database;
        _databaseOpening = null;
        return database;
      },
      onError: (Object error, StackTrace stackTrace) {
        _databaseOpening = null;
        Error.throwWithStackTrace(error, stackTrace);
      },
    );
    return _databaseOpening!;
  }

  Future<Database> _initDB(String filePath) async {
    _initializeDatabaseFactory();
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    final database = await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute('ALTER TABLE favorit ADD COLUMN sumberLabel TEXT');
          await db.execute('ALTER TABLE favorit ADD COLUMN sumberUrl TEXT');
        }
        if (oldVersion < 3) {
          await _createLocalAuthTables(db);
        }
      },
    );
    return database;
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE favorit (
        id INTEGER PRIMARY KEY,
        nama TEXT NOT NULL,
        daerah TEXT NOT NULL,
        lokasiLengkap TEXT NOT NULL,
        kategori TEXT NOT NULL,
        deskripsiSingkat TEXT NOT NULL,
        waktuPelaksanaan TEXT NOT NULL,
        deskripsiWaktu TEXT NOT NULL,
        sejarah TEXT NOT NULL,
        makna TEXT NOT NULL,
        gambaranProses TEXT NOT NULL,
        gambarUrl TEXT NOT NULL,
        sumberLabel TEXT,
        sumberUrl TEXT
      )
    ''');
    await _createLocalAuthTables(db);
  }

  Future<void> _createLocalAuthTables(Database db) async {
    await db.execute('''
      CREATE TABLE local_users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL COLLATE NOCASE UNIQUE,
        passwordSalt TEXT NOT NULL,
        passwordHash TEXT NOT NULL,
        createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
    ''');
    await db.execute('''
      CREATE TABLE local_session (
        id INTEGER PRIMARY KEY CHECK (id = 1),
        userId INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertFavorit(TraditionModel tradisi) async {
    final db = await instance.database;
    return await db.insert(
      'favorit',
      {
        'id': tradisi.id,
        'nama': tradisi.nama,
        'daerah': tradisi.daerah,
        'lokasiLengkap': tradisi.lokasiLengkap,
        'kategori': tradisi.kategori,
        'deskripsiSingkat': tradisi.deskripsiSingkat,
        'waktuPelaksanaan': tradisi.waktuPelaksanaan,
        'deskripsiWaktu': tradisi.deskripsiWaktu,
        'sejarah': tradisi.sejarah,
        'makna': tradisi.makna,
        'gambaranProses': tradisi.gambaranProses.join('||'),
        'gambarUrl': tradisi.gambarUrl,
        'sumberLabel': tradisi.sumberLabel,
        'sumberUrl': tradisi.sumberUrl,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> deleteFavorit(int id) async {
    final db = await instance.database;
    return await db.delete(
      'favorit',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<TraditionModel>> getFavorit() async {
    final db = await instance.database;
    final result = await db.query('favorit');

    return result.map((map) {
      return TraditionModel(
        id: map['id'] as int,
        nama: map['nama'] as String,
        daerah: map['daerah'] as String,
        lokasiLengkap: map['lokasiLengkap'] as String,
        kategori: map['kategori'] as String,
        deskripsiSingkat: map['deskripsiSingkat'] as String,
        waktuPelaksanaan: map['waktuPelaksanaan'] as String,
        deskripsiWaktu: map['deskripsiWaktu'] as String,
        sejarah: map['sejarah'] as String,
        makna: map['makna'] as String,
        gambaranProses: (map['gambaranProses'] as String).split('||'),
        gambarUrl: map['gambarUrl'] as String,
        sumberLabel: map['sumberLabel'] as String?,
        sumberUrl: map['sumberUrl'] as String?,
        isFavorite: true,
      );
    }).toList();
  }
}
