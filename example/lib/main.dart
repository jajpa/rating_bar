import 'package:flutter/material.dart';
import 'package:rating_bar/rating_bar.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rating Bar Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const RatingBarDemo(),
    );
  }
}

class RatingBarDemo extends StatefulWidget {
  const RatingBarDemo({super.key});

  @override
  State<RatingBarDemo> createState() => _RatingBarDemoState();
}

class _RatingBarDemoState extends State<RatingBarDemo> {
  double _rating1 = 2.5;
  double _rating2 = 3.0;
  double _rating3 = 4.2;
  double _rating4 = 1.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rating Bar Demo')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '1. Simple Icon (Half Allowed)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            RatingBar(
              initialRating: _rating1,
              isHalfAllowed: true,
              filledIcon: Icons.star,
              emptyIcon: Icons.star_border,
              halfFilledIcon: Icons.star_half,
              filledColor: Colors.amber,
              onRatingChanged: (rating) {
                setState(() {
                  _rating1 = rating;
                });
              },
            ),
            Text(
              'Rating: $_rating1',
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 32),

            const Text(
              '2. Custom Widgets',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            RatingBar.custom(
              initialRating: _rating2,
              filledWidget: const Icon(
                Icons.favorite,
                color: Colors.red,
                size: 40,
              ),
              emptyWidget: const Icon(
                Icons.favorite_border,
                color: Colors.grey,
                size: 40,
              ),
              onRatingChanged: (rating) {
                setState(() {
                  _rating2 = rating;
                });
              },
            ),
            Text(
              'Rating: $_rating2',
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 32),

            const Text(
              '3. Precise Fractional (4.2 stars)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            RatingBar.custom(
              initialRating: _rating3,
              allowFractionalRating: true,
              filledWidget: const Icon(
                Icons.star,
                color: Colors.amber,
                size: 50,
              ),
              emptyWidget: const Icon(
                Icons.star_border,
                color: Colors.grey,
                size: 50,
              ),
              onRatingChanged: (rating) {
                setState(() {
                  _rating3 = rating;
                });
              },
            ),
            Text(
              'Rating: ${_rating3.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.grey),
            ),
            const Divider(height: 32),

            const Text(
              '4. Builder with Emoticons',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            RatingBar.builder(
              initialRating: _rating4,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, index) {
                IconData icon;
                Color color;
                switch (index) {
                  case 0:
                    icon = Icons.sentiment_very_dissatisfied;
                    color = Colors.red;
                    break;
                  case 1:
                    icon = Icons.sentiment_dissatisfied;
                    color = Colors.redAccent;
                    break;
                  case 2:
                    icon = Icons.sentiment_neutral;
                    color = Colors.amber;
                    break;
                  case 3:
                    icon = Icons.sentiment_satisfied;
                    color = Colors.lightGreen;
                    break;
                  case 4:
                  default:
                    icon = Icons.sentiment_very_satisfied;
                    color = Colors.green;
                    break;
                }
                return RatingWidget(
                  full: Icon(icon, color: color, size: 40),
                  empty: Icon(icon, color: Colors.grey.shade300, size: 40),
                );
              },
              onRatingChanged: (rating) {
                setState(() {
                  _rating4 = rating;
                });
              },
            ),
            Text(
              'Rating: $_rating4',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
