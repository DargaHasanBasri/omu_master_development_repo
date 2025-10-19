import 'package:flutter_bloc/flutter_bloc.dart';

class CubitHome extends Cubit<List<int?>> {
  CubitHome() : super(List.filled(9, null));

  int currentNumber = 1;

  void selectBox(int index) {
    // Eğer zaten doluysa ya da 8’den büyükse, işlem yapma
    if (state[index] != null || currentNumber > 8) return;

    // Yeni liste oluştur (immutable yaklaşım)
    final newList = List<int?>.from(state);
    newList[index] = currentNumber;

    emit(newList);

    currentNumber++;
  }

  void reset() {
    emit(List.filled(9, null));
    currentNumber = 1;
  }

  bool isFlipped = false;

  void toggleFlip() {
    isFlipped = !isFlipped;
    emit(List<int?>.from(state));
  }

}
