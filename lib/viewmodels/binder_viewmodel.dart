import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/binder_model.dart';

enum CardAction {
  addImage,
  openMenu,
}

class BinderViewModel extends ChangeNotifier {

  final ImagePicker picker = ImagePicker();

  BinderModel binder = BinderModel();

  List<File?> get cards => binder.cards;

  CardAction onCardTap(int index) {
    if (binder.cards[index] == null) {
      return CardAction.addImage;
    } else {
      return CardAction.openMenu;
    }
  }

  Future<void> pickImage(int index) async {

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image != null) {
      binder.cards[index] = File(image.path);
      notifyListeners();
    }
  }

  void deleteCard(int index) {
    binder.cards[index] = null;
    notifyListeners();
  }
}