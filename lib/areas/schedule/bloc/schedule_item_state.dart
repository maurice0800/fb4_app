import 'package:equatable/equatable.dart';
import 'package:fb4_app/areas/schedule/models/schedule_item.dart';
import 'package:flutter/cupertino.dart';

abstract class ScheduleItemState extends Equatable {}

class ScheduleItemInitialState extends ScheduleItemState {
  @override
  List<Object> get props => [];
}

class ScheduleItemLoadingState extends ScheduleItemState {
  @override
  List<Object> get props => [];
}

class ScheduleItemLoadedState extends ScheduleItemState {
  final List<ScheduleItem> scheduleItems;

  ScheduleItemLoadedState({@required this.scheduleItems});

  @override
  List<Object> get props => [scheduleItems];
}

class ScheduleItemErrorState extends ScheduleItemState {
  final String message;

  ScheduleItemErrorState({@required this.message});

  @override
  List<Object> get props => throw UnimplementedError();
}
