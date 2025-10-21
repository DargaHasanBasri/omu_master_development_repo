import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

/// ****************************************************************************
/// [startBoardState] : Kullanıcı tarafından yerleştirilmiş tahtadaki sayıların (taşların)
/// sırasını listede tutan değişken.
/// [goalBoardState] : Hedeflenen sayıların tahtadaki (taşların) sırasını listede tutan değişken.
/// [size] : Tahtanın boyutunu tutan değişken.
/// [solutionFound] : Algoritmanın sonunda çözüm bulunup bulunmadığını tutan değişken.
/// [checkedNodes] : Algoritmanın kaç tane düğümü (state’i) kontrol ettiğini tutan değişken.
/// [isSolvableState] : Verilen başlangıç dizilişinin matematiksel olarak
/// çözülebilir olup olmadığını tutan değişken.
/// [solutionSteps] : Bulunan çözüm yolunu adım adım listede tutan değişken.
/// [visitedNodes] : A* araması boyunca denetlenen tüm state’leri listede tutan değişken.
/// ****************************************************************************

class AStarSolverServices {
  AStarSolverServices(this.startBoardState);

  final List<int?> startBoardState;
  final List<int?> goalBoardState = const [1, 2, 3, 4, 5, 6, 7, 8, null];
  static const int size = 3;

  bool solutionFound = false;
  int checkedNodes = 0;
  bool isSolvableState = true;
  List<List<int?>> solutionSteps = [];
  List<List<int?>> visitedNodes = [];

  /// Kullanıcı tarafından oluşturulmuş tahta durumunu hedeflenen tahta durumu
  /// ile aynı mı değil mi durumunu bool olarak tutan fonk.
  bool _isGoal(List<int?> currentBoardState) {
    return listEquals(currentBoardState, goalBoardState);
  }

  /// A* algoritmasında kullanılan heuristic tahmini maliyet-mesafe fonk.
  /// Fonk. int değer döndürür döndürülen değer, hedefe olan uzaklık mesafasini verir.
  /// [currentBoardState] : O anki tahtadaki sayıların dizilim durumunu tutan liste.
  /// [distance] :  Tüm taşların hedef pozisyonlarına olan toplam Manhattan mesafesini tutan değişken.
  int _heuristicCalculate(List<int?> currentBoardState) {
    int distance = 0;

    /// Tahtadaki her taş için distance değerini hesaplayan döngü.
    /// [currentValue] : O pozisyondaki taşın değerini tutan değişken.
    /// Eğer currentValue null ise yani boş kutu ise, bu hesaplamaya dahil edilmez.
    /// Çünkü bir değere sahip değil.
    /// [targetIndex] : O pozisyondaki taşın hedef tahtadaki indexini tutan değişken.
    /// [targetRow] : O pozisyondaki taşın hedef tahtadaki yatay konumunun indexini tutan değişken.
    /// [targetCol] : O pozisyondaki taşın hedef tahtadaki dikey konumunun indexini tutan değişken.
    /// [currentRow] : O pozisyondaki taşın o anki tahtadaki yatay konumunun indexini tutan değişken.
    /// [currentCol] : O pozisyondaki taşın o anki tahtadaki dikey konumunun indexini tutan değişken.
    for (int i = 0; i < currentBoardState.length; i++) {
      final currentValue = currentBoardState[i];
      if (currentValue == null) continue;
      final targetIndex = goalBoardState.indexOf(currentValue);

      /// currentValue'deki taşın hedef tahtadaki ve o anki tahtadaki,
      /// yatay ve dikeydeki indexi bulur. '~/' bölme işlemini int yapar.
      /// '%' modunu alır.
      final targetRow = targetIndex ~/ size;
      final targetCol = targetIndex % size;
      final currentRow = i ~/ size;
      final currentCol = i % size;

      /// [rowDistance] : O anki tahtadaki yatay konum ile hedef tahtadaki
      /// yatay konumu arasındaki farkı verir.
      /// [colDistance] : O anki tahtadaki dikey konum ile hedef tahtadaki
      /// dikey konumu arasındaki farkı verir.
      final rowDistance = currentRow - targetRow;
      final colDistance = currentCol - targetCol;

      /// [distance] : Taşın hedefe olan Manhattan uzaklığı verir.
      /// Bu işlem tüm taşlar için toplanır.
      distance += rowDistance.abs() + colDistance.abs();
    }

    /// Toplam tahmini maliyet döndürür. Tüm taşların hedefe olan toplam uzaklığını verir.
    /// Heuristic h(n) değer olarak kullanılır.
    return distance;
  }

  /// Verilen bir düğümün tüm olası bir sonraki durumlarını üretir.
  /// Komşu düğümleri üreten fonk.
  /// [_Node] Her düğümün temsil edildiği bir sınıf.
  /// Fonk. komşu düğümleri liste halinde döndürür.
  List<_Node> _generateNextStates(_Node node) {
    /// [neighbors] komşu düğümleri liste halinde tutan değişken.
    /// [currentState] Mevcut tahta dizilimi.
    /// [emptyIndex] boş kutunun index’ini tutan değişken.
    /// [row] - [col] boş kutunun yatay - dikey konumunu tutan değişkenler.
    final List<_Node> neighbors = [];
    final currentState = node.state;
    final emptyBoxIndex = currentState.indexOf(null);
    final rowEmptyBox = emptyBoxIndex ~/ size;
    final colEmptyBox = emptyBoxIndex % size;

    /// [directions] Olası yönler 4 yönlü hareket: sağ, aşağı, sol, yukarı
    const directions = [
      [0, 1], // sağ
      [1, 0], // aşağı
      [0, -1], // sol
      [-1, 0], // yukarı
    ];

    /// Boş kutunun hareketi : tüm yönleri dener.
    for (final direction in directions) {
      /// [newRow] boş kutunun sağa veya sola hareket ettiğindeki yeni row indexi.
      /// [newCol] boş kutunun aşağı veya yukarı hareket ettiğindeki yeni col indexi.
      final newRow = rowEmptyBox + direction[0];
      final newCol = colEmptyBox + direction[1];

      /// Eğer sınır dışına çıkıyorsa o yön geçersiz olur.
      if (newRow < 0 || newRow >= size || newCol < 0 || newCol >= size)
        continue;

      /// [newIndex] 2D koordinatı (row,col) tekrar 1D liste index’e çevirir.
      /// [newState] Mevcut durumun kopyasını tutan değişken.
      final newIndex = newRow * size + newCol;
      final newState = List<int?>.from(currentState);

      /// Boş kutu ile hedef kutunun yerini değiştirlir.
      newState[emptyBoxIndex] = newState[newIndex];

      /// Boş kutu yeni konuma taşınır.
      newState[newIndex] = null;

      /// Yeni düğüm oluşturulur.
      neighbors.add(
        _Node(
          state: newState,
          g: node.g + 1,
          h: _heuristicCalculate(newState),
          parent: node,
        ),
      );
    }

    /// Tüm komşu düğümleri döndürür.
    return neighbors;
  }

  /// Çözüme ulaşan düğümden başlayarak başlangıç durumuna kadar
  /// adım adım çözüm yolunu oluşturur ve liste olarak döndürür.
  List<List<int?>> _buildSolutionPath(_Node goalNode) {
    /// [solutionPath] Çözüme giden tüm adımları liste olarak tutan değişken.
    /// Her adım bir List<int?> tahtanın o anki durumu.
    final solutionPath = <List<int?>>[];

    /// Çözümün bulunduğu düğümden başlaanır, geriye doğru takip edilir.
    var currentNode = goalNode;

    /// [currentNode.parent != null] Başlangıç düğümüne gelene kadar ebeveynleri takip eder.
    while (currentNode.parent != null) {
      /// Mevcut düğümün durumunu path’in başına ekler.
      solutionPath.insert(0, currentNode.state);
      currentNode = currentNode.parent!;
    }

    /// Başlangıç durumunu path’in başına ekler.
    solutionPath.insert(0, startBoardState);

    /// Tüm adımları sıralı şekilde geri döner.
    return solutionPath;
  }

  /// Verilen tahta diziliminin çözülebilir olup olmadığını kontrol eden fonk.
  /// 8 taş probleminde inversion sayısına göre karar verilir.
  bool _checkIfBoardIsSolvable(List<int?> state) {
    /// null boş kutu hariç tüm sayıları alır, inversion hesaplamak için.
    /// Ters sıralı çiftlerin sayısını tutar.
    final numbersOnly = state.whereType<int>().toList();
    int inversionCount = 0;

    /// Her eleman için, sonraki elemanlarla karşılaştır.
    /// Eğer önceki sayı sonraki sayıdan büyükse bir inversion vardır, sayıyı artır.
    for (int i = 0; i < numbersOnly.length; i++) {
      for (int j = i + 1; j < numbersOnly.length; j++) {
        if (numbersOnly[i] > numbersOnly[j]) inversionCount++;
      }
    }

    /// 8 taş probleminde: inversion sayısı çiftse tahta çözülebilir, tekse çözülemez.
    /// True ise çözülür, false ise çözülemez.
    return inversionCount % 2 == 0;
  }

  Future<void> solve() async {
    /// Çözülebilirlik kontrolü
    /// Başlangıç tahtasının çözülebilir olup olmadığını kontrol eder
    isSolvableState = _checkIfBoardIsSolvable(startBoardState);
    if (!isSolvableState) {
      /// [solutionFound] çözüm olmadığını işaretler.
      /// Fonksiyon burada durur.
      solutionFound = false;
      return;
    }

    /// A* algoritmasında araştırılacak düğümleri tutar.
    /// PriorityQueue ile f = g + h değerine göre en küçük f değeri önce çıkarılır.
    final openSet = PriorityQueue<_Node>((a, b) => a.f.compareTo(b.f));

    /// Zaten kontrol edilmiş durumları saklar, tekrar işlemeyi engeller.
    final closedSet = <String>{};

    /// Başlangıç düğümü oluşturma
    final startNode = _Node(
      state: startBoardState,
      g: 0,
      h: _heuristicCalculate(startBoardState),
      parent: null,
    );

    /// Araştırmaya başlamak için başlangıç düğümünü ekler.
    openSet.add(startNode);

    /// Döngü devam ettiği sürece openSet boş olana kadar
    while (openSet.isNotEmpty) {
      /// f değeri en küçük düğüm
      final currentNode = openSet.removeFirst();

      /// Kaç düğüm denendi sayısını artırır.
      checkedNodes++;

      /// UI'da gezilen düğümleri göstermek için kopyasını saklar.
      visitedNodes.add(List<int?>.from(currentNode.state));

      /// Çözüm kontrolü
      /// Hedef durumla eşleşiyorsa
      if (_isGoal(currentNode.state)) {
        /// Çözüm bulundu.
        solutionFound = true;

        /// Çözüm yolunu geriye doğru takip edip adım adım listeyi oluşturur.
        solutionSteps = _buildSolutionPath(currentNode);

        /// Döngü ve fonksiyon durur, çözüm tamamlanır.
        return;
      }

      /// Mevcut düğüm artık işlenmiş sayılır ve tekrar kontrol edilmez.
      /// ile listeyi string’e çevirip set’e ekleriz, çünkü List tipi set’te direkt karşılaştırılamaz.
      closedSet.add(currentNode.state.toString());

      /// Boş kutuyu sağ/sol/yukarı/aşağı hareket ettirerek tüm olası yeni durumları üretir.
      for (final neighbor in _generateNextStates(currentNode)) {
        /// Eğer neighbor zaten closedSet’te varsa atlar.
        if (closedSet.contains(neighbor.state.toString())) continue;

        /// Aksi halde, openSet’e ekler.
        openSet.add(neighbor);
      }

      /// UI bloklanmasın diye küçük bir asenkron gecikme eklenir.
      await Future<void>.delayed(Duration.zero);
    }

    /// Eğer openSet boşaldı ama hedef bulunamadıysa çözüm yok demektir.
    solutionFound = false;
  }
}

class _Node {
  final List<int?> state; // Tahta durumunu temsil eder.
  final int g; // Başlangıç durumundan bu düğüme kadar geçen adım sayısıdır.
  final int h; // Heuristik değeri bu durumdan hedefe olan tahmini uzaklık.
  final _Node?
  parent; // Bu düğümün önceki düğümünü tutar. Çözüm bulunduğunda yolun adım adım geriye doğru çıkarılması için kullanılır.

  /// A* algoritmasının temel kuralı en küçük f değeri olan düğüm önce işlenir.
  int get f => g + h;

  _Node({
    required this.state,
    required this.g,
    required this.h,
    this.parent,
  });
}
