import 'package:fb4_app/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:quick_actions/quick_actions.dart';

class QuickActionsManager {
  final QuickActions quickActions = const QuickActions();
  final CupertinoTabController tabController;

  QuickActionsManager(this.tabController);

  Future init() async {
    quickActions.initialize((shortcutType) => tabController.index = 3);

    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
        type: AppConstants.quickActionTicket,
        localizedTitle: 'Ticket anzeigen',
        icon: 'ticket',
      ),
    ]);
  }
}
