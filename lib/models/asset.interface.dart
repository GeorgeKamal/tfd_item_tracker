abstract class Asset {
  final String _name;
  final String _imagePath;
  final List<String> _parts;

  const Asset({required String name, required imagePath, required parts}) : _name = name, _imagePath = imagePath, _parts = parts; // Assigning the parameter to the private attribute

  // const Asset({
  //   required this._name,
  //   required this.imagePath,
  //   required this.parts,
  // });

  String get getName => _name;

  String get getImagePath => _imagePath;

  List<String> get getParts => _parts;

  @override
  String toString() {
    return "Name: $_name, Image: $_imagePath, Parts: $_parts";
  }
}
