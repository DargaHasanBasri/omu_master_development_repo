import 'package:flutter/material.dart';

class OutlinedActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final Color? color;

  const OutlinedActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    // Dışarıdan renk verilmezse standart mavi temayı kullan
    final activeColor = color ?? const Color(0xFF2563EB);

    return SizedBox(
      width: double.infinity, // Butonun yatayda tüm alanı kaplaması için
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: activeColor, // Metin ve ikon rengi
          side: BorderSide(color: activeColor, width: 1.5), // Kenarlık rengi ve kalınlığı
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Diğer butonlarla uyumlu köşe
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 22),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}