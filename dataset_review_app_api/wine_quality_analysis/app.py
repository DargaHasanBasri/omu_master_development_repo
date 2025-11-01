from flask import Flask, request, jsonify
import pandas as pd
from analyses.desired_1_2_3 import analyze_desired_1_2_3
from analyses.desired_4_5_6 import analyze_desired_4_5_6
from analyses.desired_7 import analyze_desired_7
from analyses.desired_8 import analyze_desired_8 
from analyses.desired_9 import analyze_desired_9

app = Flask(__name__)

@app.route('/')
def index():
    return "Wine Quality Analysis API is running!"


# ======================================================
#  desired_1_2_3
# ======================================================
@app.route('/desired_1_2_3', methods=['POST'])
def desired_1_2_3():
    if 'file' not in request.files:
        return jsonify({"error": "Dosya bulunamadı"}), 400
    file = request.files['file']
    try:
        df = pd.read_csv(file, sep=';')
        result = analyze_desired_1_2_3(df)
        return jsonify({
            "message": "Desired 1-2-3 analizi tamamlandı.",
            "results": result
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ======================================================
#  desired_4_5_6
# ======================================================
@app.route('/desired_4_5_6', methods=['POST'])
def desired_4_5_6():
    if 'file' not in request.files:
        return jsonify({"error": "Dosya bulunamadı"}), 400
    file = request.files['file']
    try:
        df = pd.read_csv(file, sep=';')
        result = analyze_desired_4_5_6(df)
        return jsonify({
            "message": "Desired 4-5-6 analizi tamamlandı.",
            "results": result
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ======================================================
#  desired_7
# ======================================================
@app.route('/desired_7', methods=['POST'])
def desired_7():
    if 'file' not in request.files:
        return jsonify({"error": "Dosya bulunamadı"}), 400
    file = request.files['file']
    try:
        df = pd.read_csv(file, sep=';')
        result = analyze_desired_7(df)
        return jsonify({
            "message": "Desired 7 analizi tamamlandı.",
            "results": result
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ======================================================
#  ✅ desired_8 — Box Plot Analizi 
# ======================================================
@app.route('/desired_8', methods=['POST'])
def desired_8():
    if 'file' not in request.files:
        return jsonify({"error": "Dosya bulunamadı"}), 400
    file = request.files['file']
    try:
        df = pd.read_csv(file, sep=';')
        result = analyze_desired_8(df)
        return jsonify({
            "message": "Desired 8 analizi tamamlandı.",
            "results": result
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500


# ======================================================
#  ✅ desired_9 — Histogram grafikleri Analizi
# ======================================================

@app.route('/desired_9', methods=['POST'])
def desired_9():
    if 'file' not in request.files:
        return jsonify({"error": "Dosya bulunamadı"}), 400

    file = request.files['file']
    try:
        df = pd.read_csv(file, sep=';')
        result = analyze_desired_9(df)
        return jsonify({
            "message": "Desired 9 analizi tamamlandı.",
            "results": result
        })
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# ======================================================
#  Uygulama başlatma
# ======================================================
if __name__ == '__main__':
    app.run(debug=True)
