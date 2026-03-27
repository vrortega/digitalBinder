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

  List<List<String?>> get pages => _pages;
  int get currentPage => _currentPage;
  ViewState get state => _state;

  bool get hasPreviousPage => _currentPage > 0;

  Future<void> loadBinder() async {
    try {
      _state = ViewState.loading;

      final data = await repository.getBinderPages(binderId);

      if (data != null) {
        _pages = data;
      }

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