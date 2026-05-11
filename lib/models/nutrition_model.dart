class NutritionModel {
  final String id;

  final String foodName;

  final double calories;

  final double protein;

  final double fat;

  final double carbs;

  final double fiber;

  final double sugar;

  final String servingSize;

  final double sodium;

  final double potassium;

  final double cholesterol;

  NutritionModel({

    required this.id,

    required this.foodName,

    required this.calories,

    required this.protein,

    required this.fat,

    required this.carbs,

    required this.fiber,

    required this.sugar,

    required this.servingSize,

    required this.sodium,

    required this.potassium,

    required this.cholesterol,
  });

  factory NutritionModel
      .fromJson(
      Map<String, dynamic> json) {

    return NutritionModel(

      id:
      DateTime.now()
          .millisecondsSinceEpoch
          .toString(),

      foodName:
      json["name"] ?? "",

      calories:
      (json["calories"]
      as num?)
          ?.toDouble() ??
          0,

      protein:
      (json["protein_g"]
      as num?)
          ?.toDouble() ??
          0,

      fat:
      (json["fat_total_g"]
      as num?)
          ?.toDouble() ??
          0,

      carbs:
      (json[
      "carbohydrates_total_g"]
      as num?)
          ?.toDouble() ??
          0,

      fiber:
      (json["fiber_g"]
      as num?)
          ?.toDouble() ??
          0,

      sugar:
      (json["sugar_g"]
      as num?)
          ?.toDouble() ??
          0,

      servingSize:
      "${json["serving_size_g"] ?? 0} g",

      sodium:
      (json["sodium_mg"]
      as num?)
          ?.toDouble() ??
          0,

      potassium:
      (json["potassium_mg"]
      as num?)
          ?.toDouble() ??
          0,

      cholesterol:
      (json["cholesterol_mg"]
      as num?)
          ?.toDouble() ??
          0,
    );
  }

  Map<String, dynamic>
  toJson() {

    return {

      "id": id,

      "foodName":
      foodName,

      "calories":
      calories,

      "protein":
      protein,

      "fat":
      fat,

      "carbs":
      carbs,

      "fiber":
      fiber,

      "sugar":
      sugar,

      "servingSize":
      servingSize,

      "sodium":
      sodium,

      "potassium":
      potassium,

      "cholesterol":
      cholesterol,
    };
  }
}