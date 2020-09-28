import "package:sqflite/sqflite.dart" as sql;
import "package:path/path.dart" as path;

class DbUtil {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'places.db'), version: 1,
        onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE places (id TEXT PRIMART KEY, title TEXT, image TEXT, latitude REAL, longitude REAL, address TEXT)");
    });
  }

  static Future<void> insert(String table, Map<String, Object> datas) async {
    final db = await DbUtil.database();
    await db.insert(
      table,
      datas,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DbUtil.database();
    return db.query(table);
  }
}
