import 'package:flutter/material.dart';
import 'package:tfd_item_tracker/models/asset.interface.dart';
import 'package:tfd_item_tracker/models/descendant.model.dart';

class AssetDetails extends StatelessWidget {
  //TODO - handle patterns data
  final Asset asset;
  
  const AssetDetails({required this.asset, super.key});

  List<Widget> generateRows(BuildContext context, bool isPortrait) {
    double screenWidth = MediaQuery.of(context).size.width;

    List<Widget> rows = List.generate(asset.getParts.length, (int index) =>
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
                            SizedBox(width: screenWidth * (isPortrait? 0.6: 0.45), child: Text(asset.getParts[index])),
                          ],
                        ),
                        generateStateHolderWidget(index)
                      ],
                    ),
                  ),
                  if(index < asset.getParts.length - 1)
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
        IconButton(onPressed: () {print("remove $index");}, icon: Icon(Icons.remove)),
        Text("0"), 
        IconButton(onPressed: () {print("add $index");}, icon: Icon(Icons.add)), 
      ],
    );

    if(asset is Descendant) {
      stateHolder = Row(
        children: [
          Switch(
            value: false,
            thumbIcon: thumbIconProperty,
            onChanged: (value) {print("$value $index");}
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

    Widget bodyWidget = isPortrait?
      Column(
        children: [
          Expanded(
            flex: 25,
            child: Hero(
              tag: asset.getName,
              child: Center(child: Image.asset(asset.getImagePath))
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
                  tag: asset.getName,
                  child: Center(child: Image.asset(asset.getImagePath))
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
        title: Text(asset.getName),
      ),
      body: bodyWidget
    );
  }
  
}