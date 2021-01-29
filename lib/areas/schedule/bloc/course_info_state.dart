part of 'course_info_bloc.dart';

abstract class CourseInfoState extends Equatable {
  const CourseInfoState();

  @override
  List<Object> get props => [];
}

class CourseInfoInitial extends CourseInfoState {}

class CourseInfoLoading extends CourseInfoState {}

class CourseInfoLoaded extends CourseInfoState {
  final List<CourseInfo> courses;

  CourseInfoLoaded({this.courses});
}

class CourseInfoError extends CourseInfoState {
  final String message;

  CourseInfoError({this.message});
}
