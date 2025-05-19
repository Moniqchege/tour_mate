import 'package:flutter/material.dart';
import 'package:tour_mate/models/destination.dart';
import 'package:url_launcher/url_launcher.dart';

class DestinationDetailPage extends StatefulWidget {
  final Destination destination;

  const DestinationDetailPage({required this.destination, super.key});

  @override
  State<DestinationDetailPage> createState() => _DestinationDetailPageState();
}

class _DestinationDetailPageState extends State<DestinationDetailPage> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final mapsUrl = 'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(widget.destination.name)}';

    return Scaffold(
      appBar: AppBar(title: Text(widget.destination.name)),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  widget.destination.imageUrl,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.destination.name,
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Text(widget.destination.description),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Text("Reviews: ", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          buildStarRating(widget.destination.rating),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.map),
                        label: const Text('View Nearby on Google Maps'),
                        onPressed: () async {
                          final url = Uri.parse(mapsUrl);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url);
                          } else {
                            throw 'Could not launch $mapsUrl';
                          }
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: () {
                setState(() => isFavorite = !isFavorite);
              },
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildStarRating(double rating) {
    int fullStars = rating.floor();
    bool halfStar = (rating - fullStars) >= 0.5;
    return Row(
      children: List.generate(5, (index) {
        if (index < fullStars) {
          return const Icon(Icons.star, color: Colors.amber, size: 20);
        } else if (index == fullStars && halfStar) {
          return const Icon(Icons.star_half, color: Colors.amber, size: 20);
        } else {
          return const Icon(Icons.star_border, color: Colors.amber, size: 20);
        }
      }),
    );
  }
}
