import 'package:flutter/foundation.dart';
import '../models/cell_model.dart';

class GameLogic extends ChangeNotifier {
  static const int gridSize = 5;

  late List<List<CellModel>> grid;
  CardValue selectedCard = CardValue.one;
  int score = 0;
  int? lastRow;
  int? lastCol;

  List<List<CellModel>>? _previousGrid;
  int? _previousScore;
  Map<CardValue, int>? _previousRemainingCards;
  bool canUndo = false;

  final Map<CardValue, int> remainingCards = {
    CardValue.one: 7,
    CardValue.two: 4,
    CardValue.three: 5,
    CardValue.four: 5,
    CardValue.five: 3,
    CardValue.king: 1,
  };

  int get openedCount {
    int count = 0;
    for (var row in grid) {
      for (var cell in row) {
        if (cell.state == CellState.opened) count++;
      }
    }
    return count;
  }

  int get remainingFive => remainingCards[CardValue.five] ?? 0;
  int get remainingKing => remainingCards[CardValue.king] ?? 0;

  GameLogic() {
    _initGrid();
  }

  void _initGrid() {
    grid = List.generate(
      gridSize,
      (r) => List.generate(gridSize, (c) => CellModel(row: r, col: c)),
    );
  }

  void _saveState() {
    _previousGrid = List.generate(
      gridSize,
      (r) => List.generate(
        gridSize,
        (c) => CellModel(
          row: r,
          col: c,
          state: grid[r][c].state,
          value: grid[r][c].value,
        ),
      ),
    );
    _previousScore = score;
    _previousRemainingCards = Map.from(remainingCards);
    canUndo = true;
  }

  void undo() {
    if (!canUndo || _previousGrid == null) return;
    grid = _previousGrid!;
    score = _previousScore!;
    remainingCards.addAll(_previousRemainingCards!);
    canUndo = false;
    lastRow = null;
    lastCol = null;
    _previousGrid = null;
    _previousScore = null;
    _previousRemainingCards = null;
    notifyListeners();
  }

  void selectCard(CardValue card) {
    selectedCard = card;
    notifyListeners();
  }

  bool canPlaceCard(CardValue card) {
    return (remainingCards[card] ?? 0) > 0;
  }

  void onCellTap(int row, int col) {
    final cell = grid[row][col];
    if (cell.state == CellState.opened) return;

    _saveState();

    cell.value = selectedCard;
    cell.state = CellState.opened;
    score += selectedCard.points;
    remainingCards[selectedCard] = remainingCards[selectedCard]! - 1;
    lastRow = row;
    lastCol = col;

    notifyListeners();
  }

  void markNeighborsDangerous(int row, int col) {
    _updateNeighbors(row, col, mode: 'dangerous');
    notifyListeners();
  }

  void markNeighborsSafe(int row, int col) {
    _updateNeighbors(row, col, mode: 'safe');
    notifyListeners();
  }

  void clearNeighbors(int row, int col) {
    _updateNeighbors(row, col, mode: 'clear');
    notifyListeners();
  }

  void _updateNeighbors(int row, int col, {required String mode}) {
    for (int dr = -1; dr <= 1; dr++) {
      for (int dc = -1; dc <= 1; dc++) {
        if (dr == 0 && dc == 0) continue;
        int nr = row + dr;
        int nc = col + dc;
        if (nr < 0 || nr >= gridSize || nc < 0 || nc >= gridSize) continue;

        final neighbor = grid[nr][nc];
        if (neighbor.state == CellState.opened) continue;

        if (mode == 'dangerous') {
          if (neighbor.state != CellState.safe) {
            neighbor.state = CellState.dangerous;
          }
        } else if (mode == 'safe') {
          if (neighbor.state == CellState.dangerous ||
              neighbor.state == CellState.closed) {
            neighbor.state = CellState.safe;
          }
        } else if (mode == 'clear') {
          if (neighbor.state == CellState.dangerous ||
              neighbor.state == CellState.safe) {
            neighbor.state = CellState.closed;
          }
        }
      }
    }
  }

  void resetGame() {
    score = 0;
    remainingCards[CardValue.one] = 7;
    remainingCards[CardValue.two] = 4;
    remainingCards[CardValue.three] = 5;
    remainingCards[CardValue.four] = 5;
    remainingCards[CardValue.five] = 3;
    remainingCards[CardValue.king] = 1;
    selectedCard = CardValue.one;
    canUndo = false;
    lastRow = null;
    lastCol = null;
    _previousGrid = null;
    _previousScore = null;
    _previousRemainingCards = null;
    _initGrid();
    notifyListeners();
  }
}
