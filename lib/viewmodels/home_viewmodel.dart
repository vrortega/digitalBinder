import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/binder_model.dart';

class HomeViewModel extends ChangeNotifier {

  List<BinderModel> binders = [];

  bool isLoading = true;

  HomeViewModel() {
    loadBinders();
  }

  Future<void> loadBinders() async {

    final prefs = await SharedPreferences.getInstance();

    final list = prefs.getStringList("binders_list") ?? [];

    binders = list.map((id) {

      return BinderModel(
        id: id,
        name: "New Binder",
      );

    }).toList();

    isLoading = false;

    notifyListeners();
  }

  Future<BinderModel> createBinder() async {

    final prefs = await SharedPreferences.getInstance();

    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final list = prefs.getStringList("binders_list") ?? [];

    list.add(id);

    await prefs.setStringList("binders_list", list);

    final binder = BinderModel(
      id: id,
      name: "New Binder",
    );

    binders.add(binder);

    notifyListeners();

    return binder;
  }

}