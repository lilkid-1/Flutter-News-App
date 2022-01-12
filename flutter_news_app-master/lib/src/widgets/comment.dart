import 'package:flutter/material.dart';
import 'package:news/src/models/item_model.dart';
import 'loadingContainer.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel>> itemMap;
  Comment({this.itemId, this.itemMap, this.depth});
  final int depth;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }

        final children = <Widget>[
          buildTile(snapshot),
          Divider(
            color: Colors.blueGrey,
          )
        ];

        snapshot.data.kids.forEach(
          (kidId) {
            children.add(
              Comment(itemId: kidId, itemMap: itemMap, depth: depth + 1),
            );
          },
        );
        return Column(
          children: children,
        );
      },
    );
  }

  Widget buildTile(AsyncSnapshot<ItemModel> snapshot) {
    return ListTile(
      contentPadding: EdgeInsets.only(left: (depth + 1) * 16.0, right: 16.0),
      title: Text(snapshot.data.text),
      subtitle:
          snapshot.data.by == '' ? Text('deleted') : Text(snapshot.data.by),
    );
  }
}
