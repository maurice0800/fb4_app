import 'package:fb4_app/areas/schedule/models/schedule_item.dart';

class ScheduleListController {
  late Function(ScheduleItem) onItemSelected;
  late Function(ScheduleItem) onItemDeselected;
  Function(ScheduleItem)? onItemChanged;
  Function(ScheduleItem)? onItemRemoved;
  List<ScheduleItem> selectedItems = [];

  ScheduleListController({this.onItemRemoved}) {
    onItemSelected = (item) => selectedItems.add(item);
    onItemDeselected = (item) => selectedItems.remove(item);
  }
}
