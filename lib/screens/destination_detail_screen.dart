import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_mate/models/destination.dart';
import 'package:tour_mate/services/firebase_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DestinationDetailScreen extends StatelessWidget {
  final Destination destination;

  DestinationDetailScreen({required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.name, style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF2ECC71),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: destination.imageUrl,
              height: 200,
              fit: BoxFit.cover,
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(destination.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('${destination.city}, ${destination.country}'),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow),
                      Text('${destination.rating}'),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.favorite_border, color: Color(0xFF2ECC71)),
                        onPressed: () async {
                          final userId = FirebaseService().auth.currentUser?.uid;
                          if (userId != null) {
                            await FirebaseService().addFavorite(userId, destination.id);
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(destination.description),
                  SizedBox(height: 16),
                  Container(
                    height: 300,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(48.8566, 2.3522),
                        zoom: 12,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId('hotel1'),
                          position: LatLng(48.8566, 2.3522),
                          infoWindow: InfoWindow(title: 'Sample Hotel', snippet: 'Rating: 4.2'),
                        ),
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}