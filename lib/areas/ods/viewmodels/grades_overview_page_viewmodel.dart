import 'package:fb4_app/areas/ods/models/exam_info_model.dart';
import 'package:fb4_app/areas/ods/repositories/ods_repository.dart';
import 'package:flutter/cupertino.dart';

class GradeOverviewPageViewModel extends ChangeNotifier {
  Map<int, List<ExamInfoModel>> exams;
  Function(String) onError;

  GradeOverviewPageViewModel({this.onError});

  getGradeList() async {
    if (exams == null) {
      exams = await OdsRepository.getExamInfos().catchError((error) {
        onError(error.toString());
      });
      notifyListeners();
    }
  }
}
