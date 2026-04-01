import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gen/gen.dart';
import 'package:interval_halving_method/core/enums/optimization_objective.dart';
import 'package:interval_halving_method/view_model/home/objective_cubit.dart';

class ObjectiveToggle extends StatelessWidget {
  const ObjectiveToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ObjectiveCubit, OptimizationObjective>(
      builder: (context, currentObjective) {
        return Container(
          height: 48,
          decoration: BoxDecoration(
            color: ColorName.lavenderMist,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(4),
          child: Row(
            children: [
              _buildToggleButton(
                context: context,
                title: 'Minimize',
                objectiveType: OptimizationObjective.minimize,
                currentObjective: currentObjective,
              ),
              _buildToggleButton(
                context: context,
                title: 'Maximize',
                objectiveType: OptimizationObjective.maximize,
                currentObjective: currentObjective,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToggleButton({
    required BuildContext context,
    required String title,
    required OptimizationObjective objectiveType,
    required OptimizationObjective currentObjective,
  }) {
    final isSelected = objectiveType == currentObjective;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          context.read<ObjectiveCubit>().changeObjective(objectiveType);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF1976D2)
                  : const Color(0xFF6C757D),
            ),
          ),
        ),
      ),
    );
  }
}
