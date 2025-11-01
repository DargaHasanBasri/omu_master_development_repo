def analyze_desired_4_5_6(data):
    """
    desired 4-5-6 analizleri:
    4) Veri kümesi içerisindeki örnek sayısı
    5) Eksik / boş / yanlış değer kontrolü
    6) Öznitelik sayısı ve veri tipi
    """

    # 4) Veri kümesi içerisindeki örnek sayısı
    num_samples = data.shape[0]
    sample_info = f"Veri kümesinde toplam {num_samples} örnek bulunmaktadır."

    # 5) Eksik / boş / yanlış değer kontrolü
    missing_values = data.isnull().sum().to_dict()
    total_missing = sum(missing_values.values())
    if total_missing == 0:
        missing_summary = "Veri kümesinde eksik değer bulunmamaktadır."
    else:
        missing_summary = f"Veri kümesinde toplam {total_missing} eksik değer bulunmaktadır."

    # 6) Öznitelik sayısı ve veri tipi
    num_features = data.shape[1]
    feature_info = {
        "toplam_oz_nitelik": num_features,
        "oz_nitelikler": {col: str(dtype) for col, dtype in data.dtypes.items()}
    }

    # 🔹 JSON formatında, başlıklarıyla birlikte dönelim:
    return {
        "steps": [
            {
                "title": "4) Veri kümesi içerisinde kaç tane örnek yer almaktadır?",
                "content": sample_info
            },
            {
                "title": "5) Veri kümesinde boş/eksik/yanlış değer var mı?",
                "content": {
                    "eksik_deger_sayisi": missing_values,
                    "ozet": missing_summary
                }
            },
            {
                "title": "6) Veri kümesinde kaç adet öznitelik vardır? Bu öznitelikler hangi yapıdadır?",
                "content": feature_info
            }
        ]
    }
