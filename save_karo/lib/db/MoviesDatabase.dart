import 'package:path/path.dart';
import 'package:save_karo/model/Movies.dart';
import 'package:sqflite/sqflite.dart';

class MoviesDatabase {
  static final MoviesDatabase instance = MoviesDatabase._init();

  static Database? _database;

  MoviesDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('movies.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final boolType = 'BOOLEAN NOT NULL';
    final integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE $tableMovies ( 
  ${MovieFields.id} $idType, 
  ${MovieFields.name} $textType,
  ${MovieFields.director} $textType,
  ${MovieFields.image} $textType,
  )
''');
  }

  Future<Movies> create(Movies movies) async {
    final db = await instance.database;
    final id = await db.insert(tableMovies, movies.toJson());
    return movies.copy(id: id);
  }

  Future<Movies> readMovie(int id) async {
    final db = await instance.database;

    final maps = await db.query(
      tableMovies,
      columns: MovieFields.values,
      where: '${MovieFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Movies.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<Movies>> readAllMovies() async {
    final db = await instance.database;

    final orderBy = '${MovieFields.id} ASC';
    // final result =
    //     await db.rawQuery('SELECT * FROM $tableMovies ORDER BY $orderBy');

    final result = await db.query(tableMovies, orderBy: orderBy);

    return result.map((json) => Movies.fromJson(json)).toList();
  }

  Future<int> update(Movies movies) async {
    final db = await instance.database;

    return db.update(
      tableMovies,
      movies.toJson(),
      where: '${MovieFields.id} = ?',
      whereArgs: [movies.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableMovies,
      where: '${MovieFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
