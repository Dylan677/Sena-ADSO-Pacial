import 'package:http/http.dart' as http;
import 'dart:convert';

class UserApiController {
  final String _baseUrl = 'http://localhost:3000/api_v1';

  Future<http.Response> login(String user, String password) async {
    final Uri uri = Uri.parse(_baseUrl + '/apiUserLogin');
    final http.Response response = await http.post(
      uri,
      headers: <String, String>{
        'Content-Type':
            'application/json; charset=UTF-8', // Add your token here
      },
      body: jsonEncode(<String, String>{
        'api_user': user,
        'api_password': password,
      }),
    );
    return response;
  }
}
