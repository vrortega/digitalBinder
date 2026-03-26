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

  List<List<String?>> pages = [
    [null, null, null, null],
  ];

  int currentPage = 0;

  bool isLoading = true;

  BinderViewModel(this.binderId) {
    loadBinder();
  }

  List<File?> get cards {
    return pages[currentPage].map((fileName) {
      if (fileName == null) return null;

      final directory = Directory(
        '${_appDir.path}/binder_images',
      );

      final file = File('${directory.path}/$fileName');

      if (file.existsSync()) {
        return file;
      }

      return null;
    }).toList();
  }

  late Directory _appDir;

  Future<void> _initDir() async {
    _appDir = await getApplicationDocumentsDirectory();
  }

  CardAction onCardTap(int index) {
    return cards[index] == null
        ? CardAction.addImage
        : CardAction.openMenu;
  }

    Future<void> reorderCards(int oldIndex, int newIndex) async {
    final page = pages[currentPage];

    final item = page[oldIndex];
    page[oldIndex] = page[newIndex];
    page[newIndex] = item;

    await saveBinder();
    notifyListeners();
  }

  Future<String> saveImageToAppStorage(File image) async {

    final imagesDir = Directory('${_appDir.path}/binder_images');

    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final fileName =
        "${DateTime.now().millisecondsSinceEpoch}.jpg";

    final newPath = '${imagesDir.path}/$fileName';

    final newImage = await image.copy(newPath);

    if (!await newImage.exists()) {
      throw Exception("Erro ao salvar imagem");
    }

    return fileName;
  }

  Future<void> pickImage(int index) async {

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (image == null) return;

    final File original = File(image.path);

    final fileName =
        await saveImageToAppStorage(original);

    pages[currentPage][index] = fileName;

    await saveBinder();

    notifyListeners();
  }

  Future<void> deleteCard(int index) async {

    final fileName = pages[currentPage][index];

    if (fileName != null) {
      final file = File(
        '${_appDir.path}/binder_images/$fileName',
      );

      if (await file.exists()) {
        await file.delete();
      }
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

  Future<void> saveBinder() async {

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      'binder_$binderId',
      jsonEncode(pages),
    );

    int cardCount = 0;
    String? preview;

    for (var page in pages) {
      for (var fileName in page) {
        if (fileName != null) {
          final file = File(
            '${_appDir.path}/binder_images/$fileName',
          );

          if (file.existsSync()) {
            cardCount++;
            preview ??= fileName;
          }
        }
      }
    }

    final jsonString = prefs.getString("binders");

    if (jsonString == null) return;

    List decoded = jsonDecode(jsonString);

    for (var binder in decoded) {
      if (binder["id"] == binderId) {
        binder["cardCount"] = cardCount;
        binder["preview"] = preview; 
      }
    }

    await prefs.setString("binders", jsonEncode(decoded));
  }

  Future<void> loadBinder() async {

    await _initDir();

    final prefs = await SharedPreferences.getInstance();

    final jsonString =
        prefs.getString('binder_$binderId');

    if (jsonString != null) {

      List decoded = jsonDecode(jsonString);

      pages = decoded.map<List<String?>>((page) {

        return (page as List).map<String?>((fileName) {

          if (fileName == null) return null;

          final file = File(
            '${_appDir.path}/binder_images/$fileName',
          );

          if (!file.existsSync()) return null;

          return fileName;

        }).toList();

      }).toList();
    }

    isLoading = false;
    notifyListeners();
  }
}