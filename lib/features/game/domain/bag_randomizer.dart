import 'dart:math';
import 'tetromino_type.dart';

/// 7-Bag generator ensuring a uniform and fair distribution of tetrominoes.
/// Generates a shuffled bag of all 7 tetrominoes and refills automatically when depleted.
class BagRandomizer {
  final Random _random;
  final List<TetrominoType> _bag = [];

  BagRandomizer([Random? random]) : _random = random ?? Random();

  /// Refills the internal bag with all 7 pieces shuffled.
  void _refillBag() {
    final pieces = List<TetrominoType>.from(TetrominoType.values);
    pieces.shuffle(_random);
    _bag.addAll(pieces);
  }

  /// Deals the next tetromino from the bag.
  TetrominoType next() {
    if (_bag.isEmpty) {
      _refillBag();
    }
    return _bag.removeAt(0);
  }

  /// Generates an initial queue of [count] upcoming tetrominoes.
  List<TetrominoType> generateInitialQueue(int count) {
    final queue = <TetrominoType>[];
    for (int i = 0; i < count; i++) {
      queue.add(next());
    }
    return queue;
  }
}
