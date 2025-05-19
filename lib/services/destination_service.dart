import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/destination.dart';

class DestinationService {
  static const String _baseUrl = 'https://travel-advisor.p.rapidapi.com';
  static const Map<String, String> _headers = {
    'X-RapidAPI-Key': 'a5340691dbmsh2b389fb17eaa4efp103945jsndc8f2ed18ace',
    'X-RapidAPI-Host': 'travel-advisor.p.rapidapi.com',
  };

  // Fetch popular destinations (example: search "destinations" like Nairobi)
  static Future<List<Destination>> fetchPopularDestinations() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/locations/search?query=popular&limit=10'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['data'] ?? [];
      return results
          .map((item) => Destination.fromTravelAdvisor(item))
          .where((d) => d != null)
          .cast<Destination>()
          .toList();
    } else {
      throw Exception('Failed to load destinations');
    }
  }

  // Fetch destinations filtered by country name (e.g. "Kenya")
  static Future<List<Destination>> searchDestinations(String country) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/locations/search?query=$country&limit=10'),
      headers: _headers,
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['data'] ?? [];
      return results
          .map((item) {
        try {
          return Destination.fromTravelAdvisor(item);
        } catch (_) {
          return null;
        }
      })
          .whereType<Destination>()
          .toList();
    } else {
      throw Exception('Failed to load destinations by country');
    }
  }
}
