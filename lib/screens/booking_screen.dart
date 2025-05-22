import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:tour_mate/services/api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _hotels = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchHotels();
  }

  Future<void> _fetchHotels() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data = await _apiService.getHotels('PAR');
      setState(() {
        _hotels = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint('$e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load hotels')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Now', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2ECC71),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: _hotels.length,
        itemBuilder: (context, index) {
          final hotel = _hotels[index];
          return Card(
            child: ListTile(
              leading: SizedBox(
                width: 40,
                height: 40,
                child: CachedNetworkImage(
                  imageUrl: hotel['media']?[0]?['uri'] ?? 'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
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
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2ECC71)),
                  onPressed: () {},
                  child: const Text('Book'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}