library rating_bar;

import 'package:flutter/material.dart';

typedef void RatingCallback(double rating);

class RatingBar extends StatefulWidget {
  RatingBar({
    Key key,
    this.starCount = 5,
    @required this.onRatingChanged,
    this.initialRating = 0.0,
    this.color,
    this.borderColor,
    this.size = 24,
    this.isHalfAllowed = false,
  })  : assert(onRatingChanged != null),
        super(key: key);

  final int starCount;
  final RatingCallback onRatingChanged;
  final double initialRating;
  final Color color;
  final Color borderColor;
  final double size;
  final bool isHalfAllowed;

  @override
  RatingBarState createState() {
    return RatingBarState();
  }
}

class RatingBarState extends State<RatingBar> {
  double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Wrap(
          alignment: WrapAlignment.start,
          children: List.generate(
            widget.starCount,
            (index) => buildStar(context, index + 1),
          )),
    );
  }

  Widget buildStar(BuildContext context, int position) {
    IconData iconData;
    print('position ${position.toDouble()} currentRating $_currentRating');
    if (position.toDouble() > (_currentRating + 0.5)) {
      iconData = Icons.star_border;
    } else if (position.toDouble() == (_currentRating + 0.5)) {
      iconData = Icons.star_half;
    } else {
      iconData = Icons.star;
    }

    return GestureDetector(
      child: Icon(
        iconData,
        color: widget.color ?? Theme.of(context).primaryColor,
        size: widget.size,
      ),
      onTap: () {
        setState(() {
          _currentRating = position.toDouble();
        });
        widget.onRatingChanged(_currentRating);
      },
      onHorizontalDragUpdate: (details) {
        RenderBox renderBox = context.findRenderObject();
        var localPosition = renderBox.globalToLocal(details.globalPosition);
        var rating = localPosition.dx / widget.size;

        if (rating < 0) {
          rating = 0;
        } else if (rating > widget.starCount) {
          rating = widget.starCount.toDouble();
        } else {
          rating = widget.isHalfAllowed
              ? (2 * rating).ceilToDouble() / 2
              : rating.ceilToDouble();
        }
        if (_currentRating != rating) {
          setState(() {
            _currentRating = rating;
          });
        }
        widget.onRatingChanged(_currentRating);
      },
    );
  }
}
