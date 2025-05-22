import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:tour_mate/services/api_service.dart';
import 'package:tour_mate/models/flight.dart';

class FlightsScreen extends StatefulWidget {
  const FlightsScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _FlightsScreenState createState() => _FlightsScreenState();
}

class _FlightsScreenState extends State<FlightsScreen> {
  final ApiService _apiService = ApiService();
  List<Flight> _flights = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchFlights();
  }

  Future<void> _fetchFlights() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data = await _apiService.getFlights('PAR', 'LON');
      setState(() {
        _flights = data.map((item) => Flight(
          id: item['id'],
          airline: item['itineraries'][0]['segments'][0]['carrierCode'],
          departure: item['itineraries'][0]['segments'][0]['departure']['iataCode'],
          destination: item['itineraries'][0]['segments'][0]['arrival']['iataCode'],
          departureTime: DateTime.now(),
          price: double.parse(item['price']['total']),
        )).toList();
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('$e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load flights')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flights', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2ECC71),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _flights.length,
        itemBuilder: (context, index) {
          final flight = _flights[index];
          return Card(
            child: ListTile(
              title: Text('${flight.departure} to ${flight.destination}'),
              subtitle: Text('Airline: ${flight.airline}, Price: \$${flight.price}'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2ECC71)),
                onPressed: () {},
                child: const Text('Book'),
              ),
            ),
          );
        },
      ),
    );
  }
}