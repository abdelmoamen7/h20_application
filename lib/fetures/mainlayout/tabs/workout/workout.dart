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
  State<workout> createState() => workoutState();
}

class workoutState extends State<workout> {
  late Future<List<FreeExerciseModel>> _exercisesFuture;
  final WorkoutApiService _apiService = WorkoutApiService();

  @override
  void initState() {
    super.initState();
    // Defer fetch so tab transition / first paint is not blocked.
    _exercisesFuture = Future.microtask(() => _apiService.fetchExercises());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colorsmanger.Whiteblue,
      body: FutureBuilder<List<FreeExerciseModel>>(
        future: _exercisesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colorsmanger.Blue),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 50.sp),
                  SizedBox(height: 16.h),
                  Text(
                    'Error loading workouts:\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _exercisesFuture = _apiService.fetchExercises(
                          forceRefresh: true,
                        );
                      });
                    },
                    child: const Text('Retry'),
                  ),
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
                _exercisesFuture = _apiService.fetchExercises(
                  forceRefresh: true,
                );
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
                          colors: [
                            Colorsmanger.Blue,
                            Colorsmanger.darkblue.withValues(alpha: 0.8),
                          ],
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
                  padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 100.h),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final exercise = exercises[index];
                      return _ExerciseListItem(
                        exercise: exercise,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ExerciseDetails(exercise: exercise),
                            ),
                          );
                        },
                      );
                    }, childCount: exercises.length),
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

/// GIF (or still image) next to each exercise row — uses dataset CDN URLs from [FreeExerciseModel].
class _ExerciseMediaThumb extends StatelessWidget {
  final FreeExerciseModel exercise;

  const _ExerciseMediaThumb({required this.exercise});

  @override
  Widget build(BuildContext context) {
    final url = exercise.previewMediaUrl;
    final size = 90.w;
    if (url.isEmpty) {
      return Container(
        width: size,
        height: size,
        color: Colors.grey[200],
        child: const Icon(Icons.fitness_center, color: Colors.grey),
      );
    }
    return SizedBox(
      width: size,
      height: size,
      child: Image.network(
        url,
        width: size,
        height: size,
        fit: BoxFit.cover,
        gaplessPlayback: true,
        filterQuality: FilterQuality.low,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return ColoredBox(
            color: Colors.grey[200]!,
            child: const Center(
              child: SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        },
        errorBuilder: (_, __, ___) {
          final still = exercise.stillImageAbsoluteUrl;
          if (exercise.gifAbsoluteUrl.isNotEmpty &&
              still.isNotEmpty &&
              url == exercise.gifAbsoluteUrl) {
            return Image.network(
              still,
              width: size,
              height: size,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: size,
                height: size,
                color: Colors.grey[200],
                child: const Icon(Icons.fitness_center, color: Colors.grey),
              ),
            );
          }
          return Container(
            width: size,
            height: size,
            color: Colors.grey[200],
            child: const Icon(Icons.fitness_center, color: Colors.grey),
          );
        },
      ),
    );
  }
}

class _ExerciseListItem extends StatelessWidget {
  final FreeExerciseModel exercise;
  final VoidCallback onTap;

  const _ExerciseListItem({required this.exercise, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(18.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: _ExerciseMediaThumb(exercise: exercise),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name.toUpperCase(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: Colorsmanger.darkblue,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        '${exercise.target.toUpperCase()} • ${exercise.equipment.toUpperCase()}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          color: Colorsmanger.Grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        exercise.instructions.isNotEmpty
                            ? exercise.instructions.first
                            : 'No instructions provided.',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16.sp,
                  color: Colorsmanger.Blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
