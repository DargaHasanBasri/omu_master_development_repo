import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interval_halving_method/core/enums/optimization_objective.dart';


class ObjectiveCubit extends Cubit<OptimizationObjective> {
  ObjectiveCubit() : super(OptimizationObjective.minimize);

  void changeObjective(OptimizationObjective newObjective) {
    if (state != newObjective) {
      emit(newObjective);
    }
  }
}