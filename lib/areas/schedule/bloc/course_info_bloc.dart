import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fb4_app/areas/schedule/models/course_info.dart';
import 'package:fb4_app/areas/schedule/repositories/course_info_repository.dart';

part 'course_info_event.dart';
part 'course_info_state.dart';

class CourseInfoBloc extends Bloc<CourseInfoEvent, CourseInfoState> {
  final CourseInfoRepository repository;

  CourseInfoBloc({this.repository}) : super(CourseInfoInitial());

  @override
  Stream<CourseInfoState> mapEventToState(
    CourseInfoEvent event,
  ) async* {
    if (event is FetchCourseInfoEvent) {
      yield CourseInfoLoading();
      try {
        var courses = await CourseInfoRepository().getCourses();
        yield CourseInfoLoaded(courses: courses);
      } catch (e) {
        yield CourseInfoError(message: e.toString());
      }
    }
  }
}
