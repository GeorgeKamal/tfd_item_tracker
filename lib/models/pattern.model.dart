import 'package:tfd_item_tracker/models/pattern_item.dart';

class Pattern {
  final String name;
  final String dropsFrom;
  final String useIn;
  final List<PatternItem> drops;

  const Pattern({
    required this.name,
    required this.dropsFrom,
    required this.useIn,
    required this.drops,
  });

  String get getName => name;

  String get getDropsFrom => dropsFrom;

  String get getUseIn => useIn;

  List<PatternItem> get getDrops => drops;
}
