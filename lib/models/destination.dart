import 'package:flutter/material.dart';
import 'dart:math';

class Destination {
  final String id;
  final String name;
  final String description;
  final String country;
  final String imageUrl;
  final double cost;
  final double rating;

  Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.country,
    required this.imageUrl,
    required this.cost,
    required this.rating,
  });

  factory Destination.fromGeoapify(Map<String, dynamic> json) {
    return Destination(
      id: json['properties']['place_id']?.toString() ?? UniqueKey().toString(),
      name: json['properties']['name'] ?? 'Unknown Attraction',
      description: json['properties']['formatted'] ?? 'No description available',
      country: json['properties']['country'] ?? 'Unknown',
      imageUrl: 'https://source.unsplash.com/400x300/?${json['properties']['name']?.replaceAll(' ', '+') ?? 'travel'}',
      cost: (Random().nextDouble() * 4900) + 100,
      rating: (Random().nextDouble() * 4) + 1,
    );
  }
}