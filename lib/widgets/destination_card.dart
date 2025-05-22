import 'package:flutter/material.dart';
import 'package:tour_mate/models/destination.dart';
import 'package:tour_mate/screens/destination_detail_screen.dart';
import 'package:tour_mate/services/firebase_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DestinationCard extends StatelessWidget {
  final Destination destination;

  const DestinationCard({Key? key, required this.destination}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: ModalRoute.of(context)!.animation!,
          curve: Curves.easeIn,
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: SizedBox(
            width: 40,
            height: 40,
            child: CachedNetworkImage(
              imageUrl: destination.imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          title: Text(destination.name),
          subtitle: Text('${destination.city}, ${destination.country}\nRating: ${destination.rating}'),
          trailing: IconButton(
            icon: const Icon(Icons.favorite_border, color: Color(0xFF2ECC71)),
            onPressed: () async {
              final userId = FirebaseService().auth.currentUser?.uid;
              if (userId != null) {
                await FirebaseService().addFavorite(userId, destination.id);
              }
            },
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DestinationDetailScreen(destination: destination),
              ),
            );
          },
        ),
      ),
    );
  }
}