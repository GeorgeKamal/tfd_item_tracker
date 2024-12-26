import 'package:flutter/material.dart';
import 'package:tfd_item_tracker/components/asset_details.dart';
import 'package:tfd_item_tracker/models/asset.interface.dart';
import 'package:tfd_item_tracker/models/descendant.model.dart';
import 'package:tfd_item_tracker/utils/utils.dart';

class AssetListItem extends StatelessWidget {
  //TODO - handle patterns data
  final Asset asset;

  const AssetListItem({required this.asset, super.key});

  void viewDetails(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => AssetDetails(asset: asset)));
  }

  @override
  Widget build(BuildContext context) {
    ClipOval imageWidget = asset is Descendant? 
      ClipOval(child: Image.asset(asset.getImagePath, width: 75, height: 75, fit: BoxFit.cover, alignment: Alignment(0, -0.75),),)
      :
      ClipOval(child: Image.asset(asset.getImagePath, width: 75, height: 75,),);
    
    return Card(
      child: InkWell(
        onTap: () => viewDetails(context),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Row(
          children: [
            SizedBox(width: 16),
            Hero(
              tag: asset.getName,
              child: imageWidget
            ),
            SizedBox(width: 16),
            Expanded(child: Text(asset.getName)),
            IconButton(
              onPressed: () {
                // onStar!();
                //TODO - Add Starred Feature
                Utils.alert(context, "Add Starred Feature");
              },
              // icon: Icon(starred.contains(title)? Icons.star_rounded: Icons.star_border_rounded)
              icon: Icon(Icons.star_rounded)
            ),
            SizedBox(width: 16),
          ],
        )
      ),
    );
  }
  
}