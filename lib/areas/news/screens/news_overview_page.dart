import 'package:fb4_app/areas/news/viewmodels/news_overview_viewmodel.dart';
import 'package:fb4_app/areas/news/widgets/news_card.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:fb4_app/core/views/base_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NewsOverviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BaseView<NewsOverviewViewModel>(
        onViewModelCreated: (viewModel) {
          viewModel.fetchNewsItems(
              alwaysRefresh: false,
              onError: (message) => _showErrorDialog(context, message));
          viewModel.loadPinnedItemsCache();
        },
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
                              const Text("Es ist ein Fehler aufgetreten."),
                              const SizedBox(
                                height: 10,
                              ),
                              CupertinoButton.filled(
                                  child: const Text("Nochmal versuchen"),
                                  onPressed: () {
                                    viewModel.hasError = false;
                                    viewModel.fetchNewsItems(
                                        onError: (message) =>
                                            _showErrorDialog(context, message));
                                  })
                            ],
                          ))
                        : CustomScrollView(slivers: [
                            CupertinoSliverRefreshControl(onRefresh: () {
                              return viewModel.fetchNewsItems(
                                  onError: (message) =>
                                      _showErrorDialog(context, message));
                            }),
                            if (viewModel.pinnedItems.isNotEmpty)
                              const SliverToBoxAdapter(
                                child: Padding(
                                  padding:
                                      EdgeInsets.only(left: 14.0, top: 12.0),
                                  child: Text("Angepinnte Elemente",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            SliverToBoxAdapter(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      itemBuilder: (context, index) =>
                                          _buildPinnedNewsItem(
                                              context, index, viewModel),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 5),
                                      itemCount: viewModel.pinnedItems.length)),
                            ),
                            if (viewModel.pinnedItems.isNotEmpty)
                              const SliverToBoxAdapter(
                                child: Divider(
                                  color: CupertinoColors.lightBackgroundGray,
                                  thickness: 2,
                                ),
                              ),
                            SliverToBoxAdapter(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: const ScrollPhysics(),
                                      itemBuilder: (context, index) =>
                                          _buildNewsItem(
                                              context, index, viewModel),
                                      separatorBuilder: (context, index) =>
                                          const SizedBox(height: 5),
                                      itemCount: viewModel.newsItems.length)),
                            ),
                          ]);
                  } else {
                    return const Center(child: CupertinoActivityIndicator());
                  }
                },
              )),
            ));
  }

  void _showErrorDialog(BuildContext context, String message) {
    showCupertinoDialog(
        context: context,
        builder: (context) => CupertinoAlertDialog(
              title: const Text("Fehler"),
              content: Text(
                  "Beim Abrufen der News ist ein Fehler aufgetreten:\n$message"),
              actions: [
                GestureDetector(
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
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

  Widget _buildNewsItem(
      BuildContext context, int index, NewsOverviewViewModel viewModel) {
    return GestureDetector(
      onLongPress: () {
        showCupertinoModalPopup(
            context: context,
            builder: (builder) => CupertinoActionSheet(actions: [
                  CupertinoActionSheetAction(
                    onPressed: () {
                      viewModel.pinNewsItem(viewModel.newsItems[index]);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Element anpinnen"),
                  )
                ]));
      },
      child: NewsCard(item: viewModel.newsItems[index]),
    );
  }

  Widget _buildPinnedNewsItem(
      BuildContext context, int index, NewsOverviewViewModel viewModel) {
    return GestureDetector(
      onLongPress: () {
        showCupertinoModalPopup(
            context: context,
            builder: (builder) => CupertinoActionSheet(actions: [
                  CupertinoActionSheetAction(
                    onPressed: () {
                      viewModel.unpinNewsItem(index);
                      Navigator.of(context).pop();
                    },
                    child: const Text("Element ablösen"),
                  )
                ]));
      },
      child: NewsCard(item: viewModel.pinnedItems[index]),
    );
  }
}
