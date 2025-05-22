import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tour_mate/models/destination.dart';
import 'package:tour_mate/services/firebase_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DestinationDetailScreen extends StatelessWidget {
  final Destination destination;

  const DestinationDetailScreen({Key? key, required this.destination}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination.name, style: const TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF2ECC71),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: destination.imageUrl,
              height: 200,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(destination.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  Text('${destination.city}, ${destination.country}'),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.yellow),
                      Text('${destination.rating}'),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.favorite_border, color: Color(0xFF2ECC71)),
                        onPressed: () async {
                          final userId = FirebaseService().auth.currentUser?.uid;
                          if (userId != null) {
                            await FirebaseService().addFavorite(userId, destination.id);
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(destination.description),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(
                          destination.latitude ?? 48.8566,
                          destination.longitude ?? 2.3522,
                        ),
                        zoom: 12,
                      ),
                      markers: {
                        Marker(
                          markerId: MarkerId(destination.id),
                          position: LatLng(
                            destination.latitude ?? 48.8566,
                            destination.longitude ?? 2.3522,
                          ),
                          infoWindow: InfoWindow(
                            title: destination.name,
                            snippet: 'Rating: ${destination.rating}',
                          ),
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