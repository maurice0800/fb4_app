import 'package:fb4_app/areas/news/models/news_item.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewsCard extends StatelessWidget {
  final NewsItem item;
  final bool noWrap;

  const NewsCard({Key? key, required this.item, this.noWrap = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!noWrap) {
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
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          Text(item.title,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18)),
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                            child: Divider(
                              color: ColorConsts.mainOrange,
                              thickness: 2,
                            ),
                          ),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Text(
                                  item.description + "\n\n" + '(${item.list})'),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 8.0),
                            child: Divider(
                              color: ColorConsts.mainOrange,
                              thickness: 2,
                            ),
                          ),
                          CupertinoButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Schließen",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
          );
        }
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
                    style: const TextStyle(fontWeight: FontWeight.bold)
                        .merge(CupertinoTheme.of(context).textTheme.textStyle)),
                const Divider(
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
                const Divider(
                  color: ColorConsts.mainOrange,
                  thickness: 2,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        item.list,
                        style: CupertinoTheme.of(context).textTheme.textStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
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
