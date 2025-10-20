import 'package:collection/collection.dart';

class AStarSolver {
  final List<int?> startState;
  final List<int?> goalState = const [1, 2, 3, 4, 5, 6, 7, 8, null];

  static const int size = 3;

  bool solutionFound = false;
  int checkedNodes = 0;
  List<List<int?>> solutionSteps = [];
  bool isSolvableState = true;

  AStarSolver(this.startState);

  Future<void> solve() async {
    isSolvableState = _isSolvable(startState);

    if (!isSolvableState) {
      solutionFound = false;
      return;
    }

    final openSet = PriorityQueue<_Node>((a, b) => a.f.compareTo(b.f));
    final closedSet = <String>{};

    final startNode = _Node(
      state: startState,
      g: 0,
      h: _heuristic(startState),
      parent: null,
    );

    openSet.add(startNode);

    while (openSet.isNotEmpty) {
      final current = openSet.removeFirst();
      checkedNodes++;

      if (_isGoal(current.state)) {
        solutionFound = true;
        solutionSteps = _reconstructPath(current);
        return;
      }

      closedSet.add(current.state.toString());

      for (final neighbor in _getNeighbors(current)) {
        if (closedSet.contains(neighbor.state.toString())) continue;
        openSet.add(neighbor);
      }

      await Future<void>.delayed(Duration.zero);
    }

    solutionFound = false;
  }

  bool _isGoal(List<int?> state) => state.toString() == goalState.toString();

  int _heuristic(List<int?> state) {
    int distance = 0;
    for (int i = 0; i < state.length; i++) {
      final value = state[i];
      if (value == null) continue;

      final targetIndex = goalState.indexOf(value);
      final currentRow = i ~/ size;
      final currentCol = i % size;
      final targetRow = targetIndex ~/ size;
      final targetCol = targetIndex % size;

      distance +=
          (currentRow - targetRow).abs() + (currentCol - targetCol).abs();
    }
    return distance;
  }

  List<_Node> _getNeighbors(_Node node) {
    final List<_Node> neighbors = [];
    final state = node.state;
    final emptyIndex = state.indexOf(null);
    final row = emptyIndex ~/ size;
    final col = emptyIndex % size;

    const directions = [
      [0, 1],
      [1, 0],
      [0, -1],
      [-1, 0],
    ];

    for (final dir in directions) {
      final newRow = row + dir[0];
      final newCol = col + dir[1];
      if (newRow < 0 || newRow >= size || newCol < 0 || newCol >= size)
        continue;

      final newIndex = newRow * size + newCol;
      final newState = List<int?>.from(state);
      newState[emptyIndex] = newState[newIndex];
      newState[newIndex] = null;

      neighbors.add(
        _Node(
          state: newState,
          g: node.g + 1,
          h: _heuristic(newState),
          parent: node,
        ),
      );
    }

    return neighbors;
  }

  List<List<int?>> _reconstructPath(_Node node) {
    final path = <List<int?>>[];
    var current = node;
    while (current.parent != null) {
      path.insert(0, current.state);
      current = current.parent!;
    }
    path.insert(0, startState);
    return path;
  }

  bool _isSolvable(List<int?> state) {
    final flattened = state.whereType<int>().toList();
    int inversions = 0;

    for (int i = 0; i < flattened.length; i++) {
      for (int j = i + 1; j < flattened.length; j++) {
        if (flattened[i] > flattened[j]) inversions++;
      }
    }

    return inversions % 2 == 0;
  }
}

class _Node {
  final List<int?> state;
  final int g;
  final int h;
  final _Node? parent;

  int get f => g + h;

  _Node({
    required this.state,
    required this.g,
    required this.h,
    this.parent,
  });
}
