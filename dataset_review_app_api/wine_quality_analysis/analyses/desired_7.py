import seaborn as sns
import matplotlib.pyplot as plt
import io
import base64

def analyze_desired_7(data):
    """
    desired 7 analizleri:
    7) Temel istatistiksel özellikler + korelasyon matrisi + görselleştirme
    """

    results = []

    # ===============================
    # 7.1) Temel istatistiksel özellikler
    # ===============================
    numeric_data = data.select_dtypes(include=['float64', 'int64'])
    stats = numeric_data.describe().T

    # Temel istatistikleri JSON formatına dönüştür
    stats_json = {}
    for col in stats.index:
        stats_json[col] = {
            "Ortalama": round(stats.loc[col, "mean"], 3),
            "Std Sapma": round(stats.loc[col, "std"], 3),
            "Min": round(stats.loc[col, "min"], 3),
            "1. Çeyrek": round(stats.loc[col, "25%"], 3),
            "Medyan": round(stats.loc[col, "50%"], 3),
            "3. Çeyrek": round(stats.loc[col, "75%"], 3),
            "Max": round(stats.loc[col, "max"], 3)
        }

    results.append({
        "title": "7) Temel istatistiksel özellikler",
        "type": "table",
        "content": stats_json
    })

    # ===============================
    # 7.2) Korelasyon matrisi
    # ===============================
    corr = numeric_data.corr().round(3)
    corr_json = corr.to_dict()

    results.append({
        "title": "7.1) Öznitelikler arasındaki korelasyon matrisi",
        "type": "table",
        "content": corr_json
    })

    # ===============================
    # 7.3) Korelasyon görselleştirmesi (heatmap)
    # ===============================
    plt.figure(figsize=(10, 8))
    sns.heatmap(corr, annot=True, fmt=".2f", cmap='coolwarm')
    plt.title("Öznitelikler Arası Korelasyon Matrisi")

    # Görseli base64 string'e çevir
    img_buf = io.BytesIO()
    plt.savefig(img_buf, format='png', bbox_inches='tight')
    plt.close()
    img_buf.seek(0)
    img_base64 = base64.b64encode(img_buf.getvalue()).decode('utf-8')

    results.append({
        "title": "7.2) Öznitelikler Arası Korelasyon Matrisi Görselleştirmesi",
        "type": "image",
        "content": img_base64
    })

    return {"steps": results}
