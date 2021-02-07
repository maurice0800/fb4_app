import 'package:fb4_app/areas/schedule/bloc/schedule_item_event.dart';
import 'package:fb4_app/areas/schedule/bloc/schedule_item_state.dart';
import 'package:fb4_app/areas/schedule/models/schedule_item.dart';
import 'package:fb4_app/areas/schedule/repositories/schedule_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_store/json_store.dart';

class ScheduleItemBloc extends Bloc<ScheduleItemsEvent, ScheduleItemState> {
  final ScheduleRepository repository;
  final JsonStore jsonStore = JsonStore();

  ScheduleItemBloc({@required this.repository})
      : super(ScheduleItemInitialState());

  @override
  Stream<ScheduleItemState> mapEventToState(ScheduleItemsEvent event) async* {
    if (event is FetchScheduleItemsFromServerEvent) {
      yield ScheduleItemLoadingState();
      try {
        List<ScheduleItem> scheduleItems =
            await repository.getScheduleItems(event.courseId, event.semester);
        yield ScheduleItemLoadedState(scheduleItems: scheduleItems);
      } catch (e) {
        yield ScheduleItemErrorState(message: e.toString());
      }
    }

    if (event is FetchScheduleItemsFromLocalStorageEvent) {
      yield ScheduleItemLoadingState();
      try {
        var itemsList = await jsonStore.getItem("schedule_items");

        if (itemsList == null) {
          yield ScheduleItemsEmptyState();
        } else {
          var scheduleItems = itemsList.values
              .map<ScheduleItem>((item) => ScheduleItem.fromJson(item))
              .toList();
          yield ScheduleItemLoadedState(scheduleItems: scheduleItems);
        }
      } catch (e) {
        yield ScheduleItemErrorState(message: e.toString());
      }
    }
  }
}
