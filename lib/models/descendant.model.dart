import 'package:tfd_item_tracker/constants.dart';

class Descendant {
  final String name;
  final String imagePath;
  final List<String> parts;

  const Descendant({
    required this.name,
    required this.imagePath,
    required this.parts,
  });

  String get getType => Constants.typeDescendant;
  
  String get getName => name;

  String get getImagePath => imagePath;

  List<String> get getParts => parts;
}
