import 'package:flutter/material.dart';

class OptimizationResultHeader extends StatelessWidget {
  const OptimizationResultHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Color(0xFFEBF7F0),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_circle_outline_rounded,
            color: Color(0xFF12B76A),
            size: 32,
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Optimal Solution Found',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF101828),
            fontSize: 26,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Convergence reached successfully using Interval\nHalving Method.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF64748B),
            fontSize: 12,
            fontWeight: FontWeight.w500,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
