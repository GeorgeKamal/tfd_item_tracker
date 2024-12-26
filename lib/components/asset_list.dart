import 'package:flutter/material.dart';
import 'package:tfd_item_tracker/components/asset_list_item.dart';
import 'package:tfd_item_tracker/models/asset.interface.dart';

class AssetList extends StatelessWidget {
  //TODO - handle patterns data
  final List<Asset> list;
  
  const AssetList({required this.list, super.key});


  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: MediaQuery.of(context).orientation.index == 0? 1:2, 
        childAspectRatio: 4,
        ), 
      itemCount: list.length,
      itemBuilder: (context, index) {
        return AssetListItem(asset: list[index]);
      },
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5)
    );
  }
  
}