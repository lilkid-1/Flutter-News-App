import 'dart:async';
import 'newsDbProvider.dart';
import 'newsapiProvider.dart';
import '../models/item_model.dart';

class Repository {
  List<Source> sources = <Source>[NewsDbProvider(), NewsApiProvider()];
  List<Cache> caches = <Cache>[NewsDbProvider()];

  Future<int> clearCache() async {
    int futureCacheReturn;
    for (var cache in caches) {
      futureCacheReturn = await cache.clearCache();
    }
    return futureCacheReturn;
  }

  Future<List<int>> fetchTopIds() async {
    final data = await sources[1].fetchTopIds();
    return data;
  }

  Future<ItemModel> fetchItem(int id) async {
    ItemModel item;
    Source source;

    for (source in sources) {
      item = await source.fetchItem(id);
      if (item != null) {
        break;
      }
    }
    for (var cache in caches) {
      cache.addItem(item);
    }
    return item;
  }
}

abstract class Source {
  Future<List<int>> fetchTopIds();
  Future<ItemModel> fetchItem(int id);
}

abstract class Cache {
  Future<dynamic> addItem(ItemModel item);
  Future<int> clearCache();
}
