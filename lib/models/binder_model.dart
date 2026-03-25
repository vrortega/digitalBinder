class BinderModel {

  final String id;
  String name;

  BinderModel({
    required this.id,
    required this.name,
  });

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
    };
  }

  factory BinderModel.fromJson(Map<String, dynamic> json) {
    return BinderModel(
      id: json["id"],
      name: json["name"],
    );
  }

}