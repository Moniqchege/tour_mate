import 'package:flutter/material.dart';
import 'package:tour_mate/services/api_service.dart';
import 'package:tour_mate/widgets/destination_card.dart';
import 'package:tour_mate/models/destination.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Destination> _destinations = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchDestinations();
  }

  Future<void> _fetchDestinations() async {
    try {
      final data = await _apiService.getDestinations(_searchQuery.isEmpty ? 'Paris' : _searchQuery);
      final destinations = <Destination>[];
      for (var item in data) {
        final imageUrl = item['photo']?['images']?['small']?['url'] ??
            await _apiService.getPlacePhoto(item['name']) ??
            'https://via.placeholder.com/150';
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
        ));
      }
      setState(() {
        _destinations = destinations;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tour Mate', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2ECC71),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by city or country',
                prefixIcon: Icon(Icons.search, color: Color(0xFF2ECC71)),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
                _fetchDestinations();
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
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