import 'package:fb4_app/areas/schedule/models/schedule_item.dart';
import 'package:fb4_app/areas/schedule/models/schedule_list_controller.dart';
import 'package:fb4_app/areas/schedule/widgets/schedule_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:json_store/json_store.dart';

class ScheduleList extends StatefulWidget {
  final String weekday;
  final List<ScheduleItem> items;
  final ScheduleListController controller;

  const ScheduleList(
      {Key key, this.weekday, this.items = const [], this.controller})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ScheduleListState();
}

class ScheduleListState extends State<ScheduleList>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: ListView.separated(
                itemCount: widget.items.length,
                separatorBuilder: (context, index) => SizedBox(height: 5),
                itemBuilder: (context, index) => GestureDetector(
                  onLongPress: () => showDeletePopup(context, index),
                  child: ScheduleCard(
                    isChecked: widget.controller.selectedItems
                        .contains(widget.items[index]),
                    onItemSelected: widget.controller.onItemSelected,
                    onItemDeselected: widget.controller.onItemDeselected,
                    editMode: widget.items[index].editMode,
                    item: widget.items[index],
                  ),
                ),
              ),
            ),
          ]),
    );
  }

  void showDeletePopup(BuildContext context, int index) {
    showCupertinoModalPopup(
        context: context,
        builder: (builder) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () async {
                    if (widget.controller.onItemRemoved != null) {
                      widget.controller.onItemRemoved(widget.items[index]);
                    }
                    widget.items.removeAt(index);
                    Navigator.pop(context);
                  },
                  child: Text("Eintrag entfernen"),
                  isDestructiveAction: true,
                )
              ],
            ));
  }

  @override
  bool get wantKeepAlive => true;
}
