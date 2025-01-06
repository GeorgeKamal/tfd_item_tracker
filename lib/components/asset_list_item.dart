import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tfd_item_tracker/components/asset_details.dart';
import 'package:tfd_item_tracker/models/asset.interface.dart';
import 'package:tfd_item_tracker/providers/stars_model.dart';
import 'package:tfd_item_tracker/utils/utils.dart';

class AssetListItem extends StatefulWidget {
  final Asset asset;

  const AssetListItem({required this.asset, super.key});

  @override
  State<StatefulWidget> createState() => AssetListItemState();
  
}

class AssetListItemState extends State<AssetListItem> {
  //TODO - handle patterns data

  double? progress;

  void viewDetails(BuildContext context) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => AssetDetails(asset: widget.asset)));
    getProgress();
  }

  void getProgress() {
    AssetDetails.loadProgress(widget.asset).then((value) {
      if(progress != value) {
        setState(() {
          progress = value;
        });
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    getProgress();

    if(progress == null) {
      //TODO - placeholder?
      return Center(child: CircularProgressIndicator());
    }

    StarsModel model = Provider.of<StarsModel>(context, listen: false);
    bool starred = model.isStarred(widget.asset.getName);

    LayoutBuilder imageLayout = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double size = constraints.maxHeight * 0.8;
        return ClipOval(child: Image.asset(widget.asset.getImagePath, width: size, height: size));
      },
    );

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => viewDetails(context),
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Hero(
                tag: widget.asset.getName,
                child: imageLayout
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.asset.getName),
                  Row(
                    children: [
                      Expanded(flex: 3, child: LinearProgressIndicator(value: progress, borderRadius: BorderRadius.circular(10),)),
                      Expanded(child: Text("${(progress!*100).round()}%", textAlign: TextAlign.center,)),
                    ],
                  )
                ],
              ),
            ),
            IconButton(
              onPressed: () async {
                if(starred) {
                  bool result = await Utils.alert(context, "Confirm Remove", "Remove ${widget.asset.getName} from stars?");
                  if(result) {
                    model.toggle(widget.asset.getName);
                    if(context.mounted){
                      Utils.snack(context, "Saved!");
                    }
                 }
                }
                else {
                  model.toggle(widget.asset.getName);
                  Utils.snack(context, "Saved!");
                }
              },
              icon: Icon(starred? Icons.star_rounded: Icons.star_border_rounded)
            ),
          ],
        ),
      )
    );
  }
  
}