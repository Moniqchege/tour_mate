import 'package:flutter/material.dart';
import 'package:tour_mate/services/api_service.dart';
import 'package:tour_mate/models/booking.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _hotels = [];

  @override
  void initState() {
    super.initState();
    _fetchHotels();
  }

  Future<void> _fetchHotels() async {
    try {
      final data = await _apiService.getHotels('PAR');
      setState(() {
        _hotels = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Now', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2ECC71),
      ),
      body: ListView.builder(
        itemCount: _hotels.length,
        itemBuilder: (context, index) {
          final hotel = _hotels[index];
          return Card(
            child: ListTile(
              title: Text(hotel['hotel']['name'] ?? 'Unknown Hotel'),
              subtitle: Text('Price: ${hotel['offers'][0]['price']['total']}'),
              trailing: ScaleTransition(
                scale: Tween(begin: 0.8, end: 1.0).animate(
                  CurvedAnimation(
                    parent: ModalRoute.of(context)!.animation!,
                    curve: Curves.easeInOut,
                  ),
                ),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2ECC71)),
                  onPressed: () {},
                  child: Text('Book'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}