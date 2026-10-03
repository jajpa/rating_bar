import 'package:flutter/material.dart';

/// A widget wrapper to hold full, empty, and optional half rating widgets.
class RatingWidget {
  const RatingWidget({
    required this.full,
    required this.empty,
    this.half,
  });

  final Widget full;
  final Widget empty;
  final Widget? half;
}

/// A customizable Rating Bar for Flutter with half-rating, precise fractional
/// rating, custom items, and RTL support.
class RatingBar extends StatefulWidget {
  /// Default constructor for simple icon-based rating bars.
  const RatingBar({
    super.key,
    this.maxRating = 5,
    this.onRatingChanged,
    required this.filledIcon,
    required this.emptyIcon,
    this.halfFilledIcon,
    this.isHalfAllowed = false,
    this.allowFractionalRating = false,
    this.alignment = Alignment.centerLeft,
    this.direction = Axis.horizontal,
    this.initialRating = 0.0,
    this.filledColor,
    this.emptyColor = Colors.grey,
    this.halfFilledColor,
    this.size = 40,
    this.itemPadding = EdgeInsets.zero,
    this.ignoreGestures = false,
    this.tapOnlyMode = false,
    this.textDirection,
  })  : _itemBuilder = null,
        _filledWidget = null,
        _emptyWidget = null,
        _halfFilledWidget = null;

  /// Constructor for a rating bar with custom widgets for all items.
  const RatingBar.custom({
    super.key,
    this.maxRating = 5,
    this.onRatingChanged,
    required Widget filledWidget,
    required Widget emptyWidget,
    Widget? halfFilledWidget,
    this.isHalfAllowed = false,
    this.allowFractionalRating = false,
    this.alignment = Alignment.centerLeft,
    this.direction = Axis.horizontal,
    this.initialRating = 0.0,
    this.size = 40,
    this.itemPadding = EdgeInsets.zero,
    this.ignoreGestures = false,
    this.tapOnlyMode = false,
    this.textDirection,
  })  : _filledWidget = filledWidget,
        _emptyWidget = emptyWidget,
        _halfFilledWidget = halfFilledWidget,
        _itemBuilder = null,
        filledIcon = null,
        emptyIcon = null,
        halfFilledIcon = null,
        filledColor = null,
        emptyColor = null,
        halfFilledColor = null;

  /// Constructor for an item-by-item builder (useful for emojis or gradients).
  const RatingBar.builder({
    super.key,
    this.maxRating = 5,
    this.onRatingChanged,
    required RatingWidget Function(BuildContext context, int index) itemBuilder,
    this.isHalfAllowed = false,
    this.allowFractionalRating = false,
    this.alignment = Alignment.centerLeft,
    this.direction = Axis.horizontal,
    this.initialRating = 0.0,
    this.size = 40,
    this.itemPadding = EdgeInsets.zero,
    this.ignoreGestures = false,
    this.tapOnlyMode = false,
    this.textDirection,
  })  : _itemBuilder = itemBuilder,
        _filledWidget = null,
        _emptyWidget = null,
        _halfFilledWidget = null,
        filledIcon = null,
        emptyIcon = null,
        halfFilledIcon = null,
        filledColor = null,
        emptyColor = null,
        halfFilledColor = null;

  final int maxRating;
  final ValueChanged<double>? onRatingChanged;
  final double initialRating;
  final bool isHalfAllowed;
  final bool allowFractionalRating;
  final Alignment alignment;
  final Axis direction;
  final double size;
  final EdgeInsetsGeometry itemPadding;
  final bool ignoreGestures;
  final bool tapOnlyMode;
  final TextDirection? textDirection;

  // Icon based
  final IconData? filledIcon;
  final IconData? emptyIcon;
  final IconData? halfFilledIcon;
  final Color? filledColor;
  final Color? emptyColor;
  final Color? halfFilledColor;

  // Widget based
  final Widget? _filledWidget;
  final Widget? _emptyWidget;
  final Widget? _halfFilledWidget;

  // Builder based
  final RatingWidget Function(BuildContext context, int index)? _itemBuilder;

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  late double _currentRating;

  @override
  void initState() {
    super.initState();
    _currentRating = widget.initialRating;
    _normalizeInitialRating();
  }

  @override
  void didUpdateWidget(RatingBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialRating != widget.initialRating) {
      _currentRating = widget.initialRating;
      _normalizeInitialRating();
    }
  }

  void _normalizeInitialRating() {
    if (widget.allowFractionalRating) {
      return;
    }
    if (widget.isHalfAllowed) {
      _currentRating = (_currentRating * 2).roundToDouble() / 2.0;
    } else {
      _currentRating = _currentRating.roundToDouble();
    }
  }

  bool get _isRTL {
    final textDir = widget.textDirection ?? Directionality.maybeOf(context);
    return textDir == TextDirection.rtl;
  }

  Widget _buildItem(BuildContext context, int index) {
    Widget fullWidget;
    Widget emptyWidget;
    Widget? halfWidget;

    if (widget._itemBuilder != null) {
      final ratingWidget = widget._itemBuilder!(context, index);
      fullWidget = ratingWidget.full;
      emptyWidget = ratingWidget.empty;
      halfWidget = ratingWidget.half;
    } else if (widget._filledWidget != null && widget._emptyWidget != null) {
      fullWidget = widget._filledWidget!;
      emptyWidget = widget._emptyWidget!;
      halfWidget = widget._halfFilledWidget;
    } else {
      final color = widget.filledColor ?? Theme.of(context).primaryColor;
      final emptyCol = widget.emptyColor ?? Colors.grey;
      final halfCol = widget.halfFilledColor ?? color;

      fullWidget = Icon(widget.filledIcon, color: color, size: widget.size);
      emptyWidget = Icon(widget.emptyIcon, color: emptyCol, size: widget.size);
      if (widget.halfFilledIcon != null) {
        halfWidget =
            Icon(widget.halfFilledIcon, color: halfCol, size: widget.size);
      }
    }

    Widget content;
    final ratingOffset = _currentRating - index;

    if (ratingOffset >= 1.0) {
      content = fullWidget;
    } else if (ratingOffset <= 0.0) {
      content = emptyWidget;
    } else {
      // It's a fractional part
      if (widget.isHalfAllowed &&
          halfWidget != null &&
          (ratingOffset == 0.5 || !widget.allowFractionalRating)) {
        content = halfWidget;
      } else {
        // Use Stack with ClipRect for fractional fill
        content = Stack(
          fit: StackFit.passthrough,
          children: [
            emptyWidget,
            ClipRect(
              clipper: _FractionalClipper(
                fraction: ratingOffset,
                isRTL: _isRTL,
                direction: widget.direction,
              ),
              child: fullWidget,
            ),
          ],
        );
      }
    }

    return Padding(
      padding: widget.itemPadding,
      child: SizedBox(
        width: widget.direction == Axis.horizontal ? widget.size : null,
        height: widget.direction == Axis.vertical ? widget.size : null,
        child: FittedBox(
          fit: BoxFit.contain,
          child: content,
        ),
      ),
    );
  }

  void _handleGesture(
      double localPosition, double maxPosition, double itemTotalSize) {
    if (widget.ignoreGestures || widget.onRatingChanged == null) return;

    double fraction = localPosition / maxPosition;
    if (fraction < 0.0) fraction = 0.0;
    if (fraction > 1.0) fraction = 1.0;

    if (_isRTL && widget.direction == Axis.horizontal) {
      fraction = 1.0 - fraction;
    }

    double newRating = fraction * widget.maxRating;

    if (widget.allowFractionalRating) {
      // Keep precise
    } else if (widget.isHalfAllowed) {
      // Round to nearest 0.5 based on item boundaries
      newRating = (newRating * 2).ceilToDouble() / 2.0;
    } else {
      newRating = newRating.ceilToDouble();
    }

    if (newRating != _currentRating) {
      setState(() {
        _currentRating = newRating;
      });
      widget.onRatingChanged?.call(_currentRating);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isHorizontal = widget.direction == Axis.horizontal;

    // We wrap everything in a GestureDetector to properly track the position over the whole bar.
    Widget rowOrColumn = isHorizontal
        ? Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.maxRating,
              (index) => _buildItem(context, index),
            ),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              widget.maxRating,
              (index) => _buildItem(context, index),
            ),
          );

    final itemPaddingSize = isHorizontal
        ? widget.itemPadding.horizontal
        : widget.itemPadding.vertical;
    final itemTotalSize = widget.size + itemPaddingSize;

    Widget touchTarget = LayoutBuilder(
      builder: (context, constraints) {
        return GestureDetector(
          onTapDown: (details) {
            final maxPos =
                isHorizontal ? context.size!.width : context.size!.height;
            final pos = isHorizontal
                ? details.localPosition.dx
                : details.localPosition.dy;
            _handleGesture(pos, maxPos, itemTotalSize);
          },
          onHorizontalDragUpdate: isHorizontal && !widget.tapOnlyMode
              ? (details) {
                  final maxPos = context.size!.width;
                  _handleGesture(
                      details.localPosition.dx, maxPos, itemTotalSize);
                }
              : null,
          onVerticalDragUpdate: !isHorizontal && !widget.tapOnlyMode
              ? (details) {
                  final maxPos = context.size!.height;
                  _handleGesture(
                      details.localPosition.dy, maxPos, itemTotalSize);
                }
              : null,
          child: rowOrColumn,
        );
      },
    );

    return Align(
      alignment: widget.alignment,
      child: touchTarget,
    );
  }
}

class _FractionalClipper extends CustomClipper<Rect> {
  const _FractionalClipper({
    required this.fraction,
    required this.isRTL,
    required this.direction,
  });

  final double fraction;
  final bool isRTL;
  final Axis direction;

  @override
  Rect getClip(Size size) {
    if (direction == Axis.horizontal) {
      final width = size.width * fraction;
      if (isRTL) {
        return Rect.fromLTRB(size.width - width, 0, size.width, size.height);
      }
      return Rect.fromLTRB(0, 0, width, size.height);
    } else {
      final height = size.height * fraction;
      return Rect.fromLTRB(0, 0, size.width, height);
    }
  }

  @override
  bool shouldReclip(_FractionalClipper oldClipper) {
    return oldClipper.fraction != fraction ||
        oldClipper.isRTL != isRTL ||
        oldClipper.direction != direction;
  }
}
