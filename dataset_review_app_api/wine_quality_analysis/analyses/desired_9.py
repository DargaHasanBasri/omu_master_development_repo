import seaborn as sns
import matplotlib.pyplot as plt
import io
import base64
from utils.helpers import print_separator

def analyze_desired_9(data):
    print_separator()
    print("9) Özniteliklere ait histogram grafikleri ve bunlara ait yorumlar ve değerlendirmeler\n")

    # Sadece nümerik sütunlar (quality hariç)
    numeric_columns = data.select_dtypes(include=['float64', 'int64']).columns
    numeric_columns = [col for col in numeric_columns if col != 'quality']

    # Histogramları PNG olarak belleğe al (base64 encode)
    images = []
    for col in numeric_columns:
        plt.figure(figsize=(6, 4))
        sns.histplot(data[col], kde=True, bins=20, color='skyblue')
        plt.title(f"{col} - Dağılım Grafiği")
        plt.xlabel(col)
        plt.ylabel("Frekans")

        buffer = io.BytesIO()
        plt.tight_layout()
        plt.savefig(buffer, format='png')
        buffer.seek(0)
        encoded_image = base64.b64encode(buffer.read()).decode('utf-8')
        images.append({
            "feature": col,
            "image_base64": encoded_image
        })
        plt.close()

    # Genel değerlendirme
    general_comment = (
        "- Histogram grafikleri özniteliklerin dağılım biçimlerini (örneğin normal, sağa/sola çarpık) göstermektedir.\n"
        "- 'alcohol' ve 'volatile acidity' gibi öznitelikler sağa çarpık bir dağılım göstermektedir.\n"
        "- 'density' ve 'fixed acidity' değişkenlerinde ise dağılım daha yoğun bir aralıkta toplanmıştır.\n"
        "- Bu dağılımlar, bazı özniteliklerin kalite sınıflarını ayırmada daha etkili olabileceğini göstermektedir."
    )

    print_separator()

    return {
        "steps": [
            {
                "title": "9) Özniteliklere ait histogram grafikleri",
                "content": images
            },
            {
                "title": "Genel Değerlendirme",
                "content": general_comment
            }
        ]
    }
