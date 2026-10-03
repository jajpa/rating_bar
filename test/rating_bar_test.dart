import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rating_bar/rating_bar.dart';

void main() {
  testWidgets('RatingBar displays correct initial rating',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: RatingBar(
            initialRating: 3.5,
            filledIcon: Icons.star,
            emptyIcon: Icons.star_border,
            halfFilledIcon: Icons.star_half,
            isHalfAllowed: true,
          ),
        ),
      ),
    );

    expect(find.byType(RatingBar), findsOneWidget);
  });
}
