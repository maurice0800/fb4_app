import 'package:fb4_app/areas/news/bloc/news_item_bloc.dart';
import 'package:flutter/cupertino.dart';
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
          middle: Text("News"),
        ),
        child: BlocBuilder<NewsItemBloc, NewsItemState>(
          builder: (context, state) {
            if (state is NewsItemLoaded) {
              return Text("Loaded");
            }
            return Container();
          },
        ));
  }
}
