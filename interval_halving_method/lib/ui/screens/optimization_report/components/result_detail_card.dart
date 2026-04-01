import 'package:flutter/material.dart';

class ResultDetailCard extends StatelessWidget {
  final String title;
  final String value;
  final Color valueColor;
  final String subtitleText;
  final Color subtitleColor;
  final IconData? subtitleIcon;

  const ResultDetailCard({
    super.key,
    required this.title,
    required this.value,
    required this.valueColor,
    required this.subtitleText,
    required this.subtitleColor,
    this.subtitleIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), // Kartlar arası boşluk
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E7EC)), // Hafif gri kenarlık
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      // Arka plandaki dairesel şeklin kart dışına taşmasını engellemek için ClipRRect kullanıyoruz
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // 1. Sağ Üst Köşedeki Dekoratif Açık Mavi Daire
            Positioned(
              top: -40,
              right: -40,
              child: Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: Color(0xFFF0F6FF), // Çok açık uçuk mavi
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // 2. Kartın Asıl İçeriği
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Başlık
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF64748B), // blueGrey tonu
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Ana Değer (X* veya F(X*))
                  Text(
                    value,
                    style: TextStyle(
                      color: valueColor,
                      fontSize: 36,
                      fontFamily: 'monospace', // Sayıların daktilo fontuyla şık durması için
                      fontWeight: FontWeight.w900, // Black / Extra Bold
                      letterSpacing: -0.5,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Alt Açıklama (İkonlu veya İkonsuz)
                  Row(
                    // İkon ve metin alt satıra inerse üstten hizalı kalsınlar
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (subtitleIcon != null) ...[
                        Padding(
                          // Metinle ikonun hizasını görsel olarak eşitlemek için ufak bir padding
                          padding: const EdgeInsets.only(top: 2.0),
                          child: Icon(
                            subtitleIcon,
                            color: subtitleColor,
                            size: 16,
                          ),
                        ),
                        const SizedBox(width: 4),
                      ],
                      // TAŞMAYI ÖNLEYEN EXPANDED
                      Expanded(
                        child: Text(
                          subtitleText,
                          style: TextStyle(
                            color: subtitleColor,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                          // Çok uzun denklemlerde 3 satıra kadar izin ver, sonra ... koy
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}