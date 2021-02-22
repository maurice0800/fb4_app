import 'package:fb4_app/areas/news/viewmodels/news_overview_viewmodel.dart';
import 'package:fb4_app/areas/news/widgets/news_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewsOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          transitionBetweenRoutes: false,
          middle: Text("News",
              style: CupertinoTheme.of(context).textTheme.navTitleTextStyle),
        ),
        child: SafeArea(
          child: ChangeNotifierProvider(
              create: (context) => NewsOverviewViewModel()..fetchNewsItems(),
              child: Consumer<NewsOverviewViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.newsItems.length > 0) {
                    return CustomScrollView(slivers: [
                      CupertinoSliverRefreshControl(
                        onRefresh: () {
                          return viewModel.fetchNewsItems();
                        },
                      ),
                      SliverToBoxAdapter(
                        child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.separated(
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (context, index) =>
                                    NewsCard(item: viewModel.newsItems[index]),
                                separatorBuilder: (context, itemCount) =>
                                    SizedBox(height: 5),
                                itemCount: viewModel.newsItems.length)),
                      )
                    ]);
                  } else {
                    return Center(child: CupertinoActivityIndicator());
                  }
                },
              )),
        ));
  }
}
