import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final String name;
  final bool selected;
  final GestureTapCallback onTap;

  const DrawerItem({required this.name, required this.selected, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      color: selected? Theme.of(context).colorScheme.onInverseSurface: Theme.of(context).cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.all(Radius.circular(10)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
          child: Text(name),
        )
      )
    );
  }
}