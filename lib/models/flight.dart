class Flight {
  final String id;
  final String airline;
  final String departure;
  final String destination;
  final DateTime departureTime;
  final double price;

  Flight({
    required this.id,
    required this.airline,
    required this.departure,
    required this.destination,
    required this.departureTime,
    required this.price,
  });
}