import 'package:tfd_item_tracker/models/asset.interface.dart';
import 'package:tfd_item_tracker/utils/constants.dart';

class Weapon extends Asset {
  const Weapon({required super.name, required super.imagePath, required super.parts});

  @override
  String toString() {
    String type = Constants.typeWeapon;
    String superString = super.toString();
    return "$type - $superString";
  }
}
