import 'package:flutter/material.dart';
import 'package:tfd_item_tracker/models/asset.interface.dart';
import 'package:tfd_item_tracker/models/descendant.model.dart';
import 'package:tfd_item_tracker/models/fellow.model.dart';
import 'package:tfd_item_tracker/models/weapon.model.dart';
import 'package:tfd_item_tracker/utils/utils.dart';

class AssetDetails extends StatefulWidget {
  final Asset asset;
  
  const AssetDetails({required this.asset, super.key});

  @override
  State<StatefulWidget> createState() => AssetDetailsState();

  static Future<double> loadProgress(Asset asset) async {
    String loaded = await Utils.loadString(asset.getName);
    
    if(loaded.isNotEmpty) {
      if(asset is Descendant) {
        return loaded.split("#").map((x) => bool.parse(x)? 1:0).reduce((a, b) => a + b) / 4;
      }
      if(asset is Weapon) {
        return loaded.split("#").map(int.parse).reduce((a, b) => a + b) / 20;
      }
    }
    
    return 0;
  }

  
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

  List<Widget> generateRows(BuildContext context) {
    List<Widget> rows = List.generate(widget.asset.getParts.length, (int index) =>
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10), 
        child: Column(
          children: [
            if(index == 0)
              Divider(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipOval(child: Image.asset(widget.asset.getParts[index][0], width: 50, height: 50, fit: BoxFit.cover)),
                  SizedBox(width: 10),
                  Expanded(
                    child: InkWell(
                      onTap: () {Utils.snack(context, "Move to Patterns page with ${widget.asset.getParts[index][1]}");},
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text(widget.asset.getParts[index][1])
                      )
                    )
                  ),
                  SizedBox(width: 10),
                  generateStateHolderWidget(index)
                ],
              )
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
            Utils.snack(context, "Saved!");
          }
        }, icon: Icon(Icons.remove)),
        Text(count![index].toString()), 
        IconButton(onPressed: () {
          if(count![index] < 5) {
            setState(() {
              count![index]++;
            });
            save();
            Utils.snack(context, "Saved!");
          }
        }, icon: Icon(Icons.add)),
      ],
    );

    if(widget.asset is Descendant || widget.asset is Fellow) {
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
              Utils.snack(context, "Saved!");
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

    Widget bodyWidget = (owned == null || count == null)? LinearProgressIndicator() : isPortrait?
      Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Hero(
              tag: widget.asset.getName,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: Image.asset(widget.asset.getImagePath)
                ),
              )
            ),
            SizedBox(height: 20),
            Column(children: generateRows(context))
          ],
        )
      )
    :
    Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            flex: 2, 
            child: Hero(
              tag: widget.asset.getName,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(15),
                  child: Image.asset(widget.asset.getImagePath)
                ),
              )
            )
          ),
          // SizedBox(width: 10),
          Expanded(
            flex: 5, 
            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: generateRows(context))
          )
        ],
      )
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.asset.getName),
      ),
      body: SafeArea(child: Center(child: SingleChildScrollView(child: bodyWidget,),))
    );
  }
  
}