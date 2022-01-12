import '../models/item_model.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import '../resources/repository.dart';

class StoriesBloc {
  final Repository _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _item = BehaviorSubject<Map<int, Future<ItemModel>>>();
  final _itemFetcher = PublishSubject<int>();

  //Getters to stream
  Stream<List<int>> get topIds => _topIds.stream;
  Stream<Map<int, Future<ItemModel>>> get items => _item.stream;
  //Getters to sink
  Function(int) get fetchItem => _itemFetcher.sink.add;

  StoriesBloc() {
    _itemFetcher.stream.transform(_itemTransformer()).pipe(_item);
  }

  _itemTransformer() {
    return ScanStreamTransformer(
      (Map<int, Future<ItemModel>> cache, int id, int index) {
        print(index);
        cache[id] = _repository.fetchItem(id);
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  Future<int> clearCache() async {
    return _repository.clearCache();
  }

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    _topIds.sink.add(ids);
  }

  dispose() {
    _topIds.close();
    _item.close();
    _itemFetcher.close();
  }
}
