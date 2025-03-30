import 'dart:convert';
import 'package:http/http.dart' as http;

String apiKey = '78d610912201dbba865d28005cff3240';

Future getWeather(String city, String country) async {
  String url =
      'https://api.openweathermap.org/data/2.5/weather?q=$city,$country&APPID=$apiKey';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    print(response.body);

    return jsonDecode(response.body); // Return the response
  }
}

Future getForecast(String city, String country) async {
  String url =
      'https://api.openweathermap.org/data/2.5/forecast?q=$city,$country&APPID=$apiKey';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    print(response.body);

    return jsonDecode(response.body); // Return the response
  }
}

Future getCitySuggestions(String query) async {
  String url = 'http://api.openweathermap.org/geo/1.0/direct?q=$query&limit=5&appid=$apiKey';
    final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    print(response.body);

    return jsonDecode(response.body); // Return the response
  }
}

// void main() async {
//   await getWeather(Varanasi);
// }
