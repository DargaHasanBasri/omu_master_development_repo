import matplotlib
matplotlib.use('Agg')  # ✅ GUI backend devre dışı (server-safe)

import seaborn as sns
import matplotlib.pyplot as plt
import io
import base64
from utils.helpers import print_separator

def analyze_desired_11(data):
    """
    11) Çok sayıda iki farklı öznitelik ile Scatter plot grafikler çizimleri
        ve özniteliğin sınıf ayrımındaki rollerinin gösterilmesi, değerlendirilmesi.
    """

    print_separator()
    print("11) Scatter plot ile özniteliklerin kaliteye etkileri:\n")

    # --- Scatter plot oluşturulacak öznitelik çiftleri ---
    pairs = [
        ('alcohol', 'volatile acidity'),
        ('citric acid', 'pH'),
        ('residual sugar', 'density'),
        ('sulphates', 'alcohol'),
        ('chlorides', 'quality')
    ]

    scatter_images = []

    # --- Her bir öznitelik çifti için scatter plot oluştur ---
    for (x, y) in pairs:
        plt.figure(figsize=(6, 4))
        sns.scatterplot(
            x=data[x],
            y=data[y],
            hue=data['quality'],
            palette='viridis',
            alpha=0.7,
            s=40
        )
        plt.title(f"{x} - {y} Dağılımı (Kaliteye Göre Renklenmiş)", fontsize=12)
        plt.xlabel(x)
        plt.ylabel(y)
        plt.legend(title='Kalite', bbox_to_anchor=(1.05, 1), loc='upper left')
        plt.grid(True, linestyle='--', alpha=0.3)
        plt.tight_layout()

        # Görseli Base64 formatında belleğe al
        buf = io.BytesIO()
        plt.savefig(buf, format='png', bbox_inches='tight')
        plt.close()
        buf.seek(0)
        encoded_img = base64.b64encode(buf.read()).decode('utf-8')

        scatter_images.append({
            "x_feature": x,
            "y_feature": y,
            "image_base64": encoded_img
        })

    # --- Genel değerlendirme metni ---
    general_comment = (
        "- Alkol oranı arttıkça genellikle kalite sınıfı da artma eğilimindedir.\n"
        "- Volatile acidity yüksek olduğunda kalite düşme eğilimindedir.\n"
        "- pH ve citric acid arasında zıt bir ilişki gözlemlenebilir.\n"
        "- Density (yoğunluk) ile residual sugar (kalıntı şeker) arasında doğrusal bir ilişki vardır.\n"
        "- Renk ayrışması belirginse o öznitelik sınıf ayrımında güçlü rol oynar."
    )

    print_separator()

    # --- JSON formatında çıktı ---
    return {
        "steps": [
            {
                "title": "11) Öznitelik Çiftleri Arasındaki Scatter Plot Görselleri",
                "type": "image_list",
                "content": scatter_images
            },
            {
                "title": "Genel Değerlendirme",
                "type": "text",
                "content": general_comment
            }
        ]
    }
