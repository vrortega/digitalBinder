import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import '../repositories/binder_repository.dart';
import '../services/image_service.dart';
import '../services/picker_service.dart';
import '../services/binder_service.dart';

enum ViewState { loading, success, error }

class BinderViewModel extends ChangeNotifier {
  final String binderId;
  final BinderRepository repository;
  final ImageService imageService;
  final PickerService pickerService;
  final BinderService binderService;

  BinderViewModel({
    required this.binderId,
    required this.repository,
    required this.imageService,
    required this.pickerService,
    required this.binderService,
  }) {
    loadBinder();
  }

  List<List<String?>> _pages = [[null, null, null, null]];
  int _currentPage = 0;
  ViewState _state = ViewState.loading;

  final Set<String> _favorites = {};

  List<List<String?>> get pages => _pages;
  int get currentPage => _currentPage;
  ViewState get state => _state;

  bool get hasPreviousPage => _currentPage > 0;

  bool isFavorite(String fileName) => _favorites.contains(fileName);

  String get _favoritesKey => 'favorites_$binderId';

  Future<void> _loadFavorites() async {
    final json = await repository.storage.getString(_favoritesKey);

    if (json == null) return;

    final List decoded = jsonDecode(json);
    _favorites.addAll(decoded.cast<String>());
  }

  Future<void> _saveFavorites() async {
    await repository.storage.setString(
      _favoritesKey,
      jsonEncode(_favorites.toList()),
    );
  }

  void toggleFavorite(int index) async {
    final fileName = _pages[_currentPage][index];
    if (fileName == null) return;

    if (_favorites.contains(fileName)) {
      _favorites.remove(fileName);
    } else {
      _favorites.add(fileName);
    }

    await _saveFavorites(); // 🔥 salva
    notifyListeners();
  }

  Future<void> loadBinder() async {
    try {
      _state = ViewState.loading;

      final data = await repository.getBinderPages(binderId);

      if (data != null) {
        _pages = data;
      }

      await _loadFavorites(); // 🔥 carrega favoritos

      _state = ViewState.success;
    } catch (_) {
      _state = ViewState.error;
    }

    notifyListeners();
  }

  Future<List<File?>> get cards async {
    return Future.wait(
      _pages[_currentPage].map((fileName) async {
        if (fileName == null) return null;
        return imageService.getImageFile(fileName);
      }),
    );
  }

  Future<void> pickImage(int index) async {
    final file = await pickerService.pickImage();
    if (file == null) return;

    final fileName = await imageService.saveImage(file);
    _pages[_currentPage][index] = fileName;

    await _persist();
  }

  Future<void> deleteCard(int index) async {
    final fileName = _pages[_currentPage][index];

    if (fileName != null) {
      await imageService.deleteImage(fileName);
      _favorites.remove(fileName);
      await _saveFavorites(); 
    }

    _pages[_currentPage][index] = null;

    await _persist();
  }

  Future<void> reorderCards(int oldIndex, int newIndex) async {
    final page = _pages[_currentPage];

    final temp = page[oldIndex];
    page[oldIndex] = page[newIndex];
    page[newIndex] = temp;

    await _persist();
  }

  Future<void> _persist() async {
    await repository.saveBinder(binderId, _pages);

    final cardCount = binderService.calculateCardCount(_pages);
    final preview = binderService.getPreview(_pages);

    final binders = await repository.loadBinders();

    final updated = binders.map((binder) {
      if (binder.id == binderId) {
        return binder.copyWith(
          cardCount: cardCount,
          preview: preview,
        );
      }
      return binder;
    }).toList();

    await repository.saveBinders(updated);

    notifyListeners();
  }

  void nextPage() {
    if (_currentPage == _pages.length - 1) {
      _pages.add([null, null, null, null]);
    }

    _currentPage++;
    notifyListeners();
  }

  void previousPage() {
    if (_currentPage > 0) {
      _currentPage--;
      notifyListeners();
    }
  }
}