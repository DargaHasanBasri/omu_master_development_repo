import 'package:flutter/material.dart';

class PerformanceMetricsCard extends StatelessWidget {
  final int totalIterations;
  final int processTimeMs;

  const PerformanceMetricsCard({
    super.key,
    required this.totalIterations,
    required this.processTimeMs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E7EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. BAŞLIK VE İKON
          Row(
            children: [
              const Icon(
                Icons.insert_chart_outlined_rounded, // Görseldekine çok benzeyen grafik ikonu
                color: Color(0xFF2563EB), // Canlı mavi
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Performance Metrics',
                style: TextStyle(
                  color: Color(0xFF101828), // Koyu siyah/lacivert
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // 2. METRİKLER (İterasyon ve Süre)
          // IntrinsicHeight, içindeki en uzun elemanın boyunu alıp diğerlerini ona eşitler (Divider için gerekli)
          IntrinsicHeight(
            child: Row(
              children: [
                // Sol Sütun: Total Iterations
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        totalIterations.toString(),
                        style: const TextStyle(
                          color: Color(0xFF101828),
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Total Iterations',
                        style: TextStyle(
                          color: Color(0xFF64748B), // blueGrey tonu
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // Orta Ayırıcı Çizgi
                const VerticalDivider(
                  color: Color(0xFFE2E8F0),
                  thickness: 1,
                  width: 32, // Sağ ve sol sütunlar arası toplam boşluk
                ),

                // Sağ Sütun: Process Time
                Expanded(
                  child: Column(
                    children: [
                      // Sayı ve 'ms' birimini yan yana ve alt çizgiden hizalı yazmak için Row kullanıyoruz
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            processTimeMs.toString(),
                            style: const TextStyle(
                              color: Color(0xFF101828),
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            'ms',
                            style: TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Process Time',
                        style: TextStyle(
                          color: Color(0xFF64748B),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // 3. ALT İLERLEME ÇUBUĞU (Progress Bar)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Initial Interval',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Convergence',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Çubuk tamamen dolu olduğu için basit bir Container işimizi görür
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB), // Çubuk rengi mavi
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }
}