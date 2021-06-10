import 'package:flutter/cupertino.dart';

class CupertinoCheckBox extends StatelessWidget {
  final bool isChecked;
  final String caption;
  final Function(bool) onChanged;
  final Color fillColor;

  const CupertinoCheckBox({
    Key? key,
    required this.isChecked,
    this.caption = "",
    required this.onChanged,
    this.fillColor = CupertinoColors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: GestureDetector(
          onTap: () => onChanged(!isChecked),
          child: Container(
              child: Row(
            children: [
              Icon(
                isChecked
                    ? CupertinoIcons.checkmark_circle_fill
                    : CupertinoIcons.circle,
                color: fillColor,
              ),
              const SizedBox(width: 10),
              Text(caption),
            ],
          )),
        ));
  }
}
