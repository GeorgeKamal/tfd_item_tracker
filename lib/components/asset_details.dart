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
      // Expanded(
      //   child: 
        Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20), 
              child: Column(
                children: [
                  if(index == 0)
                    Center(child: Text(""),),
                  InkWell(
                    onTap: () {print("help");},
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 16),
                            SizedBox(width: screenWidth * (isPortrait? 0.6: 0.45), child: Text(widget.asset.getParts[index])),
                          ],
                        ),
                        generateStateHolderWidget(index)
                      ],
                    ),
                  ),
                  if(index < widget.asset.getParts.length - 1)
                    Divider(height: 20,)
                ],
              )
            ),
          ],
        // )
      )
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
          SizedBox(width: 16)
        ],
      );
    }

    return stateHolder;
  }

  @override
  Widget build(BuildContext context) {
    bool isPortrait = MediaQuery.of(context).orientation.index == 0;

    Widget bodyWidget = (owned == null || count == null)? LinearProgressIndicator() : isPortrait?
      Column(
        children: [
          Expanded(
            flex: 25,
            child: Hero(
              tag: widget.asset.getName,
              child: Center(child: Image.asset(widget.asset.getImagePath))
            ),
          ),
          Expanded(flex: 1, child: Center()),
          Expanded(flex: 25, child: Column(children: generateRows(context, isPortrait))),
          Expanded(flex: 3, child: Center()),
        ],
      )
    :
    Row(
      children: [
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Expanded(
                flex: 8,
                child: Hero(
                  tag: widget.asset.getName,
                  child: Center(child: Image.asset(widget.asset.getImagePath))
                ),
              ),
              Expanded(flex: 1, child: Center()),
            ],
          )
        ),
        Expanded(flex: 2, child: Column(children: generateRows(context, isPortrait)))
      ],
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.asset.getName),
      ),
      body: bodyWidget
    );
  }
  
}