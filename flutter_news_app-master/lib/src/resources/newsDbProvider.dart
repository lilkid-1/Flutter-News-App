import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import '../models/item_model.dart';
import 'repository.dart';

class NewsDbProvider implements Source, Cache {
  var readyCompleter = Completer();
  Future get ready => readyCompleter.future;
  NewsDbProvider() {
    init().then((_) {
      // mark the provider ready when init completes
      readyCompleter.complete();
    });
  }
  Database db;
  Future init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'items.db');
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) {
        newDb.execute("""
        create table items(
          id integer primary key,
          deleted integer,
          type text,
          by text,
          time integer,
          text text,
          dead integer,
          parent integer,
          kids blob,
          url text,
          score integer,
          title text,
          descendants integer
        )
      """);
      },
    );
  }

  Future<List<int>> fetchTopIds() {
    return null;
  }

  Future<ItemModel> fetchItem(int id) async {
    await ready;
    final maps = await db.query(
      "items",
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return ItemModel.fromDb(maps.first);
    }
    return null;
  }

  addItem(ItemModel item) {
    return db.insert('items', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  Future<int> clearCache() async {
    int a = await db.delete('items');
    return a;
  }
}

NewsDbProvider newsDbProvider = NewsDbProvider();
