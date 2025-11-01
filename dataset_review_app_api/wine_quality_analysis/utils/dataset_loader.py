import pandas as pd

def load_wine_data(file_path):
    """Veri kümesini CSV dosyasından okur ve döndürür."""
    data = pd.read_csv(file_path, sep=';')
    return data
