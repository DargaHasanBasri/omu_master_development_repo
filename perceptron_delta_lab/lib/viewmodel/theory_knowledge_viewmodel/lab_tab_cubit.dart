import 'package:flutter_bloc/flutter_bloc.dart';

enum LabTab { perceptron, delta }

final class LabTabCubit extends Cubit<LabTab> {
  LabTabCubit() : super(LabTab.perceptron);

  void select(LabTab tab) => emit(tab);
}
