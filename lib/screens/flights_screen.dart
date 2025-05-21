import 'package:flutter/material.dart';
import 'package:tour_mate/services/api_service.dart';
import 'package:tour_mate/models/flight.dart';

class FlightsScreen extends StatefulWidget {
  @override
  _FlightsScreenState createState() => _FlightsScreenState();
}

class _FlightsScreenState extends State<FlightsScreen> {
  final ApiService _apiService = ApiService();
  List<Flight> _flights = [];

  @override
  void initState() {
    super.initState();
    _fetchFlights();
  }

  Future<void> _fetchFlights() async {
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
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flights', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2ECC71),
      ),
      body: ListView.builder(
        itemCount: _flights.length,
        itemBuilder: (context, index) {
          final flight = _flights[index];
          return Card(
            child: ListTile(
              title: Text('${flight.departure} to ${flight.destination}'),
              subtitle: Text('Airline: ${flight.airline}, Price: \$${flight.price}'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2ECC71)),
                onPressed: () {},
                child: Text('Book'),
              ),
            ),
          );
        },
      ),
    );
  }
}