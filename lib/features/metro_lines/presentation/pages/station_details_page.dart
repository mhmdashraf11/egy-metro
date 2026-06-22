import 'package:flutter/material.dart';

class StationDetailsPage extends StatelessWidget {
  final int stationId;
  const StationDetailsPage({super.key, required this.stationId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Station $stationId')),
      body: Center(child: Text('Station Details for $stationId')),
    );
  }
}
