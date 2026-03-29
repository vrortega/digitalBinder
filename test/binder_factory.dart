import 'package:digital_binder/models/binder_model.dart';

BinderModel createBinder({
  String id = '1',
  String name = 'Binder Test',
  int cardCount = 0,
  String? preview,
}) {
  return BinderModel(
    id: id,
    name: name,
    cardCount: cardCount,
    preview: preview,
  );
}