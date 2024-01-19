import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class card_api {
  Future<String> fetchData() async {
    var url = Uri.parse('http://127.0.0.1:5000/');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${jsonResponse}');
      return jsonResponse['response'];
    } else {
      print('Request status: ${response.statusCode}.');
      return '';
    }
  }
}
