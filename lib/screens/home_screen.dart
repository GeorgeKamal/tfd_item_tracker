import 'package:flutter/material.dart';
import 'package:tfd_item_tracker/components/asset_list.dart';
import 'package:tfd_item_tracker/models/descendant.model.dart';
import 'package:tfd_item_tracker/models/weapon.model.dart';
import 'package:tfd_item_tracker/utils/constants.dart';

class HomeScreen extends StatelessWidget {
  //TODO - handle patterns data
  final List<Descendant> descendants;
  final List<Weapon> weapons;

  const HomeScreen({required this.descendants, required this.weapons, super.key});
  
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: Constants.tabNames.length, 
      child: Scaffold(
        appBar: AppBar(
          title: Text(Constants.title),
          bottom: TabBar(
            tabs: Constants.tabNames.map((x) => Tab(text: x)).toList()
          ),
        ),
        body: TabBarView(
          children: [AssetList(list: descendants), AssetList(list: weapons)]
        ),
      )
    );
  }
}