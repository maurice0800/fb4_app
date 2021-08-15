import 'package:fb4_app/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:quick_actions/quick_actions.dart';

class QuickActionsManager {
  final QuickActions quickActions = QuickActions();
  final CupertinoTabController tabController;

  QuickActionsManager(this.tabController);

  init() {
    quickActions.setShortcutItems(<ShortcutItem>[
      const ShortcutItem(
          type: AppConstants.quickActionTicket,
          localizedTitle: 'Ticket anzeigen',
          icon: 'ticket'),
    ]);

    quickActions.initialize((shortcutType) {
      tabController.index = 3;
    });
  }
}