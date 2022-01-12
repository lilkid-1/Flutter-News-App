import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' show Client;
import 'package:news/src/models/item_model.dart';
import 'repository.dart';

class NewsApiProvider implements Source {
  Client client = Client();

  Future<List<int>> fetchTopIds() async {
    final response = await client
        .get('https://hacker-news.firebaseio.com/v0/topstories.json');
    final topIds = jsonDecode(response.body);
    return topIds.cast<int>();
  }

  Future<ItemModel> fetchItem(int id) async {
    final response = await client.get(
        'https://hacker-news.firebaseio.com/v0/item/$id.json?print=pretty');
    final parsedItemData = jsonDecode(response.body);
    return ItemModel.fromJson(parsedItemData);
  }
}
