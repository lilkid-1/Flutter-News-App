import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  const LoadingContainer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(children: <Widget>[
        ListTile(title: greyBox(context), subtitle: greyBox(context)),
        Divider(height: 8.0),
      ]),
    );
  }

  Widget greyBox(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 20,
      width: (MediaQuery.of(context).size.height / 5) * 0.9,
      color: Colors.grey[200],
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0),
    );
  }
}
