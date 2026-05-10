import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/colorsmanger/colorsmanger.dart';
import '../../../../core/widget/FreeExerciseCard.dart';
import '../../../../models/FreeExerciseModel.dart';
import '../../../../services/WorkoutServcies/WorkoutApiService.dart';

class workout extends StatefulWidget {
  const workout({super.key});

  @override
  State<workout> createState() => _workoutState();
}

class _workoutState extends State<workout> {
  late Future<List<FreeExerciseModel>> _exercisesFuture;
  final WorkoutApiService _apiService = WorkoutApiService();

  @override
  void initState() {
    super.initState();
    _exercisesFuture = _apiService.fetchExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorsmanger.Whiteblue,
      body: FutureBuilder<List<FreeExerciseModel>>(
        future: _exercisesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Colorsmanger.Blue));
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 50.sp),
                  SizedBox(height: 16.h),
                  Text('Error loading workouts:\n${snapshot.error}', textAlign: TextAlign.center),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _exercisesFuture = _apiService.fetchExercises();
                      });
                    },
                    child: const Text('Retry'),
                  )
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No workouts found.'));
          }

          final exercises = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _exercisesFuture = _apiService.fetchExercises();
              });
            },
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 120.h,
                  floating: true,
                  pinned: true,
                  backgroundColor: Colorsmanger.Blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30.r),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(
                      "Discover Workouts",
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colorsmanger.Blue, Colorsmanger.darkblue.withValues(alpha: 0.8)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(30.r),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(top: 20.h, bottom: 100.h),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return FreeExerciseCard(exercise: exercises[index]);
                      },
                      childCount: exercises.length,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
