import seaborn as sns
import matplotlib.pyplot as plt
import io
import base64

def analyze_desired_1_2_3(data):
    # 1) Veri kümesinin ilk 5 satırı
    head_data = data.head().to_dict(orient='records')

    # 2) Veri kümesi bilgisi
    info_dict = {
        "rows": data.shape[0],
        "columns": data.shape[1],
        "dtypes": {col: str(dtype) for col, dtype in data.dtypes.items()}
    }

    # 3) Eksik veri sayısı
    missing_values = data.isnull().sum().to_dict()

    # 4) Sınıf (quality) dağılımı
    class_distribution = data['quality'].value_counts().sort_index().to_dict()

    # 5) Veri kümesi ne zaman ve hangi çalışma kapsamında oluşturulmuştur?
    dataset_description = (
        "Bu veri seti UCI Machine Learning Repository'den alınmıştır ve "
        "Portekiz'deki Vinho Verde şarapları üzerinde yapılan bir çalışmadan derlenmiştir. "
        "(Cortez et al., 2009)"
    )

    # 6) Veri kümesi kaç sınıftan oluşmaktadır?
    num_classes = data['quality'].nunique()
    classes = sorted(int(x) for x in data['quality'].unique())
    class_info = f"Veri kümesinde {num_classes} farklı kalite sınıfı vardır: {classes}"

    # 7) Veri kümesi dağılımı nasıldır?
    counts = data['quality'].value_counts().sort_index()
    sorted_counts = counts.sort_values()
    min_classes = sorted_counts.index[:2].tolist()
    min_counts = [int(x) for x in sorted_counts.iloc[:2].values]
    max_classes = sorted_counts.index[-2:].tolist()
    max_counts = [int(x) for x in sorted_counts.iloc[-2:].values]
    distribution_comment = (
        f"Dağılım dengesizdir; en az örnek: {list(zip(min_classes, min_counts))}, "
        f"en çok örnek: {list(zip(max_classes, max_counts))}."
    )

    # Grafik (countplot)
    plt.figure(figsize=(8,5))
    sns.countplot(x='quality', data=data, palette='viridis')
    plt.title("Şarap Kalite Dağılımı")
    plt.xlabel("Kalite Sınıfı")
    plt.ylabel("Adet")

    img_bytes = io.BytesIO()
    plt.savefig(img_bytes, format='png', bbox_inches='tight')
    plt.close()
    img_bytes.seek(0)
    img_base64 = base64.b64encode(img_bytes.read()).decode('utf-8')

    # 🔹 JSON formatında, başlıklarla birlikte dönelim:
    return {
        "steps": [
            {
                "title": "1-> Veri kümesinin ilk 5 satırı:",
                "content": head_data
            },
            {
                "title": "2-> Veri kümesi bilgisi:",
                "content": info_dict
            },
            {
                "title": "3-> Eksik veri sayısı:",
                "content": missing_values
            },
            {
                "title": "4-> Sınıf (quality) dağılımı:",
                "content": class_distribution
            },
            {
                "title": "1) Veri kümesi ne zaman ve hangi çalışma kapsamında oluşturulmuştur?",
                "content": dataset_description
            },
            {
                "title": "2) Veri kümesi kaç sınıftan oluşmaktadır?",
                "content": class_info
            },
            {
                "title": "3) Veri kümesi dağılımı nasıldır?",
                "content": {
                    "distribution": counts.to_dict(),
                    "comment": distribution_comment
                }
            }
        ],
        "plot_image_base64": img_base64
    }
