import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:kiwi/kiwi.dart';

class BaseView<T extends ChangeNotifier> extends StatelessWidget {
  final Widget Function(BuildContext context, T value, Widget child) builder;
  final Function(T) onViewModelCreated;

  const BaseView({this.builder, Key key, this.onViewModelCreated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    T viewModel = KiwiContainer().resolve<T>();

    if (onViewModelCreated != null) {
      onViewModelCreated(viewModel);
    }

    return ChangeNotifierProvider<T>.value(
      value: viewModel,
      child: Consumer<T>(
        builder: builder,
      ),
    );
  }
}
