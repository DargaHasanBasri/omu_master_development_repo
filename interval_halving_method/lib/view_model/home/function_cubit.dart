import 'package:flutter_bloc/flutter_bloc.dart';

class FunctionCubit extends Cubit<String> {
  FunctionCubit() : super('');

  void saveFunction(String functionExpression) {
    emit(functionExpression);
  }
}
