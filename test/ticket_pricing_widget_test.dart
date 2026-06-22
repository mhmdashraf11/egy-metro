import 'package:egy_metro/features/ticket_pricing/presentation/pages/ticket_pricing_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('TicketPricingPage renders correctly with 4 zones and estimator', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: TicketPricingPage(),
      ),
    );

    // Verify page title and header
    expect(find.text('Tickets & Fares'), findsOneWidget);
    expect(find.text('Zone Pricing'), findsOneWidget);
    expect(find.text('STANDARD FARES'), findsOneWidget);

    // Verify the presence of price points
    expect(find.text('10'), findsOneWidget); // Tier 1 price
    expect(find.text('12'), findsOneWidget); // Tier 2 price
    expect(find.text('15'), findsOneWidget); // Tier 3 price
    expect(find.text('20'), findsOneWidget); // Tier 4 price

    // Verify description/ranges
    expect(find.text('Up to 9 Stations'), findsOneWidget);
    expect(find.text('10 to 16 Stations'), findsOneWidget);
    expect(find.text('17 to 23 Stations'), findsOneWidget);
    expect(find.text('24 to 39 Stations'), findsOneWidget);

    // Verify presence of slider
    expect(find.byType(Slider), findsOneWidget);
  });
}
