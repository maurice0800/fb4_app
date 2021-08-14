import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

class OdsAuthenticationService {
  static Future<String> getAuthToken(String username, String password) async {
    final loginResult =
        await http.post(Uri.parse('https://ods.fh-dortmund.de/ods'), body: {
      'LIMod': '',
      'HttpRequest_PathFile': '/',
      'HttpRequest_Path': '/',
      'RemoteEndPointIP': '10.11.15.121',
      'User': username,
      'PWD': password,
      'x': '0',
      'y': '0',
    });

    final htmlLoginResult = parse(loginResult.body);
    final metaTags = htmlLoginResult.getElementsByTagName('meta');

    for (final element in metaTags) {
      if (element.attributes.containsKey('content')) {
        if (element.attributes['content']!.contains('URL')) {
          final contentString = element.attributes['content'];
          return contentString!.substring(contentString.indexOf('SIDD=') + 5);
        }
      }
    }

    return Future.error("Could not retrieve auth token");
  }
}
