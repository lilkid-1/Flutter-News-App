import 'package:flutter/material.dart';
import 'package:news/src/blocs/stories_bloc.dart';
import 'package:news/src/widgets/loadingContainer.dart';
import '../blocs/stories_bloc_provider.dart';
import '../widgets/news_tile.dart';
import '../widgets/refresh.dart';

class NewsList extends StatelessWidget {
  const NewsList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    bloc.fetchTopIds();
    return Scaffold(
      appBar: AppBar(
        title: Text('News 24*7'),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (snapshot.hasData) {
          return Refresh(
            childFrom: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, int index) {
                bloc.fetchItem(snapshot.data[index]);
                return NewsTile(itemId: snapshot.data[index]);
              },
            ),
          );
        }
        return Center(
          child: LoadingContainer(),
        );
      },
    );
  }
}
