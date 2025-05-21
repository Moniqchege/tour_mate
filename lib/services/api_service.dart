import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _amadeusBaseUrl = 'https://test.api.amadeus.com/v1';
  static const String _amadeusApiKey = '9SpiQNBUAeSa01JYVArZcGSGfa61UOUG';
  static const String _amadeusApiSecret = 'xirsymcWKcWdIx7o';
  static const String _travelAdvisorBaseUrl = 'https://travel-advisor.p.rapidapi.com';
  static const String _rapidApiKey = '43ffd2491dmsh415142f0db4aec1p1b9cefjsnb883494b853c'; // Replace with your RapidAPI key
  static const String _rapidApiHost = 'travel-advisor.p.rapidapi.com';
  static const String _googlePlacesApiKey = 'YOUR_GOOGLE_API_KEY'; // Replace with your Google API key
  static String? _amadeusAccessToken;

  Future<String> _getAmadeusAccessToken() async {
    if (_amadeusAccessToken != null) return _amadeusAccessToken!;
    final response = await http.post(
      Uri.parse('https://test.api.amadeus.com/v1/security/oauth2/token'),
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body:
      'grant_type=client_credentials&client_id=$_amadeusApiKey&client_secret=$_amadeusApiSecret',
    );
    if (response.statusCode == 200) {
      _amadeusAccessToken = jsonDecode(response.body)['access_token'];
      return _amadeusAccessToken!;
    }
    throw Exception('Failed to get Amadeus access token');
  }

  Future<List<dynamic>> getDestinations(String query) async {
    final response = await http.get(
      Uri.parse('$_travelAdvisorBaseUrl/locations/search?query=$query&limit=10'),
      headers: {
        'X-RapidAPI-Key': _rapidApiKey,
        'X-RapidAPI-Host': _rapidApiHost,
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    }
    throw Exception('Failed to fetch destinations from Travel Advisor');
  }

  Future<String?> getPlacePhoto(String placeName) async {
    final response = await http.get(
      Uri.parse('https://maps.googleapis.com/maps/api/place/findplacefromtext/json?input=$placeName&inputtype=textquery&fields=photos&key=$_googlePlacesApiKey'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final photoReference = data['candidates']?[0]?['photos']?[0]?['photo_reference'];
      if (photoReference != null) {
        return 'https://maps.googleapis.com/maps/api/place/photo?maxwidth=400&photoreference=$photoReference&key=$_googlePlacesApiKey';
      }
    }
    return null;
  }

  Future<List<dynamic>> getFlights(String origin, String destination) async {
    final token = await _getAmadeusAccessToken();
    final response = await http.get(
      Uri.parse(
          '$_amadeusBaseUrl/shopping/flight-offers?originLocationCode=$origin&destinationLocationCode=$destination'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    }
    throw Exception('Failed to fetch flights');
  }

  Future<List<dynamic>> getHotels(String cityCode) async {
    final token = await _getAmadeusAccessToken();
    final response = await http.get(
      Uri.parse('$_amadeusBaseUrl/shopping/hotel-offers?cityCode=$cityCode'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['data'];
    }
    throw Exception('Failed to fetch hotels');
  }
}