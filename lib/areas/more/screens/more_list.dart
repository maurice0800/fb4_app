import 'package:fb4_app/areas/more/widgets/list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_settings/flutter_cupertino_settings.dart';

class MoreList extends StatelessWidget {
  const MoreList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          middle: Text("Mehr",
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
        ),
        child: Container(
          child: CupertinoSettings(items: <Widget>[
            CSLink(title: 'Links / Downloads'),
            CSLink(title: 'Feedback geben'),
            CSLink(title: 'Einstellungen'),
            CSLink(title: 'Über'),
          ]),
        ));
  }
}
