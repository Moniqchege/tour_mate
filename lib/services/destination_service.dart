
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/destination.dart';

class DestinationService {
  static const String baseUrl = 'https://your-api.com/api';

  // Fetch most visited destinations
  static Future<List<Destination>> fetchPopularDestinations() async {
    final response = await http.get(Uri.parse('$baseUrl/popular'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((item) => Destination.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load destinations');
    }
  }

  // Fetch by country
  static Future<List<Destination>> searchDestinations(String country) async {
    final response = await http.get(Uri.parse('$baseUrl/destinations?country=$country'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data as List).map((item) => Destination.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load destinations by country');
    }
  }
}
