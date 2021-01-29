import 'package:fb4_app/areas/schedule/bloc/schedule_item_event.dart';
import 'package:fb4_app/areas/schedule/bloc/schedule_item_state.dart';
import 'package:fb4_app/areas/schedule/models/schedule_item.dart';
import 'package:fb4_app/areas/schedule/repositories/schedule_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleItemBloc
    extends Bloc<FetchScheduleItemsEvent, ScheduleItemState> {
  final ScheduleRepository repository;

  ScheduleItemBloc({@required this.repository})
      : super(ScheduleItemInitialState());

  @override
  Stream<ScheduleItemState> mapEventToState(
      FetchScheduleItemsEvent event) async* {
    if (event is FetchScheduleItemsEvent) {
      yield ScheduleItemLoadingState();
      try {
        List<ScheduleItem> scheduleItems = await repository.getScheduleItems();
        yield ScheduleItemLoadedState(scheduleItems: scheduleItems);
      } catch (e) {
        yield ScheduleItemErrorState(message: e.toString());
      }
    }
  }
}
