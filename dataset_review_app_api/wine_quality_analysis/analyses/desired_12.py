import matplotlib
matplotlib.use('Agg')  # 🔹 GUI olmayan ortamlar için
import seaborn as sns
import matplotlib.pyplot as plt
import io
import base64

def analyze_desired_12(data):
    """
    12) Violinplot ile sınıf yoğunluklarının görselleştirilmesi
        (her öznitelik için ayrı violinplot + genel değerlendirme)
    """

    results = []
    numeric_columns = [
        'fixed acidity', 'volatile acidity', 'citric acid', 'residual sugar',
        'chlorides', 'free sulfur dioxide', 'total sulfur dioxide', 'density',
        'pH', 'sulphates', 'alcohol'
    ]

    # ==============================================
    # Her numeric sütun için violinplot görseli oluştur
    # ==============================================
    for col in numeric_columns:
        plt.figure(figsize=(7, 5))
        sns.violinplot(x='quality', y=col, data=data, palette='viridis', inner='quartile')
        plt.title(f"{col} Özelliğine Göre Kalite Sınıflarının Dağılımı")
        plt.xlabel("Kalite Sınıfı")
        plt.ylabel(col)

        # Görseli base64'e çevir
        buf = io.BytesIO()
        plt.savefig(buf, format='png', bbox_inches='tight')
        plt.close()
        buf.seek(0)
        img_base64 = base64.b64encode(buf.getvalue()).decode('utf-8')

        results.append({
            "title": f"12) {col} Özelliği - Violin Plot",
            "type": "image",
            "content": img_base64
        })

    # ==============================================
    # Genel metinsel değerlendirme
    # ==============================================
    general_comment = (
        "Violin plot grafikleri, her bir özniteliğin kalite sınıflarına göre "
        "yoğunluk dağılımını göstermektedir.\n"
        "- 'Alcohol', 'sulphates' ve 'citric acid' değişkenleri kaliteyle güçlü ilişki gösterir.\n"
        "- 'Volatile acidity' düşük olduğunda daha yüksek kalite sınıfları öne çıkar.\n"
        "- 'Density' ve 'residual sugar' değişkenlerinde sınıflar arası fark daha az belirgindir.\n"
        "- Bu analiz, özniteliklerin kalite tahminindeki önem sırasını sezgisel olarak anlamamıza yardımcı olur."
    )

    results.append({
        "title": "12) Genel Değerlendirme",
        "type": "text",
        "content": general_comment
    })

    return {"steps": results}
