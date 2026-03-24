import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

enum CardAction {
  addImage,
  openMenu,
}

class BinderViewModel extends ChangeNotifier {

  final ImagePicker picker = ImagePicker();

  List<List<File?>> pages = [
    [null, null, null, null],
  ];

  int currentPage = 0;

  List<File?> get cards => pages[currentPage];

  CardAction onCardTap(int index) {
    if (cards[index] == null) {
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
      pages[currentPage][index] = File(image.path);
      notifyListeners();
    }
  }

  void deleteCard(int index) {
    pages[currentPage][index] = null;
    notifyListeners();
  }

  void nextPage() {

    if (currentPage == pages.length - 1) {
      pages.add([null, null, null, null]);
    }

    currentPage++;
    notifyListeners();
  }

  void previousPage() {

    if (currentPage > 0) {
      currentPage--;
      notifyListeners();
    }
  }

  bool get hasPreviousPage => currentPage > 0;
}