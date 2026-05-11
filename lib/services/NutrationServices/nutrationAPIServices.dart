import 'dart:convert';

import 'package:http/http.dart'
as http;

import '../../models/nutrition_model.dart';

class NutritionApiService {

  static const String apiKey =

      "uRhpbC6KwT6NfT0c2bPeaNp9daHM11OEWUEQFjKz";

  /// =========================
  /// GET NUTRITION
  /// =========================

  static Future<NutritionModel?>
  getNutrition(
      String query) async {

    try {

      final response =
      await http.get(

        Uri.parse(

          "https://api.api-ninjas.com/v1/nutrition?query=$query",
        ),

        headers: {

          "X-Api-Key":
          apiKey,
        },
      );

      /// DEBUG

      print(
        response.statusCode,
      );

      print(
        response.body,
      );

      /// =========================
      /// SUCCESS
      /// =========================

      if(response.statusCode
          == 200){

        final List data =
        jsonDecode(
          response.body,
        );

        /// EMPTY

        if(data.isEmpty){

          return null;
        }

        final food =
        data[0];

        /// =====================
        /// FOOD NAME
        /// =====================

        final foodName =

        (food["name"] ?? "")
            .toString()
            .toLowerCase();

        /// =====================
        /// VALUES
        /// =====================

        double protein =

        _parseDouble(
          food["protein_g"],
        );

        final carbs =

        _parseDouble(

          food[
          "carbohydrates_total_g"],
        );

        final fat =

        _parseDouble(
          food["fat_total_g"],
        );

        /// =====================
        /// CALORIES
        /// =====================

        double calories =

        _parseDouble(
          food["calories"],
        );

        /// =====================
        /// ESTIMATE PROTEIN
        /// =====================

        if(protein <= 0){

          if(foodName
              .contains(
              "chicken")){

            protein = 31;

          }

          else if(foodName
              .contains(
              "egg")){

            protein = 13;
          }

          else if(foodName
              .contains(
              "beef")){

            protein = 26;
          }

          else if(foodName
              .contains(
              "rice")){

            protein = 2.7;
          }

          else if(foodName
              .contains(
              "milk")){

            protein = 3.4;
          }

          else if(foodName
              .contains(
              "salmon")){

            protein = 25;
          }

          else if(foodName
              .contains(
              "tuna")){

            protein = 29;
          }

          else if(foodName
              .contains(
              "banana")){

            protein = 1.1;
          }

          else {

            /// GENERAL ESTIMATION

            protein =

                (fat * 0.8) +
                    (carbs * 0.2);
          }
        }

        /// =====================
        /// ESTIMATE CALORIES
        /// ==================

        if(calories <= 0){

          calories =

              (protein * 4) +
                  (carbs * 4) +
                  (fat * 9);
        }

        return NutritionModel(

          id:
          DateTime.now()
              .millisecondsSinceEpoch
              .toString(),

          foodName:
          food["name"] ?? "",

          calories:
          calories,

          protein:
          protein,

          fat:
          fat,

          carbs:
          carbs,

          fiber:
          _parseDouble(
            food["fiber_g"],
          ),

          sugar:
          _parseDouble(
            food["sugar_g"],
          ),

          servingSize:
          "${food["serving_size_g"] ?? 0} g",

          sodium:
          _parseDouble(
            food["sodium_mg"],
          ),

          potassium:
          _parseDouble(
            food["potassium_mg"],
          ),

          cholesterol:
          _parseDouble(
            food["cholesterol_mg"],
          ),

          /// Legacy API Ninjas path; new UI uses USDA/OpenFoodFacts instead.
          source: 'API Ninjas',
        );
      }

      return null;

    } catch (e) {

      print(
        "ERROR: $e",
      );

      return null;
    }
  }

  /// =====================
  /// SAFE DOUBLE
  /// =====================

  static double
  _parseDouble(
      dynamic value) {

    if(value == null){

      return 0;
    }

    if(value is num){

      return value.toDouble();
    }

    return 0;
  }
}