import 'package:fb4_app/areas/news/viewmodels/news_overview_viewmodel.dart';
import 'package:fb4_app/areas/news/widgets/news_card.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:fb4_app/core/views/base_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class NewsOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<NewsOverviewViewModel>(
        onViewModelCreated: (viewModel) =>
            viewModel.fetchNewsItems(alwaysRefresh: false),
        builder: (context, viewModel, child) => CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                backgroundColor: ColorConsts.mainOrange,
                transitionBetweenRoutes: false,
                middle: Text("News",
                    style:
                        CupertinoTheme.of(context).textTheme.navTitleTextStyle),
              ),
              child: SafeArea(child: Builder(
                builder: (context) {
                  if (!viewModel.isLoading) {
                    return viewModel.hasError
                        ? Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Es ist ein Fehler aufgetreten."),
                              SizedBox(
                                height: 10,
                              ),
                              CupertinoButton.filled(
                                  child: Text("Nochmal versuchen"),
                                  onPressed: () {
                                    viewModel
                                      ..fetchNewsItems(
                                          onError: (message) => showErrorDialog(
                                              context, message));
                                  })
                            ],
                          ))
                        : CustomScrollView(slivers: [
                            CupertinoSliverRefreshControl(onRefresh: () {
                              return viewModel.fetchNewsItems(
                                  onError: (message) =>
                                      showErrorDialog(context, message));
                            }, builder: (context, mode, d1, d2, d3) {
                              const Curve opacityCurve =
                                  Interval(0.0, 0.35, curve: Curves.easeInOut);
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Opacity(
                                  opacity:
                                      opacityCurve.transform(min(d1 / d2, 1.0)),
                                  child: CupertinoActivityIndicator
                                      .partiallyRevealed(
                                          radius: 14.0,
                                          progress: min(d1 / d2, 1.0)),
                                ),
                              );
                            }),
                            SliverToBoxAdapter(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      itemBuilder: (context, index) => NewsCard(
                                          item: viewModel.newsItems[index]),
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

  void showErrorDialog(BuildContext context, String message) {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: Text("Fehler"),
              content: Text(
                  "Beim Abrufen der News ist ein Fehler aufgetreten:\n" +
                      message),
              actions: [
                GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Schließen",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  onTap: () => Navigator.pop(context),
                )
              ],
            ));
  }
}
