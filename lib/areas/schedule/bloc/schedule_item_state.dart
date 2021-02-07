import 'package:equatable/equatable.dart';
import 'package:fb4_app/areas/schedule/models/schedule_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';

abstract class ScheduleItemState extends Equatable {
  @override
  List<Object> get props => [];
}

class ScheduleItemInitialState extends ScheduleItemState {}

class ScheduleItemsEmptyState extends ScheduleItemState {}

class ScheduleItemLoadingState extends ScheduleItemState {}

class ScheduleItemLoadedState extends ScheduleItemState {
  final List<ScheduleItem> scheduleItems;

  ScheduleItemLoadedState({@required this.scheduleItems});
}

class ScheduleItemErrorState extends ScheduleItemState {
  final String message;

  ScheduleItemErrorState({@required this.message});
}

class ScheduleItemsSelectedState extends ScheduleItemState {
  final List<ScheduleItem> selectedItems;

  ScheduleItemsSelectedState({this.selectedItems});
}
