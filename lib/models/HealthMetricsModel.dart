import 'package:flutter/material.dart';

class HealthMetricsModel {

  String id;

  double bmi;

  int calories;

  double waterTarget;

  int proteinTarget;

  int carbsTarget;

  int fatsTarget;

  String bmiCategory;

  String headline;

  String workoutTitle;

  String workoutDescription;

  String mealTitle;

  String mealDescription;

  String profileLabel;

  double goalProgress;

  int mealCalories;

  int mealProtein;

  int mealCarbs;

  String primaryMealTag;

  IconData mealIcon;

  String bmiText;

  String waterTargetText;

  HealthMetricsModel({
    required this.id,

    required this.bmi,

    required this.calories,

    required this.waterTarget,

    required this.proteinTarget,

    required this.carbsTarget,

    required this.fatsTarget,

    required this.bmiCategory,

    required this.headline,

    required this.workoutTitle,

    required this.workoutDescription,

    required this.mealTitle,

    required this.mealDescription,

    required this.profileLabel,

    required this.goalProgress,

    required this.mealCalories,

    required this.mealProtein,

    required this.mealCarbs,

    required this.primaryMealTag,

    required this.mealIcon,

    required this.bmiText,

    required this.waterTargetText,
  });

  /// FROM JSON
  factory HealthMetricsModel.fromJson(
      Map<String, dynamic> json) {
    return HealthMetricsModel(
      id:
      json["id"] ?? "",

      bmi:
      (json["bmi"] as num?)
          ?.toDouble() ??
          0,

      calories:
      json["calories"] ?? 0,

      waterTarget:
      (json["waterTarget"] as num?)
          ?.toDouble() ??
          0,

      proteinTarget:
      json["proteinTarget"] ?? 0,

      carbsTarget:
      json["carbsTarget"] ?? 0,

      fatsTarget:
      json["fatsTarget"] ?? 0,

      bmiCategory:
      json["bmiCategory"] ?? "",

      headline:
      json["headline"] ?? "",

      workoutTitle:
      json["workoutTitle"] ?? "",

      workoutDescription:
      json["workoutDescription"] ?? "",

      mealTitle:
      json["mealTitle"] ?? "",

      mealDescription:
      json["mealDescription"] ?? "",

      profileLabel:
      json["profileLabel"] ?? "",

      goalProgress:
      (json["goalProgress"] as num?)
          ?.toDouble() ??
          0,

      mealCalories:
      json["mealCalories"] ?? 0,

      mealProtein:
      json["mealProtein"] ?? 0,

      mealCarbs:
      json["mealCarbs"] ?? 0,

      primaryMealTag:
      json["primaryMealTag"] ?? "",

      mealIcon:
      Icons.restaurant,

      bmiText:
      json["bmiText"] ?? "",

      waterTargetText:
      json["waterTargetText"] ?? "",
    );
  }
  Map<String, dynamic> toJosn() {

    return {
      "id": id,
      "bmi": bmi,

      "calories": calories,

      "waterTarget": waterTarget,

      "proteinTarget":
      proteinTarget,

      "carbsTarget":
      carbsTarget,

      "fatsTarget":
      fatsTarget,

      "bmiCategory":
      bmiCategory,

      "headline":
      headline,

      "workoutTitle":
      workoutTitle,

      "workoutDescription":
      workoutDescription,

      "mealTitle":
      mealTitle,

      "mealDescription":
      mealDescription,

      "profileLabel":
      profileLabel,

      "goalProgress":
      goalProgress,

      "mealCalories":
      mealCalories,

      "mealProtein":
      mealProtein,

      "mealCarbs":
      mealCarbs,

      "primaryMealTag":
      primaryMealTag,

      "bmiText":
      bmiText,

      "waterTargetText":
      waterTargetText,
    };
  }
}