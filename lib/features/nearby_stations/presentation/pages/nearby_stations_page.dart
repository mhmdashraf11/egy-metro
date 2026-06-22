import 'package:flutter/material.dart';

class NearbyStationsPage extends StatelessWidget {
  const NearbyStationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Stations')),
      body: const Center(child: Text('Nearby Stations Page')),
    );
  }
}
