/// ===============================
/// PROGRESS CARD
/// ===============================

import 'package:flutter/material.dart';

import '../../../../models/HealthMetricsModel.dart';

class ProgressCard
    extends StatelessWidget {

  final HealthMetricsModel
  metrics;

  const ProgressCard({

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

              "Daily Progress",

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
                  .spaceBetween,

              children: [

                _metricItem(

                  "BMI",

                  metrics.bmiText,

                  Icons.monitor_weight,
                ),

                _metricItem(

                  "Calories",

                  "${metrics.calories}",

                  Icons.local_fire_department,
                ),

                _metricItem(

                  "Water",

                  metrics.waterTargetText,

                  Icons.water_drop,
                ),
              ],
            ),

            const SizedBox(height: 20),

            LinearProgressIndicator(

              value:
              metrics.goalProgress,
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricItem(

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