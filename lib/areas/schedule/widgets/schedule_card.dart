import 'package:flutter/cupertino.dart';

class ScheduleCard extends StatelessWidget {
  final String title;
  final String timeStart;
  final String timeEnd;
  final String group;
  final String lecturer;
  final String room;

  const ScheduleCard(
      {Key key,
      this.title,
      this.timeStart,
      this.timeEnd,
      this.group,
      this.lecturer,
      this.room})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        timeStart.substring(0, 2) +
                            ':' +
                            timeStart.substring(2),
                        style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                      Text(
                        timeEnd.substring(0, 2) + ':' + timeEnd.substring(2),
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: CupertinoColors.white,
                        ),
                      ),
                      Text(
                        '$group | $lecturer',
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        room,
                        style: TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
