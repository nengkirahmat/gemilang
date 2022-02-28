import 'package:api_cache_manager/api_cache_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE bookmark(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        cache TEXT,
        nama TEXT
      )
      """);
  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'gemilang.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (journal)
  static Future<int> createItem(String nama, String? cache) async {
    final db = await SQLHelper.db();

    final data = {'nama': nama, 'cache': cache};
    final id = await db.insert('bookmark', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('bookmark', orderBy: "id DESC");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('bookmark', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(int id, String cache, String? nama) async {
    final db = await SQLHelper.db();

    final data = {
      'cache': cache,
      'nama': nama,
    };

    final result =
        await db.update('bookmark', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(String id) async {
    final db = await SQLHelper.db();
    try {
      var adaCache = await APICacheManager().isAPICacheKeyExist(id);
      if (adaCache) {
        print('ada cache' + id);
        await APICacheManager().deleteCache(id);
      } else {
        print('ga ada' + id);
      }
      await db.delete("bookmark", where: "cache = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Gagal menghapus Bookmark: $err");
    }
  }

  // Empty Table
  static Future<void> emptyCache() async {
    final db = await SQLHelper.db();
    try {
      await APICacheManager().emptyCache();
      await db.execute("delete from bookmark");
    } catch (err) {
      debugPrint("Gagal menghapus Bookmark: $err");
    }
  }
}
