import 'package:fb4_app/areas/ods/models/exam_info_model.dart';
import 'package:fb4_app/areas/ods/services/ods_authentication_service.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class OdsRepository {
  static String cachedToken;
  static FlutterSecureStorage secureStorage = FlutterSecureStorage();

  static Future<Map<int, List<ExamInfoModel>>> getExamInfos(
      {bool firstTry = true}) async {
    if (cachedToken == null) {
      var username = await secureStorage.read(key: 'odsUsername');
      var password = await secureStorage.read(key: 'odsPassword');

      cachedToken =
          await OdsAuthenticationService.getAuthToken(username, password);
    }

    var result = await http
        .get('https://ods.fh-dortmund.de/ods?Sicht=DSTL&SIDD=$cachedToken');

    var resultHtml = parse(result.body);
    var resultMap = Map<int, List<ExamInfoModel>>();

    try {
      for (var examRow in resultHtml
          .getElementsByTagName('table')
          .where((e) => e.className == 'maintable')
          .first
          .children[0]
          .children
          .skip(1)) {
        var payload = examRow.getElementsByTagName('td');

        // Skip iteration when current row is a sub heading
        if (payload.first.attributes.containsKey('colspan')) {
          continue;
        }

        // Skip iteration when no grade is available
        if (payload[8].text == "") {
          continue;
        }

        var result = ExamInfoModel(
          name: payload[0].text.trim(),
          examKind: payload[5].text.trim(),
          tryCount: payload[4].text.trim(),
          grade: payload[8].text.trim(),
          ects: payload[2].text.trim(),
          status: payload[3].text.trim(),
          additional: payload[7].text.trim(),
        );

        resultMap.putIfAbsent(
            int.parse(payload[1].text.trim()), () => <ExamInfoModel>[]);

        resultMap[int.parse(payload[1].text.trim())].add(result);
      }
      return resultMap;
    } catch (e) {
      if (firstTry) {
        cachedToken = null;
        return getExamInfos(firstTry: false);
      } else {
        return Future.error(
            "Konnte keine Verbindung mit ODS herstellen. Sind die Anmeldedaten korrekt?");
      }
    }
  }
}
