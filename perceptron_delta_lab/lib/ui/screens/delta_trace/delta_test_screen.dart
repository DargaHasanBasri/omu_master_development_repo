import 'package:go_router/go_router.dart';
import 'package:perceptron_delta_lab/viewmodel/delta_data_set/delta_data_set_table_cubit.dart';
import '../../../export.dart';

class DeltaTestScreen extends StatelessWidget {
  final DeltaTestResult result;

  const DeltaTestScreen({super.key, required this.result});

  String _fmt(double v) => v.toStringAsFixed(3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: ColorName.white,
        elevation: 0,
        title: Text(
          'Delta Test Sonuçları',
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
            onTap: () => context.pop(),
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
            _DeltaTestSummaryCard(
              result: result,
              fmt: _fmt,
            ),
            const SizedBox(height: 16),

            // Her test örneği için kart
            ...result.samples.asMap().entries.map((entry) {
              final index = entry.key;
              final sample = entry.value;
              return _DeltaTestSampleCard(
                index: index,
                sample: sample,
                fmt: _fmt,
              );
            }),
          ],
        ),
      ),
    );
  }
}

/* --------------------------- Özet Kartı (üstte) --------------------------- */

class _DeltaTestSummaryCard extends StatelessWidget {
  final DeltaTestResult result;
  final String Function(double) fmt;

  const _DeltaTestSummaryCard({
    required this.result,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    final okColor = const Color(0xFF34C759);
    final errColor = const Color(0xFFF5576C);
    final bool perfect = result.accuracy == 1.0;

    return Container(
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
          // Gradient başlık
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
                  perfect ? Icons.check_circle : Icons.analytics,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Delta Test Özeti',
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
                    'Doğruluk: ${(result.accuracy * 100).toStringAsFixed(1)}%',
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
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Toplam ${result.total} örnek test edildi.',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.check_circle, color: okColor, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'Doğru: ${result.correct}',
                      style: TextStyle(
                        color: okColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.cancel, color: errColor, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      'Hatalı: ${result.incorrect}',
                      style: TextStyle(
                        color: errColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Kullanılan w = [${result.usedWeights.map((w) => w.toStringAsFixed(1)).join(', ')}],  φ = ${result.usedPhi.toStringAsFixed(1)}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontFamily: 'monospace',
                    color: Color(0xFF1D1D1F),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ----------------------- Her bir örnek için kart ------------------------ */

class _DeltaTestSampleCard extends StatelessWidget {
  final int index;
  final DeltaTestSampleResult sample;
  final String Function(double) fmt;

  const _DeltaTestSampleCard({
    required this.index,
    required this.sample,
    required this.fmt,
  });

  @override
  Widget build(BuildContext context) {
    final ok = sample.isCorrect;
    final Color okColor = const Color(0xFF34C759);
    final Color errColor = const Color(0xFFF5576C);
    final Color borderColor = ok ? okColor : errColor;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 1.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık satırı
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
                    'Örnek ${index + 1}',
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
            const SizedBox(height: 10),

            // x
            Text(
              'x = (${sample.x.map(fmt).join(', ')})',
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: Color(0xFF515154),
              ),
            ),
            const SizedBox(height: 4),

            // net / yhat
            Text(
              'z = ${fmt(sample.netInput)}   →   ŷ = ${sample.prediction}',
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: Color(0xFF515154),
              ),
            ),
            const SizedBox(height: 4),

            // gerçek y + durum
            Row(
              children: [
                Text(
                  'Gerçek y = ${sample.target}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1D1D1F),
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
                  ok ? '✅ Doğru sınıflandı' : '❌ Yanlış sınıflandı',
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
  }
}
