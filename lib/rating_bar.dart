library rating_bar;

import 'package:flutter/material.dart';

typedef void RatingCallback(double rating);

class RatingBar extends StatefulWidget {
  RatingBar({
    Key key,
    this.maxRating = 5,
    @required this.onRatingChanged,
    @required this.filledIcon,
    @required this.emptyIcon,
    this.halfFilledIcon,
    this.isHalfAllowed = false,
    this.aligns = Alignment.centerLeft,
    this.initialRating = 0.0,
    this.filledColor,
    this.emptyColor = Colors.grey,
    this.halfFilledColor,
    this.size = 40,
    this.margin,
  })  : _readOnly = false,
        assert(maxRating != null),
        assert(initialRating != null),
        assert(filledIcon != null),
        assert(emptyIcon != null),
        assert(isHalfAllowed != null),
        assert(!isHalfAllowed || halfFilledIcon != null),
        assert(size != null),
        super(key: key);

  RatingBar.readOnly({
    Key key,
    this.maxRating = 5,
    @required this.filledIcon,
    @required this.emptyIcon,
    this.halfFilledIcon,
    this.isHalfAllowed = false,
    this.aligns = Alignment.centerLeft,
    this.initialRating = 0.0,
    this.filledColor,
    this.emptyColor = Colors.grey,
    this.halfFilledColor,
    this.size = 40,
    this.margin,
  })  : _readOnly = true,
        onRatingChanged = null,
        assert(maxRating != null),
        assert(initialRating != null),
        assert(filledIcon != null),
        assert(emptyIcon != null),
        assert(isHalfAllowed != null),
        assert(!isHalfAllowed || halfFilledIcon != null),
        assert(size != null),
        super(key: key);

  final int maxRating;
  final IconData filledIcon;
  final IconData emptyIcon;
  final IconData halfFilledIcon;
  final RatingCallback onRatingChanged;
  final double initialRating;
  final Color filledColor;
  final Color emptyColor;
  final Color halfFilledColor;
  final double size;
  final bool isHalfAllowed;
  final Alignment aligns;
  final bool _readOnly;
  final EdgeInsetsGeometry margin;

  @override
  _RatingBarState createState() {
    return _RatingBarState();
  }
}

class _RatingBarState extends State<RatingBar> {
  double _currentRating;
  Alignment _aligns;

  @override
  void initState() {
    super.initState();
    _aligns = widget.aligns;
    if (widget.isHalfAllowed) {
      _currentRating = widget.initialRating;
    } else {
      _currentRating = widget.initialRating.roundToDouble();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: _aligns,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.maxRating, (index) {
          return Builder(
            builder: (rowContext) => widget._readOnly
                ? buildIcon(context, index + 1)
                : buildStar(rowContext, index + 1),
          );
        }),
      ),
    );
  }

  Widget buildIcon(BuildContext context, int position) {
    IconData iconData;
    Color color;
    double rating;
    if (widget._readOnly) {
      if (widget.isHalfAllowed) {
        rating = widget.initialRating;
      } else {
        rating = widget.initialRating.roundToDouble();
      }
    } else {
      rating = _currentRating;
    }
    if (position > rating + 0.5) {
      iconData = widget.emptyIcon;
      color = widget.emptyColor ?? Colors.grey;
    } else if (position == rating + 0.5) {
      iconData = widget.halfFilledIcon;
      color = widget.halfFilledColor ??
          widget.filledColor ??
          Theme.of(context).primaryColor;
    } else {
      iconData = widget.filledIcon;
      color = widget.filledColor ?? Theme.of(context).primaryColor;
    }

    var icon = Icon(iconData, color: color, size: widget.size);

    return widget.margin != null
        ? Container(
            margin: widget.margin,
            child: icon,
          )
        : icon;
  }

  Widget buildStar(BuildContext context, int position) {
    return GestureDetector(
      child: buildIcon(context, position),
      onTap: () {
        setState(() => _currentRating = position.toDouble());
        widget?.onRatingChanged(_currentRating);
      },
      onHorizontalDragUpdate: (details) {
        RenderBox renderBox = context.findRenderObject();
        var localPosition = renderBox.globalToLocal(details.globalPosition);
        var rating = localPosition.dx / widget.size;

        if (rating < 0) {
          rating = 0;
        } else if (rating > widget.maxRating) {
          rating = widget.maxRating.toDouble();
        } else {
          rating = widget.isHalfAllowed
              ? (2 * rating).ceilToDouble() / 2
              : rating.ceilToDouble();
        }
        if (_currentRating != rating) {
          setState(() => _currentRating = rating);
          widget?.onRatingChanged(_currentRating);
        }
      },
    );
  }
}
