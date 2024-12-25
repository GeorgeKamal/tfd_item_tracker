import 'package:tfd_item_tracker/models/asset.interface.dart';
import 'package:tfd_item_tracker/utils/constants.dart';

class Descendant extends Asset {
  const Descendant({required super.name, required super.imagePath, required super.parts});

  @override
  String toString() {
    String type = Constants.typeDescendant;
    String superString = super.toString();
    return "$type - $superString";
  }
}
