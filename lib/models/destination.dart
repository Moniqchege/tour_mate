
class Destination {
  final String id;
  final String name;
  final String description;
  final String country;
  final String imageUrl;
  final double cost;

  Destination({
    required this.id,
    required this.name,
    required this.description,
    required this.country,
    required this.imageUrl,
    required this.cost,
  });

  factory Destination.fromJson(Map<String, dynamic> json) {
    return Destination(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      country: json['country'],
      imageUrl: json['imageUrl'],
      cost: json['cost'].toDouble(),
    );
  }
}
