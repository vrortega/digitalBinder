import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/binder_model.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class HomeViewModel extends ChangeNotifier {

  List<BinderModel> binders = [];

  bool isLoading = true;

  HomeViewModel() {
    loadBinders();
  }

  Future<void> loadBinders() async {

    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString("binders");

    if (jsonString != null) {
      final List decoded = jsonDecode(jsonString);

      binders = decoded
          .map((e) => BinderModel.fromJson(e))
          .toList();
    }

    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteBinder(String binderId) async {

    final prefs = await SharedPreferences.getInstance();

    final binderData = prefs.getString('binder_$binderId');

    if (binderData != null) {

      final decoded = jsonDecode(binderData);

      final directory = await getApplicationDocumentsDirectory();

      for (var page in decoded) {
        for (var fileName in page) {

          if (fileName != null) {
            final file = File(
              '${directory.path}/binder_images/$fileName',
            );

            if (await file.exists()) {
              await file.delete();
            }
          }
        }
      }
    }

    await prefs.remove('binder_$binderId');

    binders.removeWhere((b) => b.id == binderId);

    await prefs.setString(
      "binders",
      jsonEncode(binders.map((e) => e.toJson()).toList()),
    );

    notifyListeners();
  }

  Future<BinderModel> createBinder() async {

    final prefs = await SharedPreferences.getInstance();

    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final binder = BinderModel(
      id: id,
      name: "New Binder",
      cardCount: 0,
      preview: null,
    );

    binders.add(binder);

    await prefs.setString(
      "binders",
      jsonEncode(binders.map((e) => e.toJson()).toList()),
    );

    notifyListeners();

    return binder;
  }
}