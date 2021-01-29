import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';

class NavigationListItem extends StatelessWidget {
  final Icon icon;
  final GestureTapCallback callback;

  const NavigationListItem({Key key, this.icon, this.callback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: callback,
      child: SizedBox(
        height: 80,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              icon,
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Text("ListItem"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
