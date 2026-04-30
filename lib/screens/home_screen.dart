import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logic/game_logic.dart';
import '../models/cell_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Color _cardColor(CardValue card) {
    switch (card) {
      case CardValue.one:
        return Colors.green.shade400;
      case CardValue.two:
        return Colors.yellow.shade700;
      case CardValue.three:
        return Colors.orange.shade400;
      case CardValue.four:
        return Colors.purple.shade400;
      case CardValue.five:
        return Colors.blue.shade400;
      case CardValue.king:
        return Colors.red.shade400;
      default:
        return Colors.grey.shade400;
    }
  }

  Color _cardLightColor(CardValue card) {
    switch (card) {
      case CardValue.one:
        return Colors.green.shade50;
      case CardValue.two:
        return Colors.yellow.shade50;
      case CardValue.three:
        return Colors.orange.shade50;
      case CardValue.four:
        return Colors.purple.shade50;
      case CardValue.five:
        return Colors.blue.shade50;
      case CardValue.king:
        return Colors.red.shade50;
      default:
        return Colors.grey.shade50;
    }
  }

  @override
  Widget build(BuildContext context) {
    final game = context.watch<GameLogic>();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F0),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Kral Yardımcısı',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        actions: [
          IconButton(
            onPressed: game.canUndo
                ? () => context.read<GameLogic>().undo()
                : null,
            icon: Icon(
              Icons.undo,
              color: game.canUndo ? Colors.orange : Colors.grey.shade300,
            ),
            tooltip: 'Geri Al',
          ),
          TextButton(
            onPressed: () => context.read<GameLogic>().resetGame(),
            child: const Text('Sıfırla', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                _buildCounters(game),
                const SizedBox(height: 12),
                _buildGrid(context, game),
                const SizedBox(height: 12),
                _buildLegend(),
                const SizedBox(height: 12),
                _buildCardPicker(context, game),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCounters(GameLogic game) {
    return Row(
      children: [
        _counterCard(
          'Kalan 5',
          '${game.remainingFive}',
          Colors.blue.shade100,
          Colors.blue.shade700,
        ),
        const SizedBox(width: 8),
        _counterCard(
          'Kalan K',
          '${game.remainingKing}',
          Colors.red.shade100,
          Colors.red.shade700,
        ),
        const SizedBox(width: 8),
        _counterCard(
          'Açılan',
          '${game.openedCount}/25',
          Colors.green.shade100,
          Colors.green.shade700,
        ),
        const SizedBox(width: 8),
        _counterCard(
          'Puan',
          '${game.score}',
          Colors.orange.shade100,
          Colors.orange.shade700,
        ),
      ],
    );
  }

  Widget _counterCard(String label, String value, Color bg, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: textColor)),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGrid(BuildContext context, GameLogic game) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 6,
          mainAxisSpacing: 6,
        ),
        itemCount: 25,
        itemBuilder: (context, index) {
          final row = index ~/ 5;
          final col = index % 5;
          final cell = game.grid[row][col];
          return _buildCell(context, cell, game);
        },
      ),
    );
  }

  Widget _buildCell(BuildContext context, CellModel cell, GameLogic game) {
    Color bg;
    Color borderColor;
    Color textColor;
    String label = cell.value.label;

    switch (cell.state) {
      case CellState.opened:
        bg = _cardLightColor(cell.value);
        borderColor = _cardColor(cell.value);
        textColor = _cardColor(cell.value);
        break;
      case CellState.dangerous:
        bg = Colors.red.shade50;
        borderColor = Colors.red.shade300;
        textColor = Colors.red.shade700;
        label = '!';
        break;
      case CellState.safe:
        bg = Colors.green.shade50;
        borderColor = Colors.green.shade400;
        textColor = Colors.green.shade700;
        label = '✓';
        break;
      case CellState.closed:
      default:
        bg = Colors.grey.shade100;
        borderColor = Colors.grey.shade300;
        textColor = Colors.grey.shade400;
        label = '';
    }

    return GestureDetector(
      onTap: () async {
        if (cell.state == CellState.opened) return;

        final game = context.read<GameLogic>();
        final selectedCard = game.selectedCard;

        // Kart bitti mi kontrol et
        if (!game.canPlaceCard(selectedCard)) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${selectedCard.label} kartı tükendi!',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Colors.red.shade400,
              duration: const Duration(seconds: 2),
              behavior: SnackBarBehavior.floating,
            ),
          );
          return;
        }

        game.onCellTap(cell.row, cell.col);

        if (selectedCard != CardValue.empty) {
          final hasFiveNeighbor = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (_) => AlertDialog(
              title: const Text('Komşu Kontrolü'),
              content: const Text(
                'Bu hücrenin çevresinde 5 var mı?',
                style: TextStyle(fontSize: 15),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text(
                    'Hayır',
                    style: TextStyle(color: Colors.green),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text(
                    'Evet',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          );

          if (hasFiveNeighbor == true) {
            game.markNeighborsDangerous(cell.row, cell.col);
          } else {
            game.markNeighborsSafe(cell.row, cell.col);
          }
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: borderColor, width: 1),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _legendItem(Colors.red.shade100, Colors.red.shade400, '! Tehlikeli'),
        const SizedBox(width: 12),
        _legendItem(Colors.green.shade100, Colors.green.shade400, '✓ Güvenli'),
        const SizedBox(width: 12),
        _legendItem(Colors.grey.shade100, Colors.grey.shade400, 'Kapalı'),
      ],
    );
  }

  Widget _legendItem(Color bg, Color border, String label) {
    return Row(
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: border),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildCardPicker(BuildContext context, GameLogic game) {
    final cards = [
      CardValue.one,
      CardValue.two,
      CardValue.three,
      CardValue.four,
      CardValue.five,
      CardValue.king,
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Açılan kartı seç, sonra hücreye dokun:',
            style: TextStyle(fontSize: 12, color: Colors.black54),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: cards.map((card) {
              final isSelected = game.selectedCard == card;
              final remaining = game.remainingCards[card] ?? 0;
              final isEmpty = remaining == 0;

              return GestureDetector(
                onTap: isEmpty
                    ? null
                    : () => context.read<GameLogic>().selectCard(card),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: isEmpty
                        ? Colors.grey.shade200
                        : isSelected
                        ? _cardLightColor(card)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isEmpty
                          ? Colors.grey.shade300
                          : isSelected
                          ? _cardColor(card)
                          : Colors.grey.shade300,
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        card.label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: isEmpty
                              ? Colors.grey.shade400
                              : isSelected
                              ? _cardColor(card)
                              : Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        'x$remaining',
                        style: TextStyle(
                          fontSize: 10,
                          color: isEmpty
                              ? Colors.grey.shade400
                              : Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
