import 'package:fb4_app/areas/schedule/models/schedule_item.dart';
import 'package:fb4_app/areas/schedule/models/schedule_list_controller.dart';
import 'package:fb4_app/areas/schedule/widgets/schedule_card.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class ScheduleList extends StatefulWidget {
  final String weekday;
  final List<ScheduleItem> items;
  final ScheduleListController controller;

  const ScheduleList(
      {Key? key,
      required this.weekday,
      this.items = const [],
      required this.controller})
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
                separatorBuilder: (context, index) => const SizedBox(height: 5),
                itemBuilder: (context, index) => GestureDetector(
                  onLongPress: () => widget.items[index].editMode == false
                      ? showContextMenu(context, index)
                      : {},
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

  void showContextMenu(BuildContext context, int index) {
    showCupertinoModalPopup(
        context: context,
        builder: (builder) => CupertinoActionSheet(
              actions: [
                CupertinoActionSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    showCupertinoDialog(
                        context: context,
                        builder: (context) => CupertinoAlertDialog(
                              title: const Text("Farbe wählen"),
                              content: BlockPicker(
                                  layoutBuilder: (context, colors, child) =>
                                      SizedBox(
                                        height: 365,
                                        width: 300,
                                        child: GridView.count(
                                          controller: ScrollController(
                                              initialScrollOffset: 30),
                                          crossAxisCount: 4,
                                          crossAxisSpacing: 5.0,
                                          mainAxisSpacing: 5.0,
                                          children: colors
                                              .map(
                                                  (Color color) => child(color))
                                              .toList(),
                                        ),
                                      ),
                                  availableColors: const [
                                    Colors.red,
                                    Colors.pink,
                                    Colors.purple,
                                    Colors.deepPurple,
                                    Colors.indigo,
                                    Colors.blue,
                                    Colors.lightBlue,
                                    Colors.blueAccent,
                                    Colors.cyan,
                                    Colors.teal,
                                    Colors.green,
                                    Colors.lightGreen,
                                    Colors.lime,
                                    Colors.yellow,
                                    ColorConsts.mainOrange,
                                    Colors.amber,
                                    Colors.orange,
                                    Colors.deepOrange,
                                    Colors.brown,
                                    Colors.grey,
                                    Colors.blueGrey,
                                    Colors.black,
                                  ],
                                  pickerColor: widget.items[index].color,
                                  onColorChanged: (color) {
                                    setState(() {
                                      widget.items[index].color = color;
                                    });

                                    if (widget.controller.onItemChanged !=
                                        null) {
                                      widget.controller
                                          .onItemChanged!(widget.items[index]);
                                    }

                                    Navigator.of(context).pop();
                                  }),
                              actions: [
                                CupertinoDialogAction(
                                  child: const Text("Abbrechen"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ));
                  },
                  child: const Text("Farbe ändern"),
                ),
                CupertinoActionSheetAction(
                  onPressed: () async {
                    if (widget.controller.onItemRemoved != null) {
                      widget.controller.onItemRemoved!(widget.items[index]);
                    }
                    widget.items.removeAt(index);
                    Navigator.pop(context);
                  },
                  isDestructiveAction: true,
                  child: const Text("Eintrag entfernen"),
                ),
              ],
            ));
  }

  @override
  bool get wantKeepAlive => true;
}
