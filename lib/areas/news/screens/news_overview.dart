import 'package:fb4_app/areas/news/viewmodels/news_overview_viewmodel.dart';
import 'package:fb4_app/areas/news/widgets/news_card.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

class NewsOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: ColorConsts.mainOrange,
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
                      CupertinoSliverRefreshControl(onRefresh: () {
                        return viewModel.fetchNewsItems();
                      }, builder: (context, mode, d1, d2, d3) {
                        const Curve opacityCurve =
                            Interval(0.0, 0.35, curve: Curves.easeInOut);
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Opacity(
                            opacity: opacityCurve.transform(min(d1 / d2, 1.0)),
                            child: CupertinoActivityIndicator.partiallyRevealed(
                                radius: 14.0, progress: min(d1 / d2, 1.0)),
                          ),
                        );
                      }),
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
