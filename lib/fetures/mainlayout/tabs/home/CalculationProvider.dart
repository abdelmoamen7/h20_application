import 'package:flutter/material.dart';
import '../../../../models/HealthMetricsModel.dart';
import '../../../../models/UserModel.dart';

class CalculationProvider
    extends ChangeNotifier {

  HealthMetricsModel? metrics;

  void calculate(UserModel user) {

    final heightM =
        user.height / 100;

    final bmi =
        user.weight /
            (heightM * heightM);

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

    final calories =
    (bmr * 1.35).round();

    final water =
        user.weight * 0.035;

    final protein =
    (user.weight * 1.8).round();

    final fats =
    ((calories * 0.25) / 9).round();

    final carbs =
    ((calories -
        (protein * 4) -
        (fats * 9)) /
        4)
        .round();

    final category =
    _bmiCategory(bmi);

    metrics = HealthMetricsModel(
      id: user.id,
      bmi: bmi,

      calories: calories,

      waterTarget: water,

      proteinTarget: protein,

      carbsTarget: carbs,

      fatsTarget: fats,

      bmiCategory: category,

      /// HEADER

      headline:
      _headlineFor(category),

      profileLabel:
      _profileLabelFor(category),

      goalProgress:
      _goalProgressFor(category),

      /// WORKOUT

      workoutTitle:
      _workoutTitleFor(category),

      workoutDescription:
      _workoutDescriptionFor(category),

      /// MEAL

      mealTitle:
      _mealTitleFor(category),

      mealDescription:
      _mealDescriptionFor(category),

      mealCalories:
      _mealCaloriesFor(category),

      mealProtein:
      _mealProteinFor(category),

      mealCarbs:
      _mealCarbsFor(category),

      primaryMealTag:
      _primaryMealTagFor(category),

      mealIcon:
      _mealIconFor(category),

      /// TEXT

      bmiText:
      bmi.toStringAsFixed(1),

      waterTargetText:
      "${water.toStringAsFixed(1)} L",
    );

    notifyListeners();
  }

  /// BMI CATEGORY

  String _bmiCategory(double bmi) {

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

  /// HEADLINE

  String _headlineFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return "Build Strength";

      case "Fat Loss":
        return "Transformation Start";

      case "Conditioning":
        return "Steady Progress";

      default:
        return "Balanced Performance";
    }
  }

  /// PROFILE LABEL

  String _profileLabelFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return "Muscle Gain";

      case "Fat Loss":
        return "Weight Loss";

      case "Conditioning":
        return "Body Conditioning";

      default:
        return "Balanced Fitness";
    }
  }

  /// GOAL PROGRESS

  double _goalProgressFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return 0.76;

      case "Fat Loss":
        return 0.72;

      case "Conditioning":
        return 0.66;

      default:
        return 0.95;
    }
  }

  /// WORKOUT TITLE

  String _workoutTitleFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return "Full Body Hypertrophy";

      case "Fat Loss":
        return "Lower Body Conditioning";

      case "Conditioning":
        return "Low Impact Strength";

      default:
        return "Lower Body Hypertrophy";
    }
  }

  /// WORKOUT DESCRIPTION

  String _workoutDescriptionFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return "Focus on compound lifts and healthy weight gain.";

      case "Fat Loss":
        return "Strength circuit with short rests.";

      case "Conditioning":
        return "Low impact resistance work.";

      default:
        return "Balanced workout for overall fitness.";
    }
  }

  /// MEAL TITLE

  String _mealTitleFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return "Power Oats";

      case "Fat Loss":
        return "Salmon Protein Plate";

      case "Conditioning":
        return "Chicken Quinoa Bowl";

      default:
        return "Balanced Nutrition Bowl";
    }
  }

  /// MEAL DESCRIPTION

  String _mealDescriptionFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return "Protein and carbs for muscle growth.";

      case "Fat Loss":
        return "High protein and healthy fats.";

      case "Conditioning":
        return "Recovery focused meal.";

      default:
        return "Balanced nutrition.";
    }
  }

  /// MEAL CALORIES

  int _mealCaloriesFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return 780;

      case "Fat Loss":
        return 540;

      case "Conditioning":
        return 620;

      default:
        return 680;
    }
  }

  /// MEAL PROTEIN

  int _mealProteinFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return 45;

      case "Fat Loss":
        return 40;

      case "Conditioning":
        return 38;

      default:
        return 42;
    }
  }

  /// MEAL CARBS

  int _mealCarbsFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return 70;

      case "Fat Loss":
        return 30;

      case "Conditioning":
        return 50;

      default:
        return 55;
    }
  }

  /// MEAL TAG

  String _primaryMealTagFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return "High Protein";

      case "Fat Loss":
        return "Low Carb";

      case "Conditioning":
        return "Recovery Meal";

      default:
        return "Balanced Meal";
    }
  }

  /// MEAL ICON

  IconData _mealIconFor(
      String category) {

    switch (category) {

      case "Lean Build":
        return Icons.breakfast_dining;

      case "Fat Loss":
        return Icons.set_meal;

      case "Conditioning":
        return Icons.rice_bowl;

      default:
        return Icons.restaurant;
    }
  }
}