import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tfd_item_tracker/app_navigation.dart';
import 'package:tfd_item_tracker/models/asset.interface.dart';
import 'package:tfd_item_tracker/models/descendant.model.dart';
import 'package:tfd_item_tracker/models/fellow.model.dart';
import 'package:tfd_item_tracker/models/weapon.model.dart';
import 'package:tfd_item_tracker/providers/stars_model.dart';
import 'package:tfd_item_tracker/utils/constants.dart';

void main() {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  //TODO - add patterns data here
  Future<List<Asset>> loadAssets() async {
    String assetsJsonString = await rootBundle.loadString("assets/data/assets_metadata.json");
    // String descendantsJsonString = await rootBundle.loadString("assets/data/descendants.json");
    // String weaponsJsonString = await rootBundle.loadString("assets/data/weapons.json");
    // String patternsJsonString = await rootBundle.loadString("assets/data/patterns.json");
    
    Map<String, dynamic> assetsJsonData = json.decode(assetsJsonString);
    // Map<String, dynamic> descendantsJsonData = json.decode(descendantsJsonString);
    // Map<String, dynamic> weaponsJsonData = json.decode(weaponsJsonString);
    // Map<String, dynamic> patternsJsonData = json.decode(patternsJsonString);

    List<Asset> assets = List.empty(growable: true);
    // List<Descendant> descendants = List.empty(growable: true);
    // List<Weapon> weapons = List.empty(growable: true);
    // Map<String, List<String>> patterns = {};
    
    assetsJsonData.forEach((key, value) {
      List<dynamic> parts = value.sublist(2);
      switch (value[0]) {
        case Constants.typeDescendant:
          assets.add(Descendant(name: key, imagePath: value[1], parts: parts.map((part) => List<String>.from(part)).toList()));
          break;
        case Constants.typeWeapon:
          assets.add(Weapon(name: key, imagePath: value[1], parts: parts.map((part) => List<String>.from(part)).toList()));
          break;
        case Constants.typeFellow:
          assets.add(Fellow(name: key, imagePath: value[1], parts: parts.map((part) => List<String>.from(part)).toList()));
          break;
        default: break;
      }
    });
    // descendantsJsonData.forEach((key, value) {
    //   List<String> descendantList = List<String>.from(value);
    //   descendants.add(Descendant(name: key, imagePath: descendantList[0], parts: descendantList.sublist(1)));
    // });
    // weaponsJsonData.forEach((key, value) {
    //   List<String> weaponList = List<String>.from(value);
    //   weapons.add(Weapon(name: key, imagePath: weaponList[0], parts: weaponList.sublist(1)));
    // });
    // patternsJsonData.forEach((key, value) {
    //   patterns[key] = List<String>.from(value);
    // });
    return assets;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Asset>>(
      future: loadAssets(),
      builder: (BuildContext context, AsyncSnapshot<List<Asset>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show a loading indicator while waiting
        } else if (snapshot.hasError) {
          return Center(child: Padding(padding: EdgeInsets.all(40), child: Text("Error: ${snapshot.error}", style: TextStyle(fontSize: 20),),)); // Handle errors
        } else if (snapshot.hasData) {  // Display the loaded JSON data
          return MaterialApp(
            // theme: ThemeData.from(colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellowAccent, brightness: Brightness.dark)),
            theme: ThemeData.dark(useMaterial3: true),
            home: ChangeNotifierProvider(
              create: (context) => StarsModel(),
              child: AppNavigation(
                assets: snapshot.data!,
                patterns: [],
                starred: [],
              )
            )
          );
        } else {
          return Center(child: Padding(padding: EdgeInsets.all(40), child: Text("No Data Found!", style: TextStyle(fontSize: 20),),)); // Handle errors
        }
      },
    );
  }
}
