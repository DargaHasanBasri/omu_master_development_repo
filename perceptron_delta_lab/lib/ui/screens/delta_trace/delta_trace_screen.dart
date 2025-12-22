import 'package:go_router/go_router.dart';
import '../../../export.dart';
import '../../../viewmodel/delta_data_set/delta_data_set_table_cubit.dart';

class DeltaTraceScreen extends StatelessWidget {
  final DeltaTrace trace;

  const DeltaTraceScreen({super.key, required this.trace});

  String _fmt(double v) => v.toStringAsFixed(4);

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
          'Delta Eğitim İzleri',
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
          itemCount: trace.epochs.length + 1, // +1: en başa özet kartı
          itemBuilder: (context, idx) {
            if (idx == 0) {
              // ÖZET KARTI (en üstte)
              return _TraceSummaryCard(trace: trace, fmt: _fmt);
            }

            // Epoch Kartları
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
                  // Epoch Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
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
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.show_chart,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'MSE: ${_fmt(ep.mse)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Steps
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: ep.steps.map((st) {
                        final ok = st.eCls == 0;
                        return _DeltaStepCard(
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

class _TraceSummaryCard extends StatelessWidget {
  final DeltaTrace trace;
  final String Function(double) fmt;

  const _TraceSummaryCard({required this.trace, required this.fmt});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: trace.converged
              ? [
                  const Color(0xFF34C759).withOpacity(0.2),
                  const Color(0xFF30D158).withOpacity(0.1),
                ]
              : [
                  const Color(0xFFF5576C).withOpacity(0.2),
                  const Color(0xFFFF6B6B).withOpacity(0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: trace.converged
              ? const Color(0xFF34C759)
              : const Color(0xFFF5576C),
          width: 2,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                trace.converged
                    ? Icons.check_circle
                    : Icons.warning_amber_rounded,
                color: trace.converged
                    ? const Color(0xFF34C759)
                    : const Color(0xFFF5576C),
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  trace.converged
                      ? 'Yakınsama sağlandı: ${trace.totalEpochs} epoch'
                      : 'Yakınsama yok: ${trace.totalEpochs} epoch',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: trace.converged
                        ? const Color(0xFF34C759)
                        : const Color(0xFFF5576C),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Text(
                  'Son parametreler:',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF86868B),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'w=[${trace.finalW.map(fmt).join(', ')}], φ=${fmt(trace.finalPhi)}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'monospace',
                      color: Color(0xFF1D1D1F),
                    ),
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

class _DeltaStepCard extends StatefulWidget {
  final dynamic step;
  final bool isCorrect;
  final String Function(double) fmt;

  const _DeltaStepCard({
    required this.step,
    required this.isCorrect,
    required this.fmt,
  });

  @override
  State<_DeltaStepCard> createState() => _DeltaStepCardState();
}

class _DeltaStepCardState extends State<_DeltaStepCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final st = widget.step;
    final ok = widget.isCorrect;
    final borderColor = ok ? const Color(0xFF4FACFE) : const Color(0xFFF5576C);

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
                            colors: [Color(0xFF4FACFE), Color(0xFF00F2FE)],
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
                      'w=[${st.wBefore.map(widget.fmt).join(', ')}],  φ=${widget.fmt(st.phiBefore)}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'monospace',
                        color: Color(0xFF1D1D1F),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const _SectionTitle('Net (z):'),
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
                          'z = w·x + φ',
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'monospace',
                            color: Color(0xFF86868B),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'z = ${widget.fmt(st.z)}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4FACFE),
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  const _SectionTitle('Aktivasyon / Tahmin:'),
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
                        Text(
                          'f(z) = ${st.z >= 0 ? 1 : 0}',
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'monospace',
                            color: Color(0xFF1D1D1F),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'ŷ = ${st.yhat}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4FACFE),
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  const _SectionTitle('Hatalar:'),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: ok
                          ? const Color(0xFF34C759).withOpacity(0.1)
                          : const Color(0xFFF5576C).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _KeyValueLine(
                          label: 'Sınıflama hatası:',
                          valueSpan: TextSpan(
                            text: 'eCls = y − ŷ = ${st.eCls}',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: 'monospace',
                              color: ok
                                  ? const Color(0xFF34C759)
                                  : const Color(0xFFF5576C),
                            ),
                          ),
                          trailing: Icon(
                            ok ? Icons.check_circle : Icons.cancel,
                            color: ok
                                ? const Color(0xFF34C759)
                                : const Color(0xFFF5576C),
                            size: 20,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(height: 1),
                        const SizedBox(height: 8),
                        _KeyValueLine(
                          label: 'Sürekli hata (delta):',
                          valueSpan: TextSpan(
                            text: 'eCont = y − z = ${widget.fmt(st.eCont)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontFamily: 'monospace',
                              color: Color(0xFF4FACFE),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  const _SectionTitle('Güncelleme (Delta):'),
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
                              'w=[${st.wBefore.map(widget.fmt).join(', ')}]',
                          after:
                              'w\'=[${st.wAfter.map(widget.fmt).join(', ')}]',
                          hasChanged: st.eCls != 0,
                        ),
                        const SizedBox(height: 8),
                        _WeightUpdateRow(
                          label: 'φ',
                          before: 'φ=${widget.fmt(st.phiBefore)}',
                          after: 'φ\'=${widget.fmt(st.phiAfter)}',
                          hasChanged: st.eCls != 0,
                        ),
                      ],
                    ),
                  ),
                  if (st.eCls == 0) ...[
                    const SizedBox(height: 8),
                    const Center(
                      child: Text(
                        'ℹ️ Sınıflama hatası 0 olduğu için ağırlıklar değişmedi',
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
                '$label ← $label + η·eCont·x',
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

class _KeyValueLine extends StatelessWidget {
  final String label;
  final InlineSpan valueSpan;
  final Widget? trailing;

  const _KeyValueLine({
    required this.label,
    required this.valueSpan,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final isNarrow = c.maxWidth < 360; // dar ekranlar için kırılım
        final content = RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 13, color: Color(0xFF1D1D1F)),
            children: [
              const TextSpan(
                text: '• ',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              TextSpan(
                text: '$label ',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              valueSpan,
            ],
          ),
          softWrap: true,
        );

        if (isNarrow) {
          // Dar ekranda dikey diz
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              content,
              if (trailing != null) ...[const SizedBox(height: 6), trailing!],
            ],
          );
        }

        // Geniş ekranda sarabilen Wrap ile yatay diz
        return Wrap(
          spacing: 8,
          runSpacing: 6,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Expanded yerine Flexible boyutlanan bir kapsayıcı
            ConstrainedBox(
              constraints: const BoxConstraints(minWidth: 0, maxWidth: 1000),
              child: content,
            ),
            if (trailing != null) trailing!,
          ],
        );
      },
    );
  }
}
