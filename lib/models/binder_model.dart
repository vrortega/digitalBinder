import 'dart:io';

class BinderModel {

  List<File?> cards;

  BinderModel({
    List<File?>? cards,
  }) : cards = cards ?? [null, null, null, null];

}