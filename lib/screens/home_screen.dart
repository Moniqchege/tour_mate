import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:tour_mate/services/api_service.dart';
import 'package:tour_mate/widgets/destination_card.dart';
import 'package:tour_mate/models/destination.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Destination> _destinations = [];
  String _searchQuery = '';
  bool _isLoading = false;

  // Optional: Suggestions for Autocomplete API (uncomment to enable)
  /*
  List<dynamic> _suggestions = [];
  Future<void> _fetchSuggestions(String input) async {
    if (input.isEmpty) {
      setState(() {
        _suggestions = [];
      });
      return;
    }
    final suggestions = await _apiService.getPlaceSuggestions(input, _searchQuery);
    setState(() {
      _suggestions = suggestions;
    });
  }
  */

  @override
  void initState() {
    super.initState();
    _fetchDestinations();
  }

  Future<void> _fetchDestinations() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data = await _apiService.getDestinations(_searchQuery.isEmpty ? 'Paris' : _searchQuery);
      final destinations = <Destination>[];
      for (var item in data) {
        final imageUrl = item['photo']?['images']?['small']?['url'] ?? 'https://via.placeholder.com/150';
        final coords = await _apiService.getPlaceCoordinates(
          item['name'] ?? 'Unknown',
          item['address_obj']?['city'] ?? _searchQuery,
        );
        destinations.add(Destination(
          id: item['location_id'] ?? item['id'] ?? 'unknown',
          name: item['name'] ?? 'Unknown Destination',
          city: item['address_obj']?['city'] ?? item['address_obj']?['address_string']?.split(',')?.last?.trim() ?? 'Unknown',
          country: item['address_obj']?['country'] ?? 'Unknown',
          description: item['description'] ?? 'A beautiful destination',
          rating: double.tryParse(item['rating'] ?? '4.5') ?? 4.5,
          imageUrl: imageUrl,
          hotels: [],
          restaurants: [],
          latitude: coords?['latitude'],
          longitude: coords?['longitude'],
        ));
      }
      setState(() {
        _destinations = destinations;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('$e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load destinations')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tour Mate', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2ECC71),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search by city or country',
                prefixIcon: Icon(Icons.search, color: Color(0xFF2ECC71)),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _fetchDestinations();
                // Uncomment to enable Autocomplete suggestions
                // _fetchSuggestions(value);
              },
            ),
          ),
          // Optional: Suggestions UI for Autocomplete API (uncomment to enable)
          /*
          if (_suggestions.isNotEmpty)
            Container(
              height: 100,
              child: ListView.builder(
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = _suggestions[index];
                  return ListTile(
                    title: Text(suggestion['displayName']?['text'] ?? 'Unknown'),
                    onTap: () {
                      setState(() {
                        _searchQuery = suggestion['displayName']?['text'] ?? _searchQuery;
                        _suggestions = [];
                      });
                      _fetchDestinations();
                    },
                  );
                },
              ),
            ),
          */
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _destinations.length,
              itemBuilder: (context, index) {
                return DestinationCard(destination: _destinations[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}