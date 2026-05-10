/// ===============================
/// MACRO CARD
/// ===============================

import 'package:flutter/material.dart';

import '../../../../models/HealthMetricsModel.dart';

class MacroCard
    extends StatelessWidget {

  final HealthMetricsModel
  metrics;

  const MacroCard({

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

              "Daily Macros",

              style: TextStyle(

                fontSize: 18,

                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Row(

              mainAxisAlignment:
              MainAxisAlignment
                  .spaceAround,

              children: [

                _macroItem(

                  "Protein",

                  "${metrics.proteinTarget}g",

                  Icons.egg,
                ),

                _macroItem(

                  "Carbs",

                  "${metrics.carbsTarget}g",

                  Icons.rice_bowl,
                ),

                _macroItem(

                  "Fats",

                  "${metrics.fatsTarget}g",

                  Icons.water_drop,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _macroItem(

      String title,

      String value,

      IconData icon) {

    return Column(

      children: [

        Icon(icon),

        const SizedBox(height: 8),

        Text(

          value,

          style: const TextStyle(

            fontWeight:
            FontWeight.bold,

            fontSize: 16,
          ),
        ),

        const SizedBox(height: 4),

        Text(title),
      ],
    );
  }
}