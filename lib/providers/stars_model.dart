import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:tfd_item_tracker/utils/utils.dart';

class StarsModel extends ChangeNotifier {
  final Set<String> _starred = {};

  UnmodifiableListView<String> get starredNames => UnmodifiableListView(_starred);

  void load() async {
    List<String> tempList = await Utils.loadList("starred");
    _starred.addAll(tempList.toSet());
    print(_starred);
  }

  void save() async {
    Utils.saveList("starred", _starred.toList());
  }

  bool isStarred(String name) {
    return _starred.contains(name);
  }

  void toggle(String name) {
    if(_starred.contains(name)){
      _starred.remove(name);
    }
    else {
      _starred.add(name);
    }
    save();
    notifyListeners();
  }

}