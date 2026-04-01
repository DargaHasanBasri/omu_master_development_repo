import 'package:flutter/material.dart';

enum PointCardType { lower, mid, upper }

class PointDetailsCard extends StatelessWidget {
  const PointDetailsCard({
    required this.type,
    required this.title,
    required this.xValue,
    required this.fxValue,
    super.key,
  });

  final PointCardType type;
  final String title;
  final String xValue;
  final String fxValue;

  @override
  Widget build(BuildContext context) {
    final isMid = type == PointCardType.mid;
    final isUpper = type == PointCardType.upper;

    final primaryColor = isUpper
        ? const Color(0xFF98A2B3)
        : const Color(0xFF2563EB);
    final backgroundColor = isMid ? const Color(0xFFF0F4FF) : Colors.white;
    final borderColor = isMid
        ? const Color(0xFFBFDBFE)
        : const Color(0xFFE4E7EC);

    IconData iconData;
    switch (type) {
      case PointCardType.lower:
        iconData = Icons.arrow_downward_rounded;
      case PointCardType.mid:
        iconData = Icons.adjust_rounded;
      case PointCardType.upper:
        iconData = Icons.arrow_upward_rounded;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: isMid
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  offset: const Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: primaryColor,
                width: 4,
              ),
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  Icon(
                    iconData,
                    color: primaryColor.withValues(alpha: 0.6),
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Value (x)',
                          style: TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          xValue,
                          style: TextStyle(
                            color: isUpper
                                ? const Color(0xFF667085)
                                : const Color(0xFF101828),
                            fontSize: 18,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Function f(x)',
                          style: TextStyle(
                            color: Color(0xFF667085),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          fxValue,
                          style: TextStyle(
                            color: isUpper
                                ? const Color(0xFF667085)
                                : const Color(0xFF101828),
                            fontSize: 18,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
