import 'package:fb4_app/areas/news/bloc/news_item_bloc.dart';
import 'package:fb4_app/areas/news/widgets/news_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsOverview extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => NewsOverviewState();
}

class NewsOverviewState extends State<NewsOverview> {
  NewsItemBloc newsItemBloc;

  @override
  void initState() {
    super.initState();
    newsItemBloc = BlocProvider.of<NewsItemBloc>(context);
    newsItemBloc.add(FetchNewsItemsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          middle: Text("News", style: TextStyle(color: CupertinoColors.white)),
          backgroundColor: CupertinoColors.activeOrange,
        ),
        child: BlocBuilder<NewsItemBloc, NewsItemState>(
          builder: (context, state) {
            if (state is NewsItemLoaded) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.separated(
                    itemBuilder: (context, index) =>
                        NewsCard(item: state.newsItems[index]),
                    separatorBuilder: (context, itemCount) =>
                        SizedBox(height: 5),
                    itemCount: state.newsItems.length),
              );
            } else if (state is NewsItemLoading || state is NewsItemInitial) {
              return Center(child: CupertinoActivityIndicator());
            } else if (state is NewsItemError) {
              return Center(
                child: Text(state.message),
              );
            }
          },
        ));
  }
}
