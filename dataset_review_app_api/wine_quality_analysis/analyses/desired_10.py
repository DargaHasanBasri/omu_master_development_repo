import matplotlib
matplotlib.use('Agg')  # ✅ GUI backend devre dışı — thread-safe hale getirir

import seaborn as sns
import matplotlib.pyplot as plt
import io
import base64
from utils.helpers import print_separator


def analyze_desired_10(data):
    """
    10) Scatter plot grafikler ile veri kümesinin dağılımı ve görselleştirilmesi.
    Flask içinde güvenli şekilde çalışır (GUI backend kullanılmaz).
    """
    print_separator()
    print("10) Scatter plot grafikler ile veri kümesinin dağılımı ve görselleştirilmesi\n")

    # Scatter plot için önemli öznitelik çiftleri
    important_pairs = [
        ('alcohol', 'quality'),
        ('density', 'alcohol'),
        ('pH', 'citric acid'),
        ('volatile acidity', 'quality')
    ]

    scatter_images = []

    # Her scatter plot'u ayrı ayrı çiz ve base64 olarak kaydet
    for (x, y) in important_pairs:
        plt.figure(figsize=(6, 4))
        sns.scatterplot(
            x=data[x],
            y=data[y],
            hue=data['quality'],
            palette='viridis',
            alpha=0.6,
            edgecolor=None
        )
        plt.title(f"{x} ile {y} Arasındaki Dağılım")
        plt.xlabel(x)
        plt.ylabel(y)
        plt.grid(True, linestyle='--', alpha=0.3)
        plt.legend(title='Kalite', bbox_to_anchor=(1.05, 1), loc='upper left')

        # Görseli belleğe kaydet
        buffer = io.BytesIO()
        plt.tight_layout()
        plt.savefig(buffer, format='png')
        buffer.seek(0)
        encoded_img = base64.b64encode(buffer.read()).decode('utf-8')

        # 🔒 Bellek temizliği (önemli!)
        plt.close('all')

        scatter_images.append({
            "x_feature": x,
            "y_feature": y,
            "image_base64": encoded_img
        })

    # Genel değerlendirme
    comment = (
        "- Scatter plot grafikleri iki değişken arasındaki ilişkiyi gösterir.\n"
        "- Noktalar çizgi boyunca diziliyorsa bu değişkenler arasında doğrusal bir ilişki olabilir.\n"
        "- Noktalar rastgele dağılmışsa güçlü bir ilişki yoktur.\n"
        "- Yoğun bölgeler kümelenmeyi gösterebilir.\n"
        "- Özellikle 'alcohol' ve 'quality' arasında pozitif bir ilişki gözlemlenebilir."
    )

    print_separator()

    return {
        "steps": [
            {
                "title": "10) Öznitelikler Arasındaki Scatter Plot Görselleri",
                "content": scatter_images
            },
            {
                "title": "Genel Değerlendirme",
                "content": comment
            }
        ]
    }
