import 'package:go_router/go_router.dart';
import 'package:perceptron_delta_lab/viewmodel/data_set/data_set_table_cubit.dart';
import '../../../export.dart';

class PerceptronTraceScreen extends StatelessWidget {
  final PerceptronTrace trace;

  const PerceptronTraceScreen({super.key, required this.trace});

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
          'Perceptron Eğitim İzleri',
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
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: trace.epochs.length + 1,
          itemBuilder: (context, idx) {
            if (idx == 0) {
              return _TraceSummaryCard(trace: trace, fmt: _fmt);
            }

            final ep = trace.epochs[idx - 1];
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
                        const Icon(
                          Icons.insights,
                          color: Colors.white,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Epoch $idx',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Spacer(),
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
                            'Doğruluk: ${(ep.accuracy * 100).toStringAsFixed(0)}%',
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

                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: ep.steps.map((st) {
                        final ok = st.error == 0; // <-- yeni isim
                        return _StepExpansionCard(
                          step: st,
                          isCorrect: ok,
                          fmt: _fmt,
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/* --------------------------- Özet Kartı (en üst) --------------------------- */

class _TraceSummaryCard extends StatelessWidget {
  final PerceptronTrace trace;
  final String Function(double) fmt;

  const _TraceSummaryCard({required this.trace, required this.fmt});

  @override
  Widget build(BuildContext context) {
    final bool ok = trace.converged;
    final Color okColor = const Color(0xFF34C759);
    final Color errColor = const Color(0xFFF5576C);

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
                  ok ? Icons.check_circle : Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    ok
                        ? 'Yakınsama sağlandı: ${trace.totalEpochs} epoch'
                        : 'Yakınsama yok: ${trace.totalEpochs} epoch',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  trace.converged
                      ? 'Yakınsama sağlandı: ${trace.totalEpochs} epoch'
                      : 'Yakınsama yok: ${trace.totalEpochs} epoch',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: ok ? okColor : errColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Son w = [${trace.finalWeights.map((v) => v.toStringAsFixed(1)).join(', ')}],  w₀ = ${fmt(trace.finalBiasWeight..toStringAsFixed(1))}',
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
    );
  }
}

/* -------------------------- Adım Kartı (expandable) ------------------------ */

class _StepExpansionCard extends StatefulWidget {
  final StepTrace step; // dynamic yerine StepTrace
  final bool isCorrect;
  final String Function(double) fmt;

  const _StepExpansionCard({
    required this.step,
    required this.isCorrect,
    required this.fmt,
  });

  @override
  State<_StepExpansionCard> createState() => _StepExpansionCardState();
}

class _StepExpansionCardState extends State<_StepExpansionCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final st = widget.step;
    final ok = widget.isCorrect;
    final borderColor = ok ? const Color(0xFF667EEA) : const Color(0xFFF5576C);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor, width: 2),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          'Adım ${st.step}',
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
                          color: ok
                              ? const Color(0xFF34C759)
                              : const Color(0xFFF5576C),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    label: 'Veri:',
                    value:
                    '(${st.x.map(widget.fmt).join(', ')})  |  Gerçek: ${st.y}',
                  ),
                ],
              ),
            ),
          ),

          if (_isExpanded) ...[
            Container(
              width: double.infinity,
              height: 1,
              color: const Color(0xFFE5E5EA),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionTitle('Başlangıç:'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'w=[${st.weightsBefore.map(widget.fmt).join(', ')}],  w₀=${widget.fmt(st.biasBefore)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'monospace',
                        color: Color(0xFF1D1D1F),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const _SectionTitle('Hesaplama:'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'z = w·x + w₀',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                            color: Color(0xFF86868B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'z = ${widget.fmt(st.netInput)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF667EEA),
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  const _SectionTitle('Aktivasyon:'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'f(z) = ${st.netInput >= 0 ? 1 : 0}  (z ${st.netInput >= 0 ? '≥' : '<'} 0)',
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'monospace',
                        color: Color(0xFF1D1D1F),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const _SectionTitle('Tahmin:'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ok
                          ? const Color(0xFF34C759).withOpacity(0.1)
                          : const Color(0xFFF5576C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 6,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          '${st.yhat}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: ok
                                ? const Color(0xFF34C759)
                                : const Color(0xFFF5576C),
                          ),
                        ),
                        const Text(
                          '|',
                          style: TextStyle(color: Color(0xFF86868B)),
                        ),
                        Text(
                          'Gerçek: ${st.y}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          '→',
                          style: TextStyle(color: Color(0xFF86868B)),
                        ),
                        Text(
                          'e = ${st.error}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ok
                                ? const Color(0xFF34C759)
                                : const Color(0xFFF5576C),
                          ),
                        ),
                        Icon(
                          ok ? Icons.check_circle : Icons.cancel,
                          color: ok
                              ? const Color(0xFF34C759)
                              : const Color(0xFFF5576C),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  const _SectionTitle('Güncelleme (η ile):'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _WeightUpdateRow(
                          label: 'w',
                          before:
                          'w=[${st.weightsBefore.map(widget.fmt).join(', ')}]',
                          after:
                          'w\'=[${st.weightsAfter.map(widget.fmt).join(', ')}]',
                          hasChanged: st.error != 0,
                        ),
                        const SizedBox(height: 8),
                        _WeightUpdateRow(
                          label: 'w₀',
                          before: 'w₀=${widget.fmt(st.biasBefore)}',
                          after: 'w₀\'=${widget.fmt(st.biasAfter)}',
                          hasChanged: st.error != 0,
                        ),
                      ],
                    ),
                  ),
                  if (st.error == 0) ...[
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'ℹ️ Hata 0 olduğu için ağırlıklar değişmedi',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF86868B),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D1D1F),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF515154),
              fontFamily: 'monospace',
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF1D1D1F),
      ),
    );
  }
}

class _WeightUpdateRow extends StatelessWidget {
  final String label;
  final String before;
  final String after;
  final bool hasChanged;

  const _WeightUpdateRow({
    required this.label,
    required this.before,
    required this.after,
    required this.hasChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '$label ← $label + η·e·x',
                style: const TextStyle(fontSize: 11, color: Color(0xFF86868B)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: Text(
                  before,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: hasChanged
                        ? const Color(0xFFF5576C)
                        : const Color(0xFF1D1D1F),
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Icon(
                  Icons.arrow_forward,
                  size: 16,
                  color: Color(0xFF86868B),
                ),
              ),
              Expanded(
                child: Text(
                  after,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: hasChanged
                        ? const Color(0xFF34C759)
                        : const Color(0xFF1D1D1F),
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
