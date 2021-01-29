import 'package:fb4_app/areas/schedule/models/schedule_item.dart';
import 'package:fb4_app/areas/schedule/widgets/schedule_card.dart';
import 'package:flutter/cupertino.dart';

class ScheduleList extends StatelessWidget {
  final String weekday;
  final List<ScheduleItem> items;

  const ScheduleList({Key key, this.weekday, this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              weekday,
              style: TextStyle(
                  color: CupertinoTheme.of(context).textTheme.textStyle.color,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.separated(
                itemCount: items.length,
                separatorBuilder: (context, index) => SizedBox(height: 5),
                itemBuilder: (context, index) => ScheduleCard(
                  timeStart: items[index].timeBegin,
                  timeEnd: items[index].timeEnd,
                  title: "${items[index].courseType} ${items[index].name}",
                  group: "${items[index].studentSet}",
                  lecturer:
                      "${items[index].lecturerName} (${items[index].lecturerId})",
                  room: "${items[index].roomId}",
                ),
              ),
            ),
          ]),
    );
  }
}
