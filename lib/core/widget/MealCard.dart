/// ===============================
/// MEAL CARD
/// ===============================

import 'package:flutter/material.dart';

import '../../../../models/HealthMetricsModel.dart';

class MealCard
    extends StatelessWidget {

  final HealthMetricsModel
  metrics;

  const MealCard({

    super.key,

    required this.metrics,
  });

  @override
  Widget build(BuildContext context) {

    return Card(

      margin:
      const EdgeInsets.symmetric(
        horizontal: 16,
      ),

      shape:
      RoundedRectangleBorder(

        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Padding(

        padding:
        const EdgeInsets.all(20),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(

              "Recommended Meal",

              style: TextStyle(

                fontSize: 18,

                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            ClipRRect(

              borderRadius:
              BorderRadius.circular(18),

              child: Image.network(

                "https://images.unsplash.com/photo-1546069901-ba9599a7e63c",

                height: 180,

                width: double.infinity,

                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 16),

            Text(

              metrics.mealTitle,

              style: const TextStyle(

                fontSize: 20,

                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              metrics.mealDescription,
            ),

            const SizedBox(height: 20),

            Row(

              mainAxisAlignment:
              MainAxisAlignment
                  .spaceBetween,

              children: [

                Text(

                  "${metrics.mealCalories} kcal",
                ),

                Text(

                  "${metrics.mealProtein}g Protein",
                ),

                Text(

                  "${metrics.mealCarbs}g Carbs",
                ),
              ],
            ),

            const SizedBox(height: 20),

            SizedBox(

              width: double.infinity,

              child: ElevatedButton(

                onPressed: () {

                  /// GO TO MEALS SCREEN
                },

                child: const Text(
                  "View Meal",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}