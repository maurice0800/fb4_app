import 'package:fb4_app/areas/schedule/models/schedule_item.dart';

class ScheduleListController {
  final Function(ScheduleItem) onItemSelected;
  final Function(ScheduleItem) onItemDeselected;
  final Function(ScheduleItem) onItemRemoved;
  final Function(ScheduleItem) onItemUpdated;
  List<ScheduleItem> selectedItems = List<ScheduleItem>();

  ScheduleListController(this.onItemSelected, this.onItemDeselected,
      this.onItemRemoved, this.onItemUpdated);
}
