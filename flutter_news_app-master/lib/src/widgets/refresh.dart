import 'package:flutter/material.dart';
import '../blocs/stories_bloc_provider.dart';

class Refresh extends StatelessWidget {
  final Widget childFrom;
  Refresh({@required this.childFrom});
  @override
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    return RefreshIndicator(
        child: childFrom,
        onRefresh: () async {
          await bloc.clearCache();
          await bloc.fetchTopIds();
        });
  }
}
