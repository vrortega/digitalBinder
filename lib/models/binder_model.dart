class BinderModel {

  final String id;
  String name;
  int cardCount;
  String? preview;

  BinderModel({
    required this.id,
    required this.name,
    this.cardCount = 0,
    this.preview,
  });

  factory BinderModel.fromJson(Map<String, dynamic> json) {
    return BinderModel(
      id: json["id"],
      name: json["name"],
      cardCount: json["cardCount"] ?? 0,
      preview: json["preview"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "cardCount": cardCount,
      "preview": preview,
    };
  }

}