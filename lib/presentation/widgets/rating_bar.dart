import 'package:flutter/material.dart';

class RatingBar extends StatefulWidget {
  const RatingBar({
    super.key,
    this.onRatingChanged,
    this.initialRating,
    this.minRating = 0,
    this.maxRating = 5,
    this.filledIcon,
    this.halfFilledIcon,
    this.emptyIcon,
    this.filledColor,
    this.halfFilledColor,
    this.emptyColor,
    this.iconSize = 32,
    this.isHalfAllowed = true,
    this.disableChange = false,
  });
  final Function(double)? onRatingChanged;
  final double? initialRating;
  final double minRating;
  final int maxRating;
  final bool disableChange;
  final IconData? filledIcon;
  final IconData? halfFilledIcon;
  final IconData? emptyIcon;
  final Color? filledColor;
  final Color? halfFilledColor;
  final Color? emptyColor;
  final double iconSize;
  final bool isHalfAllowed;

  @override
  State<RatingBar> createState() => _RatingBarState();
}

class _RatingBarState extends State<RatingBar> {
  double _rating = 0;
  @override
  void initState() {
    _rating = widget.initialRating ?? widget.minRating;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // listen slide and tap event
    return GestureDetector(
      onHorizontalDragUpdate: widget.disableChange
          ? null
          : (details) {
              // get position of tap
              final RenderBox box = context.findRenderObject() as RenderBox;
              final tapPos = box.globalToLocal(details.globalPosition);
              // get width of widget
              final widgetWidth = box.size.width;
              // get width of each icon
              final iconWidth = widgetWidth / widget.maxRating;
              // get rating
              final rating = tapPos.dx / iconWidth;
              // get integer of rating
              final intRating = rating.floor();
              // get decimal of rating
              final decimalRating = rating - intRating;
              // if decimal of rating > 0.5 then rating is intRating + 1
              // else rating is intRating
              if (decimalRating > 0.5) {
                setState(() {
                  _rating = intRating + 1;
                });
              } else {
                setState(() {
                  _rating = intRating.toDouble();
                });
              }
              // call onRatingChanged
              widget.onRatingChanged?.call(_rating);
            },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          widget.maxRating,
          (index) => InkWell(
            onTap: widget.disableChange
                ? null
                : () {
                    setState(() {
                      _rating = index + 1.0;
                    });
                    widget.onRatingChanged?.call(_rating);
                  },
            child: Icon(
              index + 1 <= _rating
                  ? widget.filledIcon ?? Icons.star
                  : index + 1 - _rating < 1
                      ? widget.halfFilledIcon ?? Icons.star_half
                      : widget.emptyIcon ?? Icons.star_border_outlined,
              color: index + 1 <= _rating
                  ? widget.filledColor ?? Colors.yellow
                  : index + 1 - _rating < 1
                      ? widget.halfFilledColor ??
                          widget.filledColor ??
                          Colors.yellow
                      : widget.emptyColor ?? Colors.yellow,
              size: widget.iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
