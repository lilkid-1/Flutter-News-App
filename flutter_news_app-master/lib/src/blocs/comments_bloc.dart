import 'package:news/src/models/item_model.dart';
import 'package:rxdart/rxdart.dart';
import 'dart:async';
import '../resources/repository.dart';

class CommentsBloc {
  final Repository _repository = Repository();
  final _commentsFetcher = PublishSubject<int>();
  final _comments = BehaviorSubject<Map<int, Future<ItemModel>>>();

  //Streams
  Stream<Map<int, Future<ItemModel>>> get itemWithComments => _comments.stream;
  //Sink
  Function(int) get fetchItemsWithComments => _commentsFetcher.sink.add;
  //Constructor
  CommentsBloc() {
    _commentsFetcher.stream.transform(_commentsTranformer()).pipe(_comments);
  }

  _commentsTranformer() {
    return ScanStreamTransformer<int, Map<int, Future<ItemModel>>>(
      (cache, int id, int index) {
        print(index);
        cache[id] = _repository.fetchItem(id);
        cache[id].then(
          (ItemModel item) {
            item.kids.forEach((kidId) => fetchItemsWithComments(kidId));
          },
        );
        return cache;
      },
      <int, Future<ItemModel>>{},
    );
  }

  dispose() {
    _comments.close();
    _commentsFetcher.close();
  }
}
