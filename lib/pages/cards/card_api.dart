import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class card_api {
  Future<String> fetchData(String front_word) async {
    print(front_word);
    String api_url = 'http://127.0.0.1:5000/?name=${front_word}';
    var url = Uri.parse(api_url);
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${jsonResponse}');
      return jsonResponse['response'];
    } else {
      print('Request status: ${response.statusCode}.');
      print('apiエラー');
      return '';
    }
  }
}
