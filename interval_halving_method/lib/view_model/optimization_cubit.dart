import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interval_halving_method/core/enums/optimization_objective.dart';
import 'package:interval_halving_method/core/models/iteration_step.dart';
import 'package:interval_halving_method/view_model/optimization_state.dart';
import 'package:math_expressions/math_expressions.dart';

class OptimizationCubit extends Cubit<OptimizationState> {
  OptimizationCubit() : super(OptimizationInitial());

  void solve({
    required String functionString,
    required double lowerLimit,
    required double upperLimit,
    required double epsilon,
    required OptimizationObjective objective,
  }) {
    emit(OptimizationLoading());

    // İşlem süresini hesaplamak için kronometre başlatıyoruz
    final stopwatch = Stopwatch()..start();

    try {
      // 1. Fonksiyonu String'den matematiksel ifadeye çevir
      Parser p = Parser();
      Expression exp = p.parse(functionString);
      ContextModel cm = ContextModel();

      // Değer hesaplamak için yardımcı fonksiyon
      double evaluateFx(double xValue) {
        cm.bindVariable(Variable('x'), Number(xValue));

        // Dönen sonucu önce num olarak kabul edip, ardından kesin olarak double'a çeviriyoruz
        return (exp.evaluate(EvaluationType.REAL, cm) as num).toDouble();
      }

      double a = lowerLimit;
      double b = upperLimit;
      double L = b - a;
      double xm = (a + b) / 2;

      List<IterationStep> steps = [];
      int iteration = 1;
      int maxIterations = 1000; // Sonsuz döngü koruması

      // 2. Aralık Yarılama (Interval Halving) Algoritması
      while (L.abs() >= epsilon && iteration <= maxIterations) {
        double x1 = a + (L / 4);
        double x2 = b - (L / 4);

        double fx1 = evaluateFx(x1);
        double fxm = evaluateFx(xm);
        double fx2 = evaluateFx(x2);

        String eliminated = '';
        String newlyFormed = '';

        double nextA = a;
        double nextB = b;
        double nextXm = xm;

        // Minimizasyon ve Maksimizasyon için koşullar
        bool isMinimize = objective == OptimizationObjective.minimize;

        if (isMinimize ? (fx1 < fxm) : (fx1 > fxm)) {
          // Sol taraf daha iyi, sağ tarafı [xm, b] ele
          nextB = xm;
          nextXm = x1;
          eliminated = 'Right [xm, b]';
          newlyFormed = '[$a, $xm]';
        } else if (isMinimize ? (fx2 < fxm) : (fx2 > fxm)) {
          // Sağ taraf daha iyi, sol tarafı [a, xm] ele
          nextA = xm;
          nextXm = x2;
          eliminated = 'Left [a, xm]';
          newlyFormed = '[$xm, $b]';
        } else {
          // Orta bölge daha iyi, uçları [a, x1] ve [x2, b] ele
          nextA = x1;
          nextB = x2;
          nextXm = xm;
          eliminated = 'Both Ends';
          newlyFormed = '[$x1, $x2]';
        }

        // Adımı listeye kaydet
        steps.add(
          IterationStep(
            iteration: iteration,
            a: a,
            b: b,
            l: L,
            x1: x1,
            xm: xm,
            x2: x2,
            fx1: fx1,
            fxm: fxm,
            fx2: fx2,
            eliminatedInterval: eliminated,
            newInterval: newlyFormed,
          ),
        );

        // Değerleri bir sonraki iterasyon için güncelle
        a = nextA;
        b = nextB;
        xm = nextXm;
        L = b - a;
        iteration++;
      }

      stopwatch.stop();

      // 3. Sonuçları UI'a (Success durumu olarak) gönder
      emit(
        OptimizationSuccess(
          steps: steps,
          optimalX: xm,
          optimalFx: evaluateFx(xm),
          totalIterations: iteration - 1,
          processTimeMs: stopwatch.elapsedMilliseconds,
        ),
      );
    } catch (e) {
      // Fonksiyon yanlış yazılmışsa veya hesaplama hatası varsa
      emit(
        OptimizationError(
          'Fonksiyon çözümlenemedi. Lütfen geçerli bir matematiksel ifade girdiğinizden emin olun.\nHata: ${e.toString()}',
        ),
      );
    }
  }
}
