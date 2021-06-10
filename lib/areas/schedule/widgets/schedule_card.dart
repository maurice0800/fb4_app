import 'package:fb4_app/areas/schedule/models/schedule_item.dart';
import 'package:fb4_app/config/themes/color_consts.dart';
import 'package:fb4_app/utils/ui/widgets/cupertino_checkbox.dart';
import 'package:flutter/cupertino.dart';

class ScheduleCard extends StatefulWidget {
  final ScheduleItem item;
  final bool editMode;
  final Function(ScheduleItem) onItemSelected;
  final Function(ScheduleItem) onItemDeselected;
  final bool isChecked;

  ScheduleCard(
      {required this.item,
      required this.editMode,
      required this.onItemSelected,
      required this.onItemDeselected,
      required this.isChecked});

  @override
  State<StatefulWidget> createState() => ScheduleCardState(isChecked);
}

class ScheduleCardState extends State<ScheduleCard> {
  bool isChecked = false;

  ScheduleCardState(bool isChecked) {
    this.isChecked = isChecked;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isChecked = !isChecked;
            if (isChecked) {
              widget.onItemSelected(widget.item);
            } else {
              widget.onItemDeselected(widget.item);
            }
          });
        },
        child: SizedBox(
          height: 90,
          child: Container(
              decoration: BoxDecoration(
                  color: widget.item.userIsInGroup
                      ? widget.item.color
                      : ColorConsts.mainOrange.withAlpha(168),
                  borderRadius: BorderRadius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    widget.editMode
                        ? CupertinoCheckBox(
                            isChecked: isChecked,
                            onChanged: (value) {},
                          )
                        : Container(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.item.timeBegin.toString().substring(0, 2) +
                              ':' +
                              widget.item.timeBegin.toString().substring(2),
                          style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.item.timeEnd.toString().substring(0, 2) +
                              ':' +
                              widget.item.timeEnd.toString().substring(2),
                          style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "[${widget.item.courseType}] ${widget.item.name}",
                            style: TextStyle(
                                color: CupertinoColors.white,
                                fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          Text(
                            '${widget.item.studentSet == "" ? "*" : widget.item.studentSet} | ${widget.item.lecturerName} (${widget.item.lecturerId})',
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            widget.item.roomId,
                            style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
