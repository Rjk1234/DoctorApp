import 'dart:convert';

class DoctorModel {
  String name;
  String type;
  String description;
  double rating;
  double goodReviews;
  double totalScore;
  double satisfaction;
  bool isfavourite;
  String image;

  DoctorModel({
    required this.name,
    required this.type,
    required this.description,
    required this.rating,
    required this.goodReviews,
    required this.totalScore,
    required this.satisfaction,
    required this.isfavourite,
    required this.image,
  });

  DoctorModel copyWith({
    String? name,
    String? type,
    String? description,
    double? rating,
    double? goodReviews,
    double? totalScore,
    double? satisfaction,
    bool? isfavourite,
    String? image,
  }) =>
      DoctorModel(
        name: name ?? this.name,
        type: type ?? this.type,
        description: description ?? this.description,
        rating: rating ?? this.rating,
        goodReviews: goodReviews ?? this.goodReviews,
        totalScore: totalScore ?? this.totalScore,
        satisfaction: satisfaction ?? this.satisfaction,
        isfavourite: isfavourite ?? this.isfavourite,
        image: image ?? this.image,
      );

  factory DoctorModel.fromRawJson(String str) =>
      DoctorModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory DoctorModel.fromJson(Map<String, dynamic> json) => DoctorModel(
        name: json["name"] == null ? null : json["name"],
        type: json["type"] == null ? null : json["type"],
        description: json["description"] == null ? null : json["description"],
        rating: json["rating"] == null ? null : json["rating"].toDouble(),
        goodReviews:
            json["goodReviews"] == null ? null : json["goodReviews"].toDouble(),
        totalScore:
            json["totalScore"] == null ? null : json["totalScore"].toDouble(),
        satisfaction: json["satisfaction"] == null
            ? null
            : json["satisfaction"].toDouble(),
        isfavourite: json["isfavourite"] == null ? null : json["isfavourite"],
        image: json["image"] == null ? null : json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "description": description,
        "rating": rating,
        "goodReviews": goodReviews,
        "totalScore": totalScore,
        "satisfaction": satisfaction,
        "isfavourite": isfavourite,
        "image": image,
      };
}
