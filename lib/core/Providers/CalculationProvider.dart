import 'package:flutter/material.dart';

import '../../../../models/HealthMetricsModel.dart';
import '../../../../models/UserModel.dart';

class CalculationProvider {

  /// MAIN CALCULATION

  static HealthMetricsModel
  calculate(UserModel user) {

    /// HEIGHT IN METERS

    final heightM =
        user.height / 100;

    /// BMI

    final bmi =
        user.weight /
            (heightM * heightM);

    /// BMR

    final bmr =
    user.gender == "female"

        ? (10 * user.weight) +
        (6.25 * user.height) -
        (5 * user.age) -
        161

        : (10 * user.weight) +
        (6.25 * user.height) -
        (5 * user.age) +
        5;

    /// ACTIVITY MULTIPLIER

    double activityMultiplier =
    _activityMultiplier(
      user.activityLevel,
    );

    /// DAILY CALORIES

    final calories =
    (bmr * activityMultiplier)
        .round();

    /// WATER TARGET

    final water =
        user.weight * 0.035;

    /// PROTEIN

    final protein =
    (user.weight * 1.8)
        .round();

    /// FATS

    final fats =
    ((calories * 0.25) / 9)
        .round();

    /// CARBS

    final carbs =
    ((calories -
        (protein * 4) -
        (fats * 9)) / 4)
        .round();

    /// BMI CATEGORY

    final category =
    _bmiCategory(bmi);

    /// GOAL PROGRESS

    final goalProgress =
    _goalProgress(
      user,
    );

    /// RETURN MODEL

    return HealthMetricsModel(

      id: user.id,

      bmi: bmi,

      calories: calories,

      waterTarget: water,

      proteinTarget: protein,

      carbsTarget: carbs,

      fatsTarget: fats,

      bmiCategory: category,

      headline:
      _headlineFor(category),

      workoutTitle:
      _workoutTitleFor(
        category,
      ),

      workoutDescription:
      _workoutDescriptionFor(
        category,
      ),

      mealTitle:
      _mealTitleFor(
        category,
      ),

      mealDescription:
      _mealDescriptionFor(
        category,
      ),

      profileLabel:
      _profileLabelFor(
        category,
      ),

      goalProgress:
      goalProgress,

      mealCalories:
      calories ~/ 3,

      mealProtein:
      protein ~/ 3,

      mealCarbs:
      carbs ~/ 3,

      primaryMealTag:
      _mealTagFor(
        category,
      ),

      mealIcon:
      _mealIconFor(
        category,
      ),

      bmiText:
      bmi.toStringAsFixed(1),

      waterTargetText:
      "${water.toStringAsFixed(1)} L",
    );
  }

  /// BMI CATEGORY

  static String _bmiCategory(
      double bmi) {

    if (bmi < 18.5) {

      return "Lean Build";
    }

    if (bmi < 25) {

      return "Balanced";
    }

    if (bmi < 30) {

      return "Fat Loss";
    }

    return "Conditioning";
  }

  /// ACTIVITY MULTIPLIER

  static double
  _activityMultiplier(
      String level) {

    switch (level
        .toLowerCase()) {

      case "beginner":
        return 1.2;

      case "moderate":
        return 1.45;

      case "advanced":
        return 1.7;

      default:
        return 1.35;
    }
  }

  /// GOAL PROGRESS

  static double
  _goalProgress(
      UserModel user) {

    double difference =
    (user.weight -
        user.targetWeight)
        .abs();

    if (difference <= 1) {

      return 1;
    }

    if (difference <= 3) {

      return 0.85;
    }

    if (difference <= 6) {

      return 0.70;
    }

    return 0.50;
  }

  /// HEADLINE

  static String
  _headlineFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return
          "Build Strength";

      case "Fat Loss":
        return
          "Transformation Start";

      case "Conditioning":
        return
          "Steady Progress";

      default:
        return
          "Balanced Performance";
    }
  }

  /// WORKOUT TITLE

  static String
  _workoutTitleFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return
          "Full Body Hypertrophy";

      case "Fat Loss":
        return
          "Lower Body Conditioning";

      case "Conditioning":
        return
          "Low Impact Strength";

      default:
        return
          "Push Strength Workout";
    }
  }

  /// WORKOUT DESCRIPTION

  static String
  _workoutDescriptionFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return
          "Focus on compound lifts and progressive overload.";

      case "Fat Loss":
        return
          "Short rests with high intensity circuits.";

      case "Conditioning":
        return
          "Low impact resistance and cardio training.";

      default:
        return
          "Balanced strength and endurance workout.";
    }
  }

  /// MEAL TITLE

  static String
  _mealTitleFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return
          "Power Oats Bowl";

      case "Fat Loss":
        return
          "Salmon Protein Plate";

      case "Conditioning":
        return
          "Chicken Quinoa Bowl";

      default:
        return
          "Balanced Nutrition Bowl";
    }
  }

  /// MEAL DESCRIPTION

  static String
  _mealDescriptionFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return
          "Protein and carbs for muscle growth.";

      case "Fat Loss":
        return
          "High protein with healthy fats.";

      case "Conditioning":
        return
          "Recovery focused balanced nutrition.";

      default:
        return
          "Healthy balanced daily nutrition.";
    }
  }

  /// PROFILE LABEL

  static String
  _profileLabelFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return "Bulking";

      case "Fat Loss":
        return "Cutting";

      case "Conditioning":
        return "Conditioning";

      default:
        return "Balanced";
    }
  }

  /// MEAL TAG

  static String
  _mealTagFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return
          "Mass Gain";

      case "Fat Loss":
        return
          "Low Calories";

      case "Conditioning":
        return
          "Recovery";

      default:
        return
          "Healthy";
    }
  }

  /// MEAL ICON

  static IconData
  _mealIconFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return
          Icons.breakfast_dining;

      case "Fat Loss":
        return
          Icons.set_meal;

      case "Conditioning":
        return
          Icons.rice_bowl;

      default:
        return
          Icons.restaurant;
    }
  }
}