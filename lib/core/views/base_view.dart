import 'package:flutter/cupertino.dart';
import 'package:kiwi/kiwi.dart';
import 'package:provider/provider.dart';

class BaseView<T extends ChangeNotifier> extends StatelessWidget {
  final Widget Function(BuildContext context, T value, Widget? child) builder;
  final Function(T)? onViewModelCreated;

  const BaseView({required this.builder, Key? key, this.onViewModelCreated})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = KiwiContainer().resolve<T>();

    if (onViewModelCreated != null) {
      onViewModelCreated!(viewModel);
    }

    return ChangeNotifierProvider<T>.value(
      value: viewModel,
      child: Consumer<T>(
        builder: builder,
      ),
    );
  }
}
