import 'dart:convert';
import '../models/binder_model.dart';
import '../services/storage_service.dart';

class BinderRepository {
  final StorageService storage;

  BinderRepository(this.storage);

  static const _bindersKey = "binders";

  Future<List<BinderModel>> loadBinders() async {
    final jsonString = await storage.getString(_bindersKey);

    if (jsonString == null) return [];

    final List decoded = jsonDecode(jsonString);

    return decoded.map((e) => BinderModel.fromJson(e)).toList();
  }

  Future<void> saveBinders(List<BinderModel> binders) async {
    await storage.setString(
      _bindersKey,
      jsonEncode(binders.map((e) => e.toJson()).toList()),
    );
  }

  Future<List<List<String?>>?> getBinderPages(String binderId) async {
    final data = await storage.getString('binder_$binderId');

    if (data == null) return null;

    final decoded = jsonDecode(data);

    return (decoded as List)
        .map<List<String?>>((page) => List<String?>.from(page))
        .toList();
  }

  Future<void> saveBinder(
    String binderId,
    List<List<String?>> pages,
  ) async {
    await storage.setString(
      'binder_$binderId',
      jsonEncode(pages),
    );
  }

  Future<void> deleteBinder(String binderId) async {
    await storage.remove('binder_$binderId');
  }

  Future<BinderModel> createBinder(List<BinderModel> binders) async {
    final binder = BinderModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: "New Binder",
    );

    final updated = [...binders, binder];

    await saveBinders(updated);

    return binder;
  }
}