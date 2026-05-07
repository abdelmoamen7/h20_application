import 'package:cloud_firestore/cloud_firestore.dart';

/// ======================================================
/// MEAL MODEL
/// ======================================================

class MealModel {

  String? id;

  String? name;

  String? image;

  String? category;

  int? calories;

  double? protein;

  double? carbs;

  double? fats;

  double? fiber;

  double? sugar;

  String? description;

  DateTime? createdAt;

  MealModel(
      this.id,
      this.name,
      this.image,
      this.category,
      this.calories,
      this.protein,
      this.carbs,
      this.fats,
      this.fiber,
      this.sugar,
      this.description,
      this.createdAt,
      );

  factory MealModel.fromJson(
      Map<String, dynamic> json) {

    return MealModel(

      json["id"],

      json["name"],

      json["image"],

      json["category"],

      json["calories"],

      (json["protein"] as num?)
          ?.toDouble(),

      (json["carbs"] as num?)
          ?.toDouble(),

      (json["fats"] as num?)
          ?.toDouble(),

      (json["fiber"] as num?)
          ?.toDouble(),

      (json["sugar"] as num?)
          ?.toDouble(),

      json["description"],

      json["createdAt"] != null
          ? (json["createdAt"] as Timestamp)
          .toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "name": name,

      "image": image,

      "category": category,

      "calories": calories,

      "protein": protein,

      "carbs": carbs,

      "fats": fats,

      "fiber": fiber,

      "sugar": sugar,

      "description": description,

      "createdAt": createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : null,
    };
  }
}