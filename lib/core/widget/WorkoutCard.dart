/// ===============================
/// TODAY WORKOUT SECTION
/// ===============================

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../models/HealthMetricsModel.dart';
import '../../../../models/FreeExerciseModel.dart';
import '../../../../services/WorkoutServcies/WorkoutApiService.dart';
import '../colorsmanger/colorsmanger.dart';
import 'FreeExerciseCard.dart';

class WorkoutCard extends StatefulWidget {
  final HealthMetricsModel metrics;

  const WorkoutCard({
    super.key,
    required this.metrics,
  });

  @override
  State<WorkoutCard> createState() => _WorkoutCardState();
}

class _WorkoutCardState extends State<WorkoutCard> {
  late Future<List<FreeExerciseModel>> _exercisesFuture;
  final WorkoutApiService _apiService = WorkoutApiService();
  static const String _imageBaseUrl = 'https://raw.githubusercontent.com/hasaneyldrm/exercises-dataset/main/';

  @override
  void initState() {
    super.initState();
    _exercisesFuture = _apiService.fetchExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Workouts",
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colorsmanger.darkblue,
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigate to Workout tab (handled by bottom nav usually)
                },
                child: Text(
                  "See All",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colorsmanger.Blue,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 15.h),
        SizedBox(
          height: 220.h,
          child: FutureBuilder<List<FreeExerciseModel>>(
            future: _exercisesFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator(color: Colorsmanger.Blue));
              } else if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text("No workouts available.", style: GoogleFonts.inter(color: Colorsmanger.Grey)));
              }

              // Take only 3 random/first exercises for the home page
              final workouts = snapshot.data!.take(3).toList();

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 15.w),
                itemCount: workouts.length,
                itemBuilder: (context, index) {
                  final exercise = workouts[index];
                  final String? gifPath = exercise.gifUrl.isNotEmpty ? exercise.gifUrl : null;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ExerciseDetails(exercise: exercise),
                        ),
                      );
                    },
                    child: Container(
                      width: 280.w,
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                            child: gifPath != null 
                              ? Image.network(
                                  '$_imageBaseUrl$gifPath',
                                  height: 120.h,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) => Container(
                                    height: 120.h, color: Colors.grey[300],
                                    child: Icon(Icons.fitness_center, color: Colors.grey)
                                  ),
                                )
                              : Container(
                                  height: 120.h,
                                  width: double.infinity,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.fitness_center, color: Colors.grey),
                                ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(15.w),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        exercise.name.toUpperCase(),
                                        style: GoogleFonts.inter(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colorsmanger.darkblue,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 4.h),
                                      Row(
                                        children: [
                                          Icon(Icons.local_fire_department_outlined, size: 14.sp, color: Colors.orange),
                                          SizedBox(width: 4.w),
                                          Expanded(
                                            child: Text(
                                              exercise.target.toUpperCase(),
                                              style: GoogleFonts.inter(
                                                fontSize: 12.sp,
                                                color: Colorsmanger.Grey,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.w),
                                  margin: EdgeInsets.only(left: 10.w),
                                  decoration: BoxDecoration(
                                    color: Colorsmanger.Blue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(Icons.play_arrow, color: Colors.white, size: 20.sp),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}