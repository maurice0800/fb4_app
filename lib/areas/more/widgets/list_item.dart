import 'package:flutter/cupertino.dart';

class NavigationListItem extends StatelessWidget {
  final Icon icon;
  final GestureTapCallback callback;

  const NavigationListItem({
    Key? key,
    required this.icon,
    required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: SizedBox(
        height: 80,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              icon,
              const Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: Text("ListItem"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
