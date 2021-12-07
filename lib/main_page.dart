import 'package:auto_route/auto_route.dart';
import 'package:fb4_app/core/routing/route_generator.gr.dart';
import 'package:fb4_app/core/views/base_view.dart';
import 'package:fb4_app/main_view_model.dart';
import 'package:fb4_app/utils/ui/icons/fb4app_icons.dart';
import 'package:flutter/cupertino.dart';

import 'areas/more/screens/privacy_page.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<MainViewModel>(
      builder: (context, viewModel, child) => viewModel.shouldShowPrivacyPolicy
          ? const PrivacyPage(shouldAccept: true)
          : AutoTabsScaffold(
              routes: const [
                ScheduleOverviewRoute(),
                NewsOverviewRoute(),
                CanteenOverviewRoute(),
                TicketViewerRoute(),
                MoreListRoute(),
              ],
              builder: (context, child, animation) => child,
              bottomNavigationBuilder: (context, router) => CupertinoTabBar(
                currentIndex: router.activeIndex,
                onTap: router.setActiveIndex,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.calendar),
                      label: 'Stundenplan'),
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.news), label: 'News'),
                  BottomNavigationBarItem(
                      icon: Padding(
                          padding: EdgeInsets.only(top: 6.0),
                          child: Icon(FB4Icons.food, size: 25)),
                      label: 'Mensa'),
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.ticket),
                      label: 'Semesterticket'),
                  BottomNavigationBarItem(
                      icon: Icon(CupertinoIcons.ellipsis), label: 'Mehr'),
                ],
              ),
            ),
    );
  }
}
