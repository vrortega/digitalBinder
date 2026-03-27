class BinderModel {
  final String id;
  final String name;
  final int cardCount;
  final String? preview;

  const BinderModel({
    required this.id,
    required this.name,
    this.cardCount = 0,
    this.preview,
  });

  BinderModel copyWith({
    String? name,
    int? cardCount,
    String? preview,
  }) {
    return BinderModel(
      id: id,
      name: name ?? this.name,
      cardCount: cardCount ?? this.cardCount,
      preview: preview ?? this.preview,
    );
  }

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