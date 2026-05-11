import 'package:flutter/material.dart';

import '../../../../models/nutrition_model.dart';

import '../../../../services/NutrationServices/nutrationAPIServices.dart';

class NutritionScreen
    extends StatefulWidget {

  const NutritionScreen({
    super.key,
  });

  @override
  State<NutritionScreen>
  createState() =>
      _NutritionScreenState();
}

class _NutritionScreenState
    extends State<NutritionScreen> {

  /// =========================
  /// CONTROLLER
  /// =========================

  final TextEditingController
  foodController =
  TextEditingController();

  /// =========================
  /// DATA
  /// =========================

  NutritionModel? nutrition;

  /// =========================
  /// LOADING
  /// =========================

  bool isLoading = false;

  /// =========================
  /// SEARCH FUNCTION
  /// =========================

  Future<void>
  searchNutrition() async {

    if(foodController.text
        .trim()
        .isEmpty){

      return;
    }

    /// HIDE KEYBOARD

    FocusScope.of(context)
        .unfocus();

    setState(() {

      isLoading = true;
    });

    final result =

    await NutritionApiService
        .getNutrition(

      foodController.text,
    );

    setState(() {

      nutrition = result;

      isLoading = false;
    });
  }

  /// =========================
  /// DISPOSE
  /// =========================

  @override
  void dispose() {

    foodController.dispose();

    super.dispose();
  }

  @override
  Widget build(
      BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title:
        const Text(
          "Nutrition",
        ),

        centerTitle: true,
      ),

      body: Padding(

        padding:
        const EdgeInsets.all(16),

        child:
        SingleChildScrollView(

          child: Column(

            children: [

              /// =========================
              /// TEXT FIELD
              /// =========================

              TextFormField(

                controller:
                foodController,

                decoration:
                InputDecoration(

                  hintText:
                  "Example: chicken rice",

                  prefixIcon:
                  const Icon(
                    Icons.search,
                  ),

                  border:
                  OutlineInputBorder(

                    borderRadius:
                    BorderRadius.circular(
                        16),
                  ),
                ),
              ),

              const SizedBox(
                height: 16,
              ),

              /// =========================
              /// BUTTON
              /// =========================

              SizedBox(

                width:
                double.infinity,

                height: 55,

                child: ElevatedButton(

                  onPressed:
                  isLoading
                      ? null
                      : searchNutrition,

                  child: const Text(
                    "Analyze Food",
                  ),
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              /// =========================
              /// LOADING
              /// =========================

              if(isLoading)

                const Center(

                  child:
                  CircularProgressIndicator(),
                ),

              /// =========================
              /// EMPTY
              /// =========================

              if(!isLoading &&
                  nutrition == null)

                const Padding(

                  padding:
                  EdgeInsets.only(
                    top: 40,
                  ),

                  child: Text(

                    "Search for food to display nutrition data",
                  ),
                ),

              /// =========================
              /// DATA
              /// =========================

              if(!isLoading &&
                  nutrition != null)

                Column(

                  children: [

                    /// IMAGE

                    Container(

                      height: 180,

                      width:
                      double.infinity,

                      decoration:
                      BoxDecoration(

                        borderRadius:
                        BorderRadius.circular(
                            20),

                        image:
                        const DecorationImage(

                          image:
                          NetworkImage(

                            "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",
                          ),

                          fit:
                          BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    /// FOOD NAME

                    Text(

                      nutrition!
                          .foodName,

                      style:
                      const TextStyle(

                        fontSize: 24,

                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    /// CALORIES

                    nutritionCard(

                      "Calories",

                      "${nutrition!.calories.toStringAsFixed(0)} kcal",

                      Icons.local_fire_department,
                    ),

                    /// PROTEIN

                    nutritionCard(

                      "Protein",

                      "${nutrition!.protein.toStringAsFixed(1)} g",

                      Icons.fitness_center,
                    ),

                    /// CARBS

                    nutritionCard(

                      "Carbs",

                      "${nutrition!.carbs.toStringAsFixed(1)} g",

                      Icons.rice_bowl,
                    ),

                    /// FATS

                    nutritionCard(

                      "Fats",

                      "${nutrition!.fat.toStringAsFixed(1)} g",

                      Icons.water_drop,
                    ),

                    /// FIBER

                    nutritionCard(

                      "Fiber",

                      "${nutrition!.fiber.toStringAsFixed(1)} g",

                      Icons.eco,
                    ),

                    /// SUGAR

                    nutritionCard(

                      "Sugar",

                      "${nutrition!.sugar.toStringAsFixed(1)} g",

                      Icons.cake,
                    ),

                    /// SODIUM

                    nutritionCard(

                      "Sodium",

                      "${nutrition!.sodium.toStringAsFixed(1)} mg",

                      Icons.water,
                    ),

                    /// POTASSIUM

                    nutritionCard(

                      "Potassium",

                      "${nutrition!.potassium.toStringAsFixed(1)} mg",

                      Icons.bolt,
                    ),

                    /// CHOLESTEROL

                    nutritionCard(

                      "Cholesterol",

                      "${nutrition!.cholesterol.toStringAsFixed(1)} mg",

                      Icons.favorite,
                    ),

                    /// SERVING SIZE

                    nutritionCard(

                      "Serving Size",

                      nutrition!.servingSize,

                      Icons.restaurant,
                    ),

                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// =========================
  /// CARD
  /// =========================

  Widget nutritionCard(

      String title,

      String value,

      IconData icon) {

    return Card(

      margin:
      const EdgeInsets.only(
        bottom: 12,
      ),

      shape:
      RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(
            18),
      ),

      child: ListTile(

        leading:
        Icon(icon),

        title:
        Text(title),

        trailing:
        Text(

          value,

          style:
          const TextStyle(

            fontWeight:
            FontWeight.bold,
          ),
        ),
      ),
    );
  }
}