import seaborn as sns
import matplotlib.pyplot as plt
import io
import base64

def analyze_desired_8(data):
    """
    8) Box plot grafikler ile özniteliklere ait yorumlar ve değerlendirmeler.
    Her öznitelik için ayrı bir boxplot oluşturur.
    """

    results = []
    numeric_columns = data.select_dtypes(include=['float64', 'int64']).columns
    numeric_columns = [col for col in numeric_columns if col != 'quality']  # sınıfı hariç tut

    # ============================================
    # Her öznitelik için ayrı boxplot
    # ============================================
    for col in numeric_columns:
        plt.figure(figsize=(6, 4))
        sns.boxplot(x='quality', y=col, data=data, palette='viridis')
        plt.title(f"{col} - Kaliteye Göre Dağılım")
        plt.xlabel("Kalite")
        plt.ylabel(col)

        # Görseli base64'e çevir
        buf = io.BytesIO()
        plt.savefig(buf, format='png', bbox_inches='tight')
        plt.close()
        buf.seek(0)
        img_base64 = base64.b64encode(buf.getvalue()).decode('utf-8')

        results.append({
            "title": f"8) {col} Değişkeni - Box Plot",
            "type": "image",
            "content": img_base64
        })

    # ============================================
    # Genel yorum (metinsel içerik)
    # ============================================
    general_comment = (
        "Box plot grafikleri, her öznitelik için aykırı değerlerin ve kaliteye göre dağılımın analizini sağlar.\n"
        "- Özellikle 'volatile acidity' ve 'residual sugar' değişkenlerinde belirgin aykırı değerler bulunmaktadır.\n"
        "- 'alcohol' ve 'citric acid' değişkenleri kalite ile pozitif bir ilişki göstermektedir.\n"
        "- Kalite arttıkça alkol oranının arttığı, asiditenin azaldığı gözlemlenmektedir.\n"
        "- Bu gözlemler 14. adımda sınıflandırma performansını etkileyen önemli ipuçları verebilir."
    )

    results.append({
        "title": "8) Genel Değerlendirme",
        "type": "text",
        "content": general_comment
    })

    return {"steps": results}
