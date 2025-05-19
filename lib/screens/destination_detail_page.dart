import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:tour_mate/models/destination.dart';

class DestinationDetailPage extends StatelessWidget {
  final Destination destination;

  const DestinationDetailPage({super.key, required this.destination});

  @override
  Widget build(BuildContext context) {
    final String mapsUrl =
        'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(destination.name)}';

    return Scaffold(
      appBar: AppBar(title: Text(destination.name)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              destination.imageUrl,
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
                    destination.name,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(destination.description),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.map),
                    label: const Text('View Nearby on Google Maps'),
                    onPressed: () async {
                      final Uri url = Uri.parse(mapsUrl);
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
    );
  }
}
