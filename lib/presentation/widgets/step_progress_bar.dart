import 'package:flutter/material.dart';
import 'package:shoe_care/presentation/widgets/dashed_line.dart';

class StepProgressBar extends StatelessWidget {
  const StepProgressBar({
    super.key,
    required this.currentStatus,
    required this.stps,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
    this.lineHeight = 2,
  });
  final String currentStatus;
  final List<String> stps;
  final Color activeColor;
  final Color inactiveColor;
  final double lineHeight;

  @override
  Widget build(BuildContext context) {
    final indicators = <Widget>[];
    final indicatorText = <Widget>[];
    final currentIndex =
        stps.contains(currentStatus) ? stps.indexOf(currentStatus) : 0;
    for (var i = 0; i < stps.length; i++) {
      final status = i == currentIndex
          ? StepStatus.active
          : i < currentIndex
              ? StepStatus.done
              : StepStatus.inactive;
      indicators.add(_buildCircleIndicator(status));
      if (i != stps.length - 1) {
        indicators.add(_buildLine(i < currentIndex));
      }
      indicatorText.add(
        Expanded(
          child: Text(
            stps[i],
            textAlign: TextAlign.center,
            style: TextStyle(
              color: i <= currentIndex ? activeColor : inactiveColor,
              fontWeight:
                  i == currentIndex ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
                child: Row(
                  children: indicators,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: indicatorText,
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _buildLine(
    bool isAfterActive,
  ) {
    return Expanded(
      child: isAfterActive
          ? Container(
              height: lineHeight,
              color: activeColor,
            )
          : DashedLine(
              height: lineHeight,
              color: inactiveColor,
            ),
    );
  }

  Widget _buildCircleIndicator(StepStatus status) {
    switch (status) {
      case StepStatus.active:
        return Expanded(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: activeColor, width: 2),
                ),
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: activeColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        );

      case StepStatus.inactive:
        return Expanded(
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: inactiveColor, width: 2),
            ),
            child: Container(
              width: 16,
              height: 16,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
      case StepStatus.done:
        return Expanded(
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: activeColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
        );
    }
  }
}

enum StepStatus { active, inactive, done }
