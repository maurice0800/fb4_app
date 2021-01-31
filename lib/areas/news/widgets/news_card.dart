import 'package:fb4_app/areas/news/models/news_item.dart';
import 'package:fb4_app/areas/news/screens/news_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsCard extends StatelessWidget {
  final NewsItem item;
  final bool noWrap;

  const NewsCard({Key key, this.item, this.noWrap = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showGeneralDialog(
            context: context,
            barrierLabel: "Barrier",
            barrierDismissible: true,
            barrierColor: CupertinoColors.black.withOpacity(0.6),
            transitionDuration: Duration(milliseconds: 200),
            transitionBuilder:
                (context, animation, secondaryAnimation, child) =>
                    SlideTransition(
                        position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
                            .animate(animation),
                        child: child),
            pageBuilder: (context, animation, secondaryAnimation) => Align(
                  alignment: Alignment.center,
                  child: Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0)),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                              maxHeight:
                                  MediaQuery.of(context).size.height - 150),
                          child: CupertinoScrollbar(
                            child: SingleChildScrollView(
                              child: NewsCard(
                                item: item,
                                noWrap: true,
                              ),
                            ),
                          ),
                        ),
                        CupertinoButton(
                            child: Text("Schließen",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w500)),
                            onPressed: () {
                              Navigator.of(context).pop();
                            })
                      ],
                    ),
                  ),
                ));
      },
      child: Card(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.title,
                softWrap: true,
                maxLines: noWrap == false ? 3 : 999999,
                style: TextStyle(fontWeight: FontWeight.bold)),
            Divider(
              color: CupertinoColors.activeOrange,
              thickness: 2,
            ),
            Text(
              item.description,
              softWrap: true,
              maxLines: noWrap == false ? 3 : 999999,
              overflow: TextOverflow.ellipsis,
            ),
            Divider(
              color: CupertinoColors.activeOrange,
              thickness: 2,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Aktuelles"),
                Text(DateFormat('dd.MM.yyyy HH:mm').format(item.pubDate)),
              ],
            )
          ],
        ),
      )),
    );
  }
}
