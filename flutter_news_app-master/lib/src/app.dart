import 'package:news/src/blocs/comments_bloc_provider.dart';
import './screens/newsDetail.dart';
import 'package:flutter/material.dart';
import 'screens/newsList.dart';
import './blocs/stories_bloc_provider.dart';

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CommentsBlocProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'NewsApp',
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    if (settings.name == '/') {
      return MaterialPageRoute(
        builder: (context) {
          return NewsList();
        },
      );
    } else {
      return MaterialPageRoute(
        builder: (context) {
          final commentsBloc = CommentsBlocProvider.of(context);
          final itemId = int.parse(settings.name.replaceFirst('/', ''));
          commentsBloc.fetchItemsWithComments(itemId);
          return NewsDetail(
            itemId: itemId,
          );
        },
      );
    }
  }
}
