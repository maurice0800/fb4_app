import 'package:flutter/cupertino.dart';

class CupertinoCheckBox extends StatelessWidget {
  final bool isChecked;
  final String caption;
  final Function(bool) onChanged;

  const CupertinoCheckBox({
    Key key,
    this.isChecked = false,
    this.caption = "",
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: GestureDetector(
          onTap: () => this.onChanged(!this.isChecked),
          child: Container(
              child: Row(
            children: [
              Icon(isChecked
                  ? CupertinoIcons.checkmark_circle_fill
                  : CupertinoIcons.circle),
              SizedBox(width: 10),
              Text(this.caption),
            ],
          )),
        ));
  }
}
