import 'package:flutter/material.dart';
import 'package:gen/gen.dart';

class IntervalStatusDetailsCard extends StatelessWidget {
  const IntervalStatusDetailsCard({
    required this.statusText,
    required this.intervalText,
    required this.midpointText,
    required this.fxmText,
    required this.lengthText,
    super.key,
  });

  final String statusText;
  final String intervalText;
  final String midpointText;
  final String fxmText;
  final String lengthText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: ColorName.alabaster,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColorName.catskillWhite, strokeAlign: -0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start, // Metinler alt satıra geçerse üstten hizalansın
            children: [
              const Text(
                'INTERVAL STATUS',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(width: 12), // İki metin arasına güvenlik boşluğu
              // TAŞMAYI ÖNLEYEN KISIM: Expanded eklendi
              Expanded(
                child: Text(
                  statusText,
                  textAlign: TextAlign.right, // Sağa yaslı tutmak için
                  style: const TextStyle(
                    color: Color(0xFF2563EB),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(color: Color(0xFFE2E8F0), thickness: 1),
          const SizedBox(height: 12),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Current Interval [a, b]',
                style: TextStyle(
                  color: Color(0xFF475467),
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                intervalText,
                style: const TextStyle(
                  color: Color(0xFF101828),
                  fontSize: 16,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          _buildDataRow(
            label: 'Midpoint (xm)',
            value: midpointText,
            valueColor: const Color(0xFF2563EB),
          ),
          const SizedBox(height: 16),

          _buildDataRow(
            label: 'f(xm) Value',
            value: fxmText,
          ),
          const SizedBox(height: 16),

          _buildDataRow(
            label: 'Length (L)',
            value: lengthText,
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow({
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF475467),
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? const Color(0xFF101828),
            fontSize: 16,
            fontFamily: 'monospace',
            fontWeight: FontWeight.w700,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
