import '../export.dart';

class HowToPlayText extends StatelessWidget {
  const HowToPlayText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "🧩 ${LocaleKeys.howToPlay_title.locale}",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: ColorName.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _buildRuleItem(
          "1️⃣",
          LocaleKeys.howToPlay_messageOne.locale,
        ),
        _buildRuleItem(
          "2️⃣",
          LocaleKeys.howToPlay_messageTwo.locale,
        ),
        _buildRuleItem(
          "3️⃣",
          LocaleKeys.howToPlay_messageThree.locale,
        ),
        _buildRuleItem(
          "4️⃣",
          LocaleKeys.howToPlay_messageFour.locale,
        ),
        _buildRuleItem(
          "5️⃣",
          LocaleKeys.howToPlay_messageFive.locale,
        ),
        _buildRuleItem(
          "6️⃣",
          LocaleKeys.howToPlay_messageSix.locale,
        ),
        _buildRuleItem(
          "7️⃣",
          LocaleKeys.howToPlay_messageSeven.locale,
        ),
      ],
    );
  }

  Widget _buildRuleItem(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(icon, style: const TextStyle(color: Colors.white)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
