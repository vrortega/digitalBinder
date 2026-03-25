import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

enum CardAction {
  addImage,
  openMenu,
}

class BinderViewModel extends ChangeNotifier {

  final String binderId;

  final ImagePicker picker = ImagePicker();

  List<List<File?>> pages = [
    [null, null, null, null],
  ];

  int currentPage = 0;

  bool isLoading = true;

  BinderViewModel(this.binderId) {
    loadBinder();
  }

  List<File?> get cards => pages[currentPage];

  CardAction onCardTap(int index) {
    if (cards[index] == null) {
      return CardAction.addImage;
    } else {
      return CardAction.openMenu;
    }
  }

  /// salva imagem no storage interno do app
  Future<File> saveImageToAppStorage(File image) async {

    final directory = await getApplicationDocumentsDirectory();

    final imagesDir = Directory('${directory.path}/binder_images');

    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();

    final newImage = await image.copy(
      '${imagesDir.path}/$fileName.jpg',
    );

    return newImage;
  }

  Future<void> pickImage(int index) async {

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    final File original = File(image.path);

    final File savedImage = await saveImageToAppStorage(original);

    pages[currentPage][index] = savedImage;

    await saveBinder();

    notifyListeners();
  }

  Future<void> deleteCard(int index) async {

    final file = pages[currentPage][index];

    if (file != null && await file.exists()) {
      await file.delete();
    }

    pages[currentPage][index] = null;

    await saveBinder();

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

  /// SALVAR BINDER

  Future<void> saveBinder() async {

    final prefs = await SharedPreferences.getInstance();

    List<List<String?>> data = pages.map((page) {
      return page.map((file) => file?.path).toList();
    }).toList();

    await prefs.setString('binder_$binderId', jsonEncode(data));
  }

  /// CARREGAR BINDER

  Future<void> loadBinder() async {

    final prefs = await SharedPreferences.getInstance();

    final jsonString = prefs.getString('binder_$binderId');

    if (jsonString != null) {

      List decoded = jsonDecode(jsonString);

      pages = decoded.map<List<File?>>((page) {

        return (page as List).map<File?>((path) {

          if (path == null) return null;

          final file = File(path);

          if (!file.existsSync()) {
            return null;
          }

          return file;

        }).toList();

      }).toList();
    }

    isLoading = false;

    notifyListeners();
  }
}