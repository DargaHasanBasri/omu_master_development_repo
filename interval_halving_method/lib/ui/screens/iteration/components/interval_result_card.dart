import 'package:flutter/material.dart';

class IntervalResultCard extends StatelessWidget {
  const IntervalResultCard({
    required this.eliminatedSide,
    required this.eliminatedInterval,
    required this.newInterval,
    super.key,
  });

  final String eliminatedSide;
  final String eliminatedInterval;
  final String newInterval;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E7EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            offset: const Offset(0, 1),
            blurRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          _buildResultRow(
            icon: Icons.close,
            iconColor: const Color(0xFFD92D20),
            bgColor: const Color(0xFFFEE4E2),
            prefixText: '$eliminatedSide interval ',
            intervalText: eliminatedInterval,
            suffixText: ' eliminated',
          ),
          _buildResultRow(
            icon: Icons.check,
            iconColor: const Color(0xFF12B76A),
            bgColor: const Color(0xFFD1FADF),
            prefixText: 'New interval is ',
            intervalText: newInterval,
            suffixText: '',
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String prefixText,
    required String intervalText,
    required String suffixText,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 2),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                prefixText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF475467),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF2F4F7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  intervalText,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF344054),
                  ),
                ),
              ),
              if (suffixText.isNotEmpty)
                Text(
                  suffixText,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF475467),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
