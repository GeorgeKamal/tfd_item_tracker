import 'package:tfd_item_tracker/constants.dart';

class Weapon {
  final String name;
  final String imagePath;
  final List<String> parts;

  const Weapon({
    required this.name,
    required this.imagePath,
    required this.parts,
  });

  String get getType => Constants.typeWeapon;
  
  String get getName => name;

  String get getImagePath => imagePath;

  List<String> get getParts => parts;
}
