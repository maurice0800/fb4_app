import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class CupertinoHorizontalDatePicker extends StatefulWidget {
  final Function(DateTime)? onDateTimeChanged;
  final DateTime? initialDate;

  CupertinoHorizontalDatePicker(
      {Key? key, this.onDateTimeChanged, this.initialDate})
      : super(key: key);

  @override
  _CupertinoHorizontalDatePickerState createState() =>
      _CupertinoHorizontalDatePickerState();
}

class _CupertinoHorizontalDatePickerState
    extends State<CupertinoHorizontalDatePicker> {
  final format = DateFormat("EEEE - dd.MM.yyyy", "de_DE");

  @override
  Widget build(BuildContext context) {
    DateTime date = widget.initialDate ?? DateTime.now();
    return Container(
      decoration: BoxDecoration(
        color: CupertinoTheme.of(context).barBackgroundColor,
        border: const Border(
          bottom: BorderSide(
            color: Color(0x4D000000),
            width: 0.0,
          ),
        ),
      ),
      height: 40.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => setState(
              () {
                date = date.subtract(const Duration(days: 1));

                if (widget.onDateTimeChanged != null) {
                  widget.onDateTimeChanged!(date);
                }
              },
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(CupertinoIcons.left_chevron),
            ),
          ),
          Text(format.format(date),
              style: const TextStyle(fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: () => setState(
              () {
                date = date.add(const Duration(days: 1));

                if (widget.onDateTimeChanged != null) {
                  widget.onDateTimeChanged!(date);
                }
              },
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.0),
              child: Icon(CupertinoIcons.right_chevron),
            ),
          ),
        ],
      ),
    );
  }
}
