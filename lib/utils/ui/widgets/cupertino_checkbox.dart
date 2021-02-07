import 'package:flutter/cupertino.dart';

class CupertinoCheckBox extends StatelessWidget {
  final bool isChecked;

  const CupertinoCheckBox({Key key, this.isChecked = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 8.0),
      child: Container(
        child: Icon(
            isChecked
                ? CupertinoIcons.checkmark_circle_fill
                : CupertinoIcons.circle,
            color: CupertinoColors.white),
      ),
    );
  }
}
