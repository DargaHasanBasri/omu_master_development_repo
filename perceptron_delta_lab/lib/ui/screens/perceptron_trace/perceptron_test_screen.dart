import 'package:perceptron_delta_lab/viewmodel/data_set/data_set_table_cubit.dart';
import '../../../export.dart';

class PerceptronTestScreen extends StatelessWidget {
  final PerceptronTestResult result;

  const PerceptronTestScreen({super.key, required this.result});

  String _fmt(double v) => v.toStringAsFixed(1);

  @override
  Widget build(BuildContext context) {
    final okColor = const Color(0xFF34C759);
    final errColor = const Color(0xFFF5576C);

    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: ColorName.white,
        elevation: 0,
        title: Text(
          'Perceptron Test Sonuçları',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
            color: const Color(0xFF1D1D1F),
            fontWeight: FontWeight.w700,
          ),
        ),
        leading: Material(
          color: Colors.transparent,
          child: InkWell(
            customBorder: const CircleBorder(),
            splashColor: ColorName.darkLavender.withValues(alpha: 0.3),
            onTap: () => Navigator.pop(context),
            child: Ink(
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Assets.icons.icArrowBack.image(
                package: AppConstants.packageName,
                color: ColorName.darkLavender,
                scale: 1.6,
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // ---------------- ÖZET KARTI (Trace summary ile uyumlu) ----------------
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Gradient header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          result.incorrect == 0
                              ? Icons.check_circle
                              : Icons.insights,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Test Özeti',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Doğruluk: '
                                '${(result.accuracy * 100).toStringAsFixed(1)}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // İçerik
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Toplam: ${result.total}, '
                              'Doğru: ${result.correct}, '
                              'Hatalı: ${result.incorrect}',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: result.incorrect == 0
                                ? okColor
                                : errColor,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Kullanılan w = '
                              '[${result.usedWeights.map(_fmt).join(', ')}],  '
                              'w₀ = ${_fmt(result.usedBiasWeight)}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                            color: Color(0xFF1D1D1F),
                          ),
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ---------------- HER ÖRNEK İÇİN KART ----------------
            ...result.samples.asMap().entries.map((entry) {
              final i = entry.key;
              final s = entry.value;
              final ok = s.isCorrect;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFAFAFA),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: ok ? const Color(0xFF667EEA) : errColor,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Üst satır: chip + Doğru/Hata
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Örnek ${i + 1}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            ok ? 'Doğru' : 'Hata',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: ok ? okColor : errColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // x vektörü
                      Text(
                        'x = (${s.x.map(_fmt).join(', ')})',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: Color(0xFF515154),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // net ve ŷ
                      Text(
                        'net = ${_fmt(s.netInput)}   →   ŷ = ${s.prediction}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'monospace',
                          color: Color(0xFF515154),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Gerçek y + durum
                      Row(
                        children: [
                          Text(
                            'Gerçek y = ${s.target}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            '→',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFF86868B),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            ok ? '✅ Doğru sınıflandı' : '❌ Hatalı sınıflandı',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: ok ? okColor : errColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
