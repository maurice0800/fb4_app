import 'package:fb4_app/areas/news/models/news_item.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
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
        if (!noWrap)
          showCupertinoDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => CupertinoPopupSurface(
                child: Center(
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    border:
                        Border.all(color: ColorConsts.mainOrange, width: 0.3),
                    color: CupertinoTheme.of(context).primaryContrastingColor),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: 600,
                      maxWidth: MediaQuery.of(context).size.width - 80),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 16.0),
                    child: Container(
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            Text(item.title,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 18)),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Divider(
                                color: ColorConsts.mainOrange,
                                thickness: 2,
                              ),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Text(item.description),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Divider(
                                color: ColorConsts.mainOrange,
                                thickness: 2,
                              ),
                            ),
                            CupertinoButton(
                                child: Text(
                                  "Schließen",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
          );
      },
      child: Card(
          color: CupertinoTheme.of(context).primaryContrastingColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    softWrap: true,
                    maxLines: noWrap == false ? 3 : 999999,
                    style: TextStyle(fontWeight: FontWeight.bold)
                        .merge(CupertinoTheme.of(context).textTheme.textStyle)),
                Divider(
                  color: ColorConsts.mainOrange,
                  thickness: 2,
                ),
                Text(
                  item.description,
                  softWrap: true,
                  maxLines: noWrap == false ? 3 : 999999,
                  overflow: TextOverflow.ellipsis,
                  style: CupertinoTheme.of(context).textTheme.textStyle,
                ),
                Divider(
                  color: ColorConsts.mainOrange,
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Aktuelles",
                        style: CupertinoTheme.of(context).textTheme.textStyle),
                    Text(
                      DateFormat('dd.MM.yyyy HH:mm').format(item.pubDate),
                      style: CupertinoTheme.of(context).textTheme.textStyle,
                    ),
                  ],
                )
              ],
            ),
          )),
    );
  }
}
