import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news/src/blocs/comments_bloc.dart';
import 'package:news/src/widgets/comment.dart';
import '../blocs/comments_bloc_provider.dart';
import '../models/item_model.dart';

class NewsDetail extends StatelessWidget {
  final int itemId;
  NewsDetail({@required this.itemId});
  @override
  Widget build(BuildContext context) {
    final bloc = CommentsBlocProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('News Detail'),
      ),
      body: buildBody(bloc),
    );
  }

  Widget buildBody(CommentsBloc bloc) {
    return StreamBuilder(
      stream: bloc.itemWithComments,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel>>> snapshot) {
        if (!snapshot.hasData) {
          return Text('Still Loading');
        }

        final itemFuture = snapshot.data[itemId];
        return FutureBuilder(
          future: itemFuture,
          builder: (context, AsyncSnapshot<ItemModel> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return Text('loading');
            }
            return buildList(snapshot.data, itemSnapshot.data);
          },
        );
      },
    );
  }

  Widget buildList(Map<int, Future<ItemModel>> itemMap, ItemModel item) {
    final children = <Widget>[];
    children.add(buildTitle(item));
    final listData = item.kids.map(
      (kidId) {
        return Comment(
          itemId: kidId,
          itemMap: itemMap,
          depth: 0,
        );
      },
    ).toList();
    children.addAll(listData);
    return ListView(
      children: children,
    );
  }

  Widget buildTitle(ItemModel item) {
    return Container(
      margin: EdgeInsets.all(20.0),
      alignment: Alignment(0.0, -1.0),
      child: Text(
        '${item.title}',
        style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
    );
  }
}
