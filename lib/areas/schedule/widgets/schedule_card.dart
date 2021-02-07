import 'package:fb4_app/areas/schedule/models/schedule_item.dart';
import 'package:fb4_app/utils/ui/widgets/cupertino_checkbox.dart';
import 'package:flutter/cupertino.dart';

class ScheduleCard extends StatefulWidget {
  final ScheduleItem item;
  final bool editMode;
  final Function(ScheduleItem) onItemSelected;
  final Function(ScheduleItem) onItemDeselected;
  bool isChecked = false;

  ScheduleCard(
      {this.item,
      this.editMode,
      this.onItemSelected,
      this.onItemDeselected,
      this.isChecked});

  @override
  State<StatefulWidget> createState() => ScheduleCardState();
}

class ScheduleCardState extends State<ScheduleCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.isChecked = !widget.isChecked;
            if (widget.isChecked) {
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
                  color: CupertinoColors.activeOrange,
                  borderRadius: BorderRadius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    widget.editMode
                        ? CupertinoCheckBox(
                            isChecked: widget.isChecked,
                          )
                        : Container(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.item.timeBegin.substring(0, 2) +
                              ':' +
                              widget.item.timeBegin.substring(2),
                          style: TextStyle(
                              color: CupertinoColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          widget.item.timeEnd.substring(0, 2) +
                              ':' +
                              widget.item.timeEnd.substring(2),
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
                            '${widget.item.studentSet} | ${widget.item.lecturerId}',
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
