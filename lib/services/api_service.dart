import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String _amadeusBaseUrl = 'https://test.api.amadeus.com/v1';
  static const String _amadeusApiKey = '9SpiQNBUAeSa01JYVArZcGSGfa61UOUG';
  static const String _amadeusApiSecret = 'xirsymcWKcWdIx7o';
  static const String _travelAdvisorBaseUrl = 'https://travel-advisor.p.rapidapi.com';
  static const String _rapidApiKey = '43ffd2491dmsh415142f0db4aec1p1b9cefjsnb883494b853c'; // Replace with your Travel Advisor RapidAPI key
  static const String _rapidApiHost = 'travel-advisor.p.rapidapi.com';
  static const String _googleMapsBaseUrl = 'https://google-api31.p.rapidapi.com/map';
  static const String _googleMapsRapidApiKey = '43ffd2491dmsh415142f0db4aec1p1b9cefjsnb883494b853c';
  static const String _googleMapsRapidApiHost = 'google-api31.p.rapidapi.com';
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

  Future<Map<String, dynamic>?> getPlaceCoordinates(String name, String city) async {
    try {
      final response = await http.post(
        Uri.parse(_googleMapsBaseUrl),
        headers: {
          'Content-Type': 'application/json',
          'X-RapidAPI-Key': _googleMapsRapidApiKey,
          'X-RapidAPI-Host': _googleMapsRapidApiHost,
        },
        body: jsonEncode({
          'text': name,
          'place': city,
          'street': '',
          'city': '',
          'country': '',
          'state': '',
          'postalcode': '',
          'latitude': '',
          'longitude': '',
          'radius': '',
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'latitude': double.tryParse(data['latitude']?.toString() ?? ''),
          'longitude': double.tryParse(data['longitude']?.toString() ?? ''),
        };
      }
      return null;
    } catch (e) {
      debugPrint('Failed to fetch coordinates: $e');
      return null;
    }
  }

// Optional: Autocomplete API (uncomment to enable)
/*
  Future<List<dynamic>> getPlaceSuggestions(String input, String city) async {
    try {
      final response = await http.post(
        Uri.parse('https://google-map-places-new-v2.p.rapidapi.com/v1/places:autocomplete'),
        headers: {
          'Content-Type': 'application/json',
          'X-Goog-FieldMask': '*',
          'X-RapidAPI-Key': _googleMapsRapidApiKey,
          'X-RapidAPI-Host': 'google-map-places-new-v2.p.rapidapi.com',
        },
        body: jsonEncode({
          'input': input,
          'locationBias': {
            'circle': {
              'center': {'latitude': 0, 'longitude': 0}, // Update with city coordinates if known
              'radius': 10000,
            },
          },
          'includedPrimaryTypes': [],
          'includedRegionCodes': [],
          'languageCode': '',
          'regionCode': '',
          'origin': {'latitude': 0, 'longitude': 0},
          'inputOffset': 0,
          'includeQueryPredictions': true,
          'sessionToken': '', // Generate unique sessionToken per session
        }),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body)['suggestions'] ?? [];
      }
      return [];
    } catch (e) {
      debugPrint('Failed to fetch place suggestions: $e');
      return [];
    }
  }
  */

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