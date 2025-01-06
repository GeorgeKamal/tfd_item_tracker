import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfd_item_tracker/components/asset_list.dart';
import 'package:tfd_item_tracker/components/drawer_item.dart';
import 'package:tfd_item_tracker/models/asset.interface.dart';
import 'package:tfd_item_tracker/models/descendant.model.dart';
import 'package:tfd_item_tracker/models/fellow.model.dart';
import 'package:tfd_item_tracker/models/weapon.model.dart';
import 'package:tfd_item_tracker/providers/stars_model.dart';
import 'package:tfd_item_tracker/utils/constants.dart';

class AppNavigation extends StatefulWidget {
  final List<Asset> assets;
  late final List<Descendant> descendants;
  late final List<Weapon> weapons;
  late final List<Fellow> fellows;
  final List<Asset> starred;
  final List<Pattern> patterns;

  AppNavigation({required this.assets, required this.starred, required this.patterns, super.key}) {
    descendants = assets.whereType<Descendant>().toList();
    weapons = assets.whereType<Weapon>().toList();
    fellows = assets.whereType<Fellow>().toList();
  }
  
  @override
  State<StatefulWidget> createState() => AppNavigationState();
}

class AppNavigationState extends State<AppNavigation> {
  late final List<List<Asset>> screens;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    screens = [widget.descendants, widget.weapons, widget.fellows, widget.starred];
  }

  void navigate(BuildContext context, int index) {
    setState(() {
      currentIndex = index;
    });
    Navigator.pop(context);
  }

  List<Asset> getStarred() {
    Provider.of<StarsModel>(context).load();
    UnmodifiableListView<String> starredNames = Provider.of<StarsModel>(context).starredNames;
    List<Asset> starredAssets = List.empty(growable: true);

    for (int i=0; i<widget.assets.length; i++) {
      if(starredNames.contains(widget.assets[i].getName)) {
        starredAssets.add(widget.assets[i]);
      }
    }
    
    return starredAssets;
  }

  @override
  Widget build(BuildContext context) {
    screens[3] = getStarred();

    return Scaffold(
      appBar: AppBar(
        title: Text(Constants.screens[currentIndex]),
      ),
      drawer: Drawer(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DrawerHeader(child: Center(child: Text(Constants.title))),
                ...List.generate(
                  Constants.screens.length,
                  (index) => DrawerItem(name: Constants.screens[index], selected: currentIndex == index, onTap: () async {navigate(context, index);}))
                // ...Constants.screens.map((x) => DrawerItem(name: x, selected: false, onTap: () {print(x);},))
              ]
            ),
          ),
        )
      ),
      body: SafeArea(child: AssetList(list: screens[currentIndex])),
    );
  }
  
}