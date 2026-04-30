enum CellState { closed, opened, dangerous, safe }

enum CardValue { one, two, three, four, five, king, empty }

extension CardValueExtension on CardValue {
  String get label {
    switch (this) {
      case CardValue.one:
        return '1';
      case CardValue.two:
        return '2';
      case CardValue.three:
        return '3';
      case CardValue.four:
        return '4';
      case CardValue.five:
        return '5';
      case CardValue.king:
        return 'K';
      case CardValue.empty:
        return '';
    }
  }

  int get points {
    switch (this) {
      case CardValue.one:
        return 10;
      case CardValue.two:
        return 20;
      case CardValue.three:
        return 30;
      case CardValue.four:
        return 40;
      case CardValue.five:
        return 50;
      case CardValue.king:
        return 100;
      case CardValue.empty:
        return 0;
    }
  }
}

class CellModel {
  final int row;
  final int col;
  CellState state;
  CardValue value;

  CellModel({
    required this.row,
    required this.col,
    this.state = CellState.closed,
    this.value = CardValue.empty,
  });
}
