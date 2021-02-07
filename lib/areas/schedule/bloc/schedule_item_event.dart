import 'package:equatable/equatable.dart';
import 'package:fb4_app/areas/schedule/models/schedule_item.dart';
import 'package:flutter/cupertino.dart';

class ScheduleItemsEvent extends Equatable {
  @override
  List<Object> get props => null;
}

class FetchScheduleItemsFromServerEvent extends ScheduleItemsEvent {
  final String courseId;
  final String semester;

  FetchScheduleItemsFromServerEvent(this.courseId, this.semester);
}

class FetchScheduleItemsFromLocalStorageEvent extends ScheduleItemsEvent {}

class SelectedScheduleItemsAddedEvent extends ScheduleItemsEvent {
  final ScheduleItem item;

  SelectedScheduleItemsAddedEvent({@required this.item});
}

class SelectedScheduleItemsRemovedEvent extends ScheduleItemsEvent {
  final ScheduleItem item;

  SelectedScheduleItemsRemovedEvent({@required this.item});
}
