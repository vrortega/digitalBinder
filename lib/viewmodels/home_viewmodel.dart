import 'package:flutter/material.dart';
import '../models/binder_model.dart';
import '../repositories/binder_repository.dart';
import '../services/image_service.dart';

enum ViewState { loading, success, error }

class HomeViewModel extends ChangeNotifier {
  final BinderRepository repository;
  final ImageService imageService;

  HomeViewModel({
    required this.repository,
    required this.imageService,
  }) {
    loadBinders();
  }

  List<BinderModel> _binders = [];
  List<BinderModel> get binders => _binders;

  ViewState _state = ViewState.loading;
  ViewState get state => _state;

  Future<void> loadBinders() async {
    try {
      _state = ViewState.loading;
      notifyListeners();

      _binders = await repository.loadBinders();

      _state = ViewState.success;
    } catch (_) {
      _state = ViewState.error;
    }

    notifyListeners();
  }

Future<void> deleteBinder(String binderId) async {
  try {
    final pages = await repository.getBinderPages(binderId);

    if (pages != null) {
      await imageService.deleteImagesFromBinder(pages);
    }

    await repository.deleteBinder(binderId);

    _binders = _binders.where((b) => b.id != binderId).toList();

    await repository.saveBinders(_binders);

    notifyListeners();
  } catch (_) {
    _state = ViewState.error;
    notifyListeners();
  }
}

  Future<BinderModel> createBinder() async {
    final binder = await repository.createBinder(_binders);

    notifyListeners();

    return binder;
  }
}