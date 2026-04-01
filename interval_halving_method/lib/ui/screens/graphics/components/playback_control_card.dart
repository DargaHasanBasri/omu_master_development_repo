import 'package:flutter/material.dart';

class PlaybackControlCard extends StatelessWidget {
  const PlaybackControlCard({
    required this.currentStep,
    required this.totalSteps,
    required this.isPlaying,
    required this.onPlayPausePressed,
    required this.onPreviousPressed,
    required this.onNextPressed,
    required this.onSliderChanged,
    super.key,
  });

  final int currentStep;
  final int totalSteps;
  final bool isPlaying;
  final VoidCallback onPlayPausePressed;
  final VoidCallback onPreviousPressed;
  final VoidCallback onNextPressed;
  final ValueChanged<double> onSliderChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4E7EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Playback',
                style: TextStyle(
                  color: Color(0xFF101828),
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.5,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Step $currentStep/$totalSteps',
                  style: const TextStyle(
                    color: Color(0xFF475467),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 6.0,
              activeTrackColor: const Color(0xFF2563EB),
              inactiveTrackColor: const Color(0xFFE2E8F0),
              thumbColor: Colors.white,
              overlayColor: const Color(0xFF2563EB).withValues(alpha: 0.2),
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 10.0,
                elevation: 4,
              ),
            ),
            child: Slider(
              value: currentStep.toDouble(),
              min: 1,
              max: totalSteps.toDouble() > 1 ? totalSteps.toDouble() : 1,
              divisions: totalSteps > 1 ? totalSteps - 1 : 1,
              onChanged: onSliderChanged,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: currentStep > 1 ? onPreviousPressed : null,
                icon: const Icon(Icons.skip_previous_rounded),
                color: const Color(0xFF475467),
                iconSize: 28,
              ),
              InkWell(
                onTap: onPlayPausePressed,
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2563EB),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2563EB).withValues(alpha: 0.3),
                        offset: const Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
              ),
              IconButton(
                onPressed: currentStep < totalSteps ? onNextPressed : null,
                icon: const Icon(Icons.skip_next_rounded),
                color: const Color(0xFF475467),
                iconSize: 28,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
