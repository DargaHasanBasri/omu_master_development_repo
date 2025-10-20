import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/a_star_solver_services.dart';

class CubitHome extends Cubit<List<int?>> {
  CubitHome() : super(List.filled(9, null));

  int currentNumber = 1;
  bool isFlipped = false;

  bool? solutionFound;
  int checkedNodes = 0;
  int totalSteps = 0;
  bool showIncompleteWarning = false;

  void selectBox(int index) {
    if (state[index] != null || currentNumber > 8) return;
    final newList = List<int?>.from(state);
    newList[index] = currentNumber;
    emit(newList);
    currentNumber++;
  }

  void reset() {
    emit(List.filled(9, null));
    currentNumber = 1;
    solutionFound = null;
    checkedNodes = 0;
    totalSteps = 0;
    showIncompleteWarning = false;
  }

  void toggleFlip() {
    isFlipped = !isFlipped;
    emit(List<int?>.from(state));
  }

  Future<void> solvePuzzle() async {
    final solver = AStarSolver(state);
    await solver.solve();

    checkedNodes = solver.checkedNodes;
    totalSteps = solver.solutionSteps.length - 1;
    solutionFound = solver.solutionFound && solver.isSolvableState;

    if (!solver.isSolvableState) {
      print("❌ Bu başlangıç durumu çözülemez!");
      emit(List<int?>.from(state));
      return;
    }

    if (solutionFound == true) {
      await _animateSolution(solver.solutionSteps);
    } else {
      emit(List<int?>.from(state));
    }
  }

  Future<void> _animateSolution(List<List<int?>> steps) async {
    for (int i = 0; i < steps.length; i++) {
      emit(List<int?>.from(steps[i]));
      await Future.delayed(const Duration(milliseconds: 400));
    }
  }
}
