import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart'; // For debugPrint
import '../models/destination.dart';

class DestinationService {
  static const String _baseUrl = 'https://api.geoapify.com/v2/places';
  static const String _apiKey = '150e2895138e44a39021b4c15a77bae7'; // Replace with your Geoapify API key

  // Fetch popular destinations (global tourist attractions)
  static Future<List<Destination>> fetchPopularDestinations() async {
    final uri = Uri.parse('$_baseUrl?categories=tourism&limit=10&apiKey=$_apiKey');
    try {
      final response = await http.get(uri);
      if (kDebugMode) {
        debugPrint('Fetch Popular Destinations URL: $uri');
        debugPrint('Response Status: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> results = data['features'] ?? [];

        return results.map((item) {
          try {
            return Destination.fromGeoapify(item);
          } catch (e) {
            if (kDebugMode) debugPrint('Error parsing destination: $e');
            return null;
          }
        }).whereType<Destination>().toList();
      } else {
        throw Exception('Failed to load destinations: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Fetch Popular Destinations Error: $e');
      throw Exception('Failed to load destinations: $e');
    }
  }

  // Search destinations by country name (e.g., "Kenya")
  static Future<List<Destination>> searchDestinations(String country) async {
    final uri = Uri.parse('$_baseUrl?categories=tourism&filter=place:$country&limit=10&apiKey=$_apiKey');
    try {
      final response = await http.get(uri);
      if (kDebugMode) {
        debugPrint('Search Destinations URL: $uri');
        debugPrint('Response Status: ${response.statusCode}');
        debugPrint('Response Body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> results = data['features'] ?? [];

        return results.map((item) {
          try {
            return Destination.fromGeoapify(item);
          } catch (e) {
            if (kDebugMode) debugPrint('Error parsing destination: $e');
            return null;
          }
        }).whereType<Destination>().toList();
      } else {
        throw Exception('Failed to load destinations by country: ${response.statusCode} - ${response.reasonPhrase}');
      }
    } catch (e) {
      if (kDebugMode) debugPrint('Search Destinations Error: $e');
      throw Exception('Failed to load destinations by country: $e');
    }
  }
}