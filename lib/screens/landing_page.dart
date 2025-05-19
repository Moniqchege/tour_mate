import 'package:flutter/material.dart';
import 'package:tour_mate/widgets/destination_card.dart';
import 'package:tour_mate/services/destination_service.dart';
import 'package:tour_mate/models/destination.dart';
import 'package:tour_mate/screens/destination_detail_page.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> with SingleTickerProviderStateMixin {
  List<Destination> destinations = [];
  bool isLoading = true;
  String country = '';
  double? maxCost;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    fetchDestinations();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchDestinations({String? country, double? maxCost}) async {
    setState(() => isLoading = true);

    try {
      final results = await DestinationService.fetchPopularDestinations();
      List<Destination> filtered = results;

      if (country != null && country.isNotEmpty) {
        filtered = filtered.where((d) => d.country.toLowerCase().contains(country.toLowerCase())).toList();
      }

      if (maxCost != null) {
        filtered = filtered.where((d) => d.cost <= maxCost).toList();
      }

      setState(() {
        destinations = filtered;
        isLoading = false;
      });
      _controller.forward();
    } catch (e) {
      print('Error: $e');
      setState(() => isLoading = false);
    }
  }

  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search by country',
              prefixIcon: Icon(Icons.search),
            ),
            onSubmitted: (value) {
              setState(() => country = value);
              fetchDestinations(country: value, maxCost: maxCost);
            },
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text("Max Cost: \$${maxCost?.toStringAsFixed(0) ?? 'Any'}"),
              Expanded(
                child: Slider(
                  value: maxCost ?? 1000,
                  min: 100,
                  max: 5000,
                  divisions: 50,
                  label: maxCost?.toStringAsFixed(0) ?? 'Any',
                  onChanged: (value) {
                    setState(() => maxCost = value);
                    fetchDestinations(country: country, maxCost: value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Most Visited Places')),
      body: Column(
        children: [
          buildSearchBar(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: destinations.length,
              itemBuilder: (context, index) => FadeTransition(
                opacity: _fadeAnimation,
                child: DestinationCard(
                  destination: destinations[index],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DestinationDetailPage(
                          destination: destinations[index],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
