import 'package:flutter/material.dart';
import 'package:tfd_item_tracker/models/asset.interface.dart';
import 'package:tfd_item_tracker/models/descendant.model.dart';
import 'package:tfd_item_tracker/models/weapon.model.dart';
import 'package:tfd_item_tracker/utils/utils.dart';

class AssetDetails extends StatefulWidget {
  final Asset asset;
  
  const AssetDetails({required this.asset, super.key});

  @override
  State<StatefulWidget> createState() => AssetDetailsState();
  
}

class AssetDetailsState extends State<AssetDetails> {
  //TODO - handle patterns data

  List<bool>? owned;
  List<int>? count;

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> save() async {
    if(widget.asset is Descendant) {
      Utils.saveString(widget.asset.getName, owned!.join("#").toString());
    }
    if(widget.asset is Weapon) {
      Utils.saveString(widget.asset.getName, count!.join("#").toString());
    }
  }

  Future<void> load() async {
    String loaded = await Utils.loadString(widget.asset.getName);
    
    if(loaded.isNotEmpty) {
      if(widget.asset is Descendant) {
        owned = loaded.split("#").map(bool.parse).toList();
        count = List.filled(widget.asset.getParts.length, 0);
      }
      if(widget.asset is Weapon) {
        owned = List.filled(widget.asset.getParts.length, false);
        count = loaded.split("#").map(int.parse).toList();
      }
    }
    else {
      owned = List.filled(widget.asset.getParts.length, false);
      count = List.filled(widget.asset.getParts.length, 0);
    }

    setState(() {});
  }

  List<Widget> generateRows(BuildContext context, bool isPortrait) {
    double screenWidth = MediaQuery.of(context).size.width;

    List<Widget> rows = List.generate(widget.asset.getParts.length, (int index) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: 20), 
        child: Column(
          children: [
            if(index == 0)
              Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () {String part=widget.asset.getParts[index];print("Move to Patterns page with $part");},
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(width: screenWidth * (isPortrait? 0.55 : 0.45), child: Text(widget.asset.getParts[index]))
                    )
                ),
                generateStateHolderWidget(index)
              ],
            ),
            // if(index < widget.asset.getParts.length - 1)
              Divider()
          ],
        )
      ),
    );

    return rows;
  }

  Widget generateStateHolderWidget(int index) {
    WidgetStateProperty<Icon> thumbIconProperty = WidgetStateProperty<Icon>.fromMap(
      <WidgetStatesConstraint, Icon>{
        WidgetState.selected: Icon(Icons.check),
        WidgetState.any: Icon(Icons.close),
      },
    );

    Widget stateHolder = Row(
      children: [
        IconButton(onPressed: () {
          if(count![index] > 0) {
            setState(() {
              count![index]--;
            });
            save();
            Utils.alert(context, "Saved!");
          }
        }, icon: Icon(Icons.remove)),
        Text(count![index].toString()), 
        IconButton(onPressed: () {
          if(count![index] < 5) {
            setState(() {
              count![index]++;
            });
            save();
            Utils.alert(context, "Saved!");
          }
        }, icon: Icon(Icons.add)),
      ],
    );

    if(widget.asset is Descendant) {
      stateHolder = Row(
        children: [
          Switch(
            value: owned![index],
            thumbIcon: thumbIconProperty,
            onChanged: (value) {
              setState(() {
                owned![index] = value;
              });
              save();
              Utils.alert(context, "Saved!");
            }
          ),
        ],
      );
    }

    return stateHolder;
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation.index == 0;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    Widget bodyWidget = (owned == null || count == null)? LinearProgressIndicator() : isPortrait?
      Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Hero(
              tag: widget.asset.getName,
              child: Center(child: Image.asset(widget.asset.getImagePath, height: screenHeight * (widget.asset is Descendant? 0.35 : 0.3)))
            ),
            SizedBox(height: 15),
            Column(children: generateRows(context, isPortrait))
          ],
        )
      )
    :
    Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1, 
            child: Hero(
            tag: widget.asset.getName,
            child: Center(child: Image.asset(widget.asset.getImagePath, width: screenWidth * 0.3, height: screenHeight * 0.65,))
            )
          ),
          Expanded(
            flex: 3, 
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: generateRows(context, isPortrait))
          )
        ],
      )
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.asset.getName),
      ),
      body: SafeArea(child: SingleChildScrollView(child: bodyWidget,))
    );
  }
  
}