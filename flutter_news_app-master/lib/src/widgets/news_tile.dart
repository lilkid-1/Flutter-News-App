import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/stories_bloc_provider.dart';
import 'dart:async';
import 'loadingContainer.dart';

class NewsTile extends StatelessWidget {
  NewsTile({@required this.itemId});
  final int itemId;

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }
        return FutureBuilder(
          future: snapshot.data[itemId],
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return LoadingContainer();
            }
            return Column(
              children: <Widget>[
                buildTile(context, itemSnapshot.data),
              ],
            );
          },
        );
      },
    );
  }
}

Widget buildTile(BuildContext context, ItemModel item) {
  return ListTile(
    onTap: () {
      Navigator.pushNamed(context, '/${item.id}');
    },
    title: Text('${item.title}'),
    subtitle: Text('${item.score} votes'),
    trailing: Column(
      children: <Widget>[Icon(Icons.comment), Text('${item.descendants}')],
    ),
  );
}
