
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

  factory Destination.fromTravelAdvisor(Map<String, dynamic> json) {
    if (json['result_type'] != 'geos') {
      throw FormatException('Unsupported result type: ${json['result_type']}');
    }

    final result = json['result_object'];

    return Destination(
      id: result['location_id'] ?? '',
      name: result['name'] ?? '',
      country: result['address_obj']?['country'] ?? '',
      description: result['location_string'] ?? '',
      imageUrl: result['photo']?['images']?['large']?['url'] ??
          'https://source.unsplash.com/400x300/?travel',
      cost: 1000, // Placeholder
      rating: double.tryParse(result['rating'] ?? '4.0') ?? 4.0,
    );
  }

}
