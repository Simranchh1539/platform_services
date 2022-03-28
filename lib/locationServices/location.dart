import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationService {
  final String key = 'AIzaSyDviGzU6wp3v3iXwh7pfJo_0mQJHBXPPh0';

  Future<String> getplaceId(String input) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=geocode&key=$key";

    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var placeid = json['predictions'] as List;
  }

  Future<Map<String, dynamic>> getplace(String placeId) async {
    final String url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key";
    var response = await http.get(Uri.parse(url));
    var json = convert.jsonDecode(response.body);
    var results = json['result'] as Map<String, dynamic>;
  }
}
