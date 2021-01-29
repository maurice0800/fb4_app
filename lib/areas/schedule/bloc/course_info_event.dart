part of 'course_info_bloc.dart';

abstract class CourseInfoEvent extends Equatable {
  const CourseInfoEvent();

  @override
  List<Object> get props => [];
}

class FetchCourseInfoEvent extends CourseInfoEvent {}
