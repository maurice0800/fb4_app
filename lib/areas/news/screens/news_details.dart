import 'package:fb4_app/areas/news/models/news_item.dart';
import 'package:fb4_app/areas/news/widgets/news_card.dart';
import 'package:flutter/cupertino.dart';

class NewsDetails extends StatelessWidget {
  final NewsItem item;

  const NewsDetails({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          heroTag: 'newsDetailsPageNavigationBar',
          transitionBetweenRoutes: false,
          middle: Text(
            "Newsdetails",
            style: CupertinoTheme.of(context).textTheme.navTitleTextStyle,
          ),
          trailing: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child:
                    Icon(CupertinoIcons.multiply, color: CupertinoColors.white),
              )),
          backgroundColor: CupertinoColors.activeOrange,
        ),
        child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: NewsCard(item: item, noWrap: true))));
  }
}
