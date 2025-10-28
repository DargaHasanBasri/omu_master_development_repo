import 'dart:async';
import 'package:eight_stone_problem/export.dart';
import 'package:eight_stone_problem/services/a_star_solver_services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CubitHome extends Cubit<List<int?>> {
  /// Başlangıçta tüm kutular boş null değerler
  CubitHome() : super(List.filled(9, null));

  /// [currentNumber] Kullanıcının sıradaki ekleyeceği sayı 1 ile başlar.
  /// [isFlipped] Tahta görünümünün target/placement durumunu gösterir.
  /// [_isSolving] Çözüm animasyonu/işlemi devam ediyor mu bilgisini tutar.
  /// [_isStopped] Çözümü durdurmak için bool bilgi tutar
  int currentNumber = 1;
  bool isFlipped = false;
  bool isFlippedSteps = false;
  bool _isSolving = false;

  bool get isSolving => _isSolving;
  bool _isStopped = false;

  /// [solutionFound] Çözüm bulunup bulunmadığını tutan değişken.
  /// [checkedNodes] Kaç düğüm tahta durumu denendiğini tutan değişken.
  /// [totalSteps] Toplam çözüm adımı sayısı
  bool? solutionFound;
  int checkedNodes = 0;
  int totalSteps = 0;

  ///  [currentVisitedNode] Gezilen düğümler UI’da göstermek için tutan liste değişkeni.
  ///  [currentStepNum] Gezilen düğümlerdeki adım numarası 1 ile başlar.
  List<int?> currentVisitedNode = List.filled(9, null);
  int currentStepNum = 0;
  List<String> solutionInstructions = [];

  /// [selectBox] Kullanıcı kutuya tıklayınca sayıyı ekler
  void selectBox(int index) {
    /// Eğer kutu doluysa veya 8’den büyük sayı eklenmeye çalışıyorsa işlemi yapmaz.
    if (state[index] != null || currentNumber > 8) return;

    /// State’in kopyasını alır.
    final newList = List<int?>.from(state);

    /// Seçilen kutuya sayıyı ekler.
    newList[index] = currentNumber;

    /// Yeni durumu emit ederek UI'ı günceller.
    emit(newList);

    /// Sıradaki sayı 1 artırır.
    currentNumber++;
  }

  /// Tahtayı ve Cubit değerlerini sıfırlar.
  void reset() {
    if (_isSolving) {
      return;
    }
    emit(List.filled(9, null));
    currentNumber = 1;
    solutionFound = null;
    checkedNodes = 0;
    totalSteps = 0;
    currentVisitedNode = List.filled(9, null);
    currentStepNum = 0;
    solutionInstructions = [];
  }

  void stopSolution() {
    if (_isSolving) {
      _isStopped = true;
    }
  }

  ///  Tahta görünümünü değiştirir (Target <-> Placement).
  void toggleFlip() {
    isFlipped = !isFlipped;

    /// UI'ı yeniden build eder.
    emit(List<int?>.from(state));
  }

  void toggleFlipSteps() {
    isFlippedSteps = !isFlippedSteps;

    /// UI'ı yeniden build eder.
    emit(List<int?>.from(state));
  }

  /// Butona basılınca çağrılır solve çağırır.
  Future<void> solveBoard() async {
    /// Eğer çözüm animasyonu zaten devam ediyorsa işlem başlamasın.
    if (_isSolving) {
      return;
    }

    /// Eğer henüz 8 rakam yerleştirilmemişse çözümü başlatmaz.
    final filledCount = state.where((e) => e != null).length;
    if (filledCount < 8) {
      emit(List<int?>.from(state));
      return;
    }

    ///  A* algoritmasını başlatır.
    final solver = AStarSolverServices(state);
    _isSolving = true;
    await solver.solve();

    /// Sonuçları Cubit değişkenlerine atar.
    /// [checkedNodes] denenen düğüm sayısını alır.
    checkedNodes = solver.checkedNodes;

    /// [totalSteps] Toplam çözüm adımını alır.
    totalSteps = solver.solutionSteps.length != 0
        ? solver.solutionSteps.length - 1
        : 0;

    /// [solutionFound] çözümün bulunup bulunmadığı bilgisini tutar.
    solutionFound = solver.solutionFound && solver.isSolvableState;

    /// Eğer başlangıç durumu çözülemezse çözüm sürecinden çıkılır.
    if (!solver.isSolvableState) {
      emit(List<int?>.from(state));
      _isSolving = false;
      return;
    }

    /// Gezilen düğümleri UI’da animasyonla gösterir.
    await _animateVisitedNodes(solver.visitedNodes);

    if (_isStopped) {
      _isStopped = false;
      if (solutionFound == true) {
        // Sadece sağlıklı çözüm adımlarını göster
        await _animateSolution(solver.solutionSteps);
      }
      _isSolving = false;
      return; // Fonksiyondan çıkar.
    }

    /// Eğer çözüm bulunduysa çözümü adım adım animasyonla göster.
    if (solutionFound == true) {
      await _animateSolution(solver.solutionSteps);
    } else {
      emit(List<int?>.from(state));
    }
    _isSolving = false;
  }

  /// Çözüm adımlarını animasyonla gösterir.
  Future<void> _animateSolution(List<List<int?>> steps) async {
    _generateSolutionInstructions(steps);
    for (int i = 0; i < steps.length; i++) {
      emit(List<int?>.from(steps[i]));
      await Future<void>.delayed(const Duration(milliseconds: 400));
    }
  }

  /// Gezilen düğümleri adım adım animasyonla gösterir.
  Future<void> _animateVisitedNodes(List<List<int?>> visited) async {
    for (int i = 0; i < visited.length; i++) {
      if (_isStopped) {
        // Son durumu al ve step numarasını ayarlar
        currentVisitedNode = List<int?>.from(visited.last);
        currentStepNum = visited.length;
        emit(List<int?>.from(state));
        return;
      }
      currentVisitedNode = List<int?>.from(visited[i]);
      currentStepNum = i + 1;
      emit(List<int?>.from(state));
      await Future<void>.delayed(const Duration(milliseconds: 150));
    }
  }

  void _generateSolutionInstructions(List<List<int?>> steps) {
    solutionInstructions.clear();

    for (int i = 0; i < steps.length - 1; i++) {
      final current = steps[i];
      final next = steps[i + 1];

      for (int j = 0; j < current.length; j++) {
        final movedNumber = current[j];
        if (movedNumber != null && current[j] != next[j]) {
          final fromIndex = j;
          final toIndex = next.indexOf(movedNumber);

          if (toIndex != -1) {
            final fromRow = fromIndex ~/ 3;
            final fromCol = fromIndex % 3;
            final toRow = toIndex ~/ 3;
            final toCol = toIndex % 3;

            solutionInstructions.add(
              "🔹 ${i + 1}. ${LocaleKeys.homeScreen_step.locale}\n"
              "🔸 ${LocaleKeys.homeScreen_stone.locale}: `$movedNumber`\n"
              "📍 ${LocaleKeys.homeScreen_start.locale}: ($fromRow, $fromCol)\n"
              "🏁 ${LocaleKeys.homeScreen_target.locale}: ($toRow, $toCol)\n",
            );
          }
          break;
        }
      }
    }
  }
}
