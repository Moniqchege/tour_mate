class Destination {
  final String id;
  final String name;
  final String city;
  final String country;
  final String description;
  final double rating;
  final String imageUrl;
  final List<String> hotels;
  final List<String> restaurants;

  Destination({
    required this.id,
    required this.name,
    required this.city,
    required this.country,
    required this.description,
    required this.rating,
    required this.imageUrl,
    required this.hotels,
    required this.restaurants,
  });
}