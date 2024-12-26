import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tfd_item_tracker/models/descendant.model.dart';
import 'package:tfd_item_tracker/models/weapon.model.dart';
import 'package:tfd_item_tracker/screens/home_screen.dart';

void main() {
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  //TODO - add patterns data here
  Future<List<Object>> loadAssets() async {
    String descendantsJsonString = await rootBundle.loadString("assets/data/descendants.json");
    String weaponsJsonString = await rootBundle.loadString("assets/data/weapons.json");
    // String patternsJsonString = await rootBundle.loadString("../../assets/data/patterns.json");
    
    Map<String, dynamic> descendantsJsonData = json.decode(descendantsJsonString);
    Map<String, dynamic> weaponsJsonData = json.decode(weaponsJsonString);
    // Map<String, dynamic> patternsJsonData = json.decode(patternsJsonString);

    List<Descendant> descendants = List.empty(growable: true);
    List<Weapon> weapons = List.empty(growable: true);
    // Map<String, List<String>> patterns = {};
    
    descendantsJsonData.forEach((key, value) {
      List<String> descendantList = List<String>.from(value);
      descendants.add(Descendant(name: key, imagePath: descendantList[0], parts: descendantList.sublist(1)));
    });
    weaponsJsonData.forEach((key, value) {
      List<String> weaponList = List<String>.from(value);
      weapons.add(Weapon(name: key, imagePath: weaponList[0], parts: weaponList.sublist(1)));
    });
    // patternsJsonData.forEach((key, value) {
    //   patterns[key] = List<String>.from(value);
    // });
    return [descendants, weapons];
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Object>>(
      future: loadAssets(),
      builder: (BuildContext context, AsyncSnapshot<List<Object>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show a loading indicator while waiting
        } else if (snapshot.hasError) {
          return Center(child: Padding(padding: EdgeInsets.all(40), child: Text("Error: ${snapshot.error}", style: TextStyle(fontSize: 20),),)); // Handle errors
        } else if (snapshot.hasData) {  // Display the loaded JSON data
          return MaterialApp(
            theme: ThemeData.dark(useMaterial3: true),
            home: Container(
              color: ThemeData.dark(useMaterial3: true).scaffoldBackgroundColor,
              child: SafeArea(
                child: HomeScreen(descendants: snapshot.data![0] as List<Descendant>, weapons: snapshot.data![1] as List<Weapon>)
              )
            )
          );
        } else {
          return Center(child: Text("No data found")); // Handle the case where no data is found
        }
      },
    );
  }
}
