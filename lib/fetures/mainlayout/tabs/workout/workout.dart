import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/colorsmanger/colorsmanger.dart';
import '../../../../core/widget/FreeExerciseCard.dart';
import '../../../../l10n/app_localizations.dart';
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
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';
  String _selectedCategory = 'All';

  // Category → color mapping
  static const Map<String, Color> _categoryColors = {
    'All': Colorsmanger.Blue,
    'chest': Color(0xFFEF5350),
    'back': Color(0xFF42A5F5),
    'shoulders': Color(0xFFAB47BC),
    'upper arms': Color(0xFFFF7043),
    'lower arms': Color(0xFFFFCA28),
    'upper legs': Color(0xFF26A69A),
    'lower legs': Color(0xFF66BB6A),
    'waist': Color(0xFFEC407A),
    'cardio': Color(0xFF29B6F6),
    'neck': Color(0xFF8D6E63),
  };

  @override
  void initState() {
    super.initState();
    _exercisesFuture = Future.microtask(() => _apiService.fetchExercises());
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase().trim());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<FreeExerciseModel> _filtered(List<FreeExerciseModel> all) {
    return all.where((e) {
      final matchCat = _selectedCategory == 'All' ||
          e.bodyPart.toLowerCase() == _selectedCategory.toLowerCase();
      final matchSearch = _searchQuery.isEmpty ||
          e.name.toLowerCase().contains(_searchQuery) ||
          e.target.toLowerCase().contains(_searchQuery) ||
          e.bodyPart.toLowerCase().contains(_searchQuery) ||
          e.equipment.toLowerCase().contains(_searchQuery);
      return matchCat && matchSearch;
    }).toList();
  }

  Color _colorFor(String bodyPart) {
    return _categoryColors[bodyPart.toLowerCase()] ?? Colorsmanger.Blue;
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colorsmanger.Whiteblue,
      body: FutureBuilder<List<FreeExerciseModel>>(
        future: _exercisesFuture,
        builder: (context, snapshot) {
          // ── Loading ──────────────────────────────────────────────────────
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildLoadingState();
          }

          // ── Error ────────────────────────────────────────────────────────
          if (snapshot.hasError) {
            return _buildErrorState(l, snapshot.error);
          }

          // ── Empty ────────────────────────────────────────────────────────
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(l.no_workouts_found));
          }

          final all = snapshot.data!;
          final filtered = _filtered(all);

          // Build category list from data
          final categories = ['All', ...{...all.map((e) => e.bodyPart.toLowerCase())}
              .where((c) => c.isNotEmpty)
              .toList()
            ..sort()];

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _exercisesFuture =
                    _apiService.fetchExercises(forceRefresh: true);
              });
            },
            child: CustomScrollView(
              slivers: [
                // ── App Bar ────────────────────────────────────────────────
                SliverAppBar(
                  expandedHeight: 130.h,
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
                    titlePadding:
                        EdgeInsets.only(bottom: 16.h, left: 16.w, right: 16.w),
                    title: Text(
                      '${l.discover_workouts}  •  ${filtered.length}',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 15.sp,
                      ),
                    ),
                    background: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colorsmanger.Blue,
                            Colorsmanger.darkblue.withValues(alpha: 0.85),
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

                // ── Search Bar ─────────────────────────────────────────────
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: GoogleFonts.inter(
                          fontSize: 14.sp,
                          color: Colorsmanger.darkblue,
                        ),
                        decoration: InputDecoration(
                          hintText: l.search_exercise,
                          hintStyle: GoogleFonts.inter(
                            color: Colorsmanger.Grey,
                            fontSize: 14.sp,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: Colorsmanger.Blue,
                            size: 22.sp,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: Icon(Icons.close_rounded,
                                      color: Colorsmanger.Grey, size: 20.sp),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() => _searchQuery = '');
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 14.h),
                        ),
                      ),
                    ),
                  ),
                ),

                // ── Category Filter Chips ──────────────────────────────────
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 52.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 8.h),
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => SizedBox(width: 8.w),
                      itemBuilder: (context, index) {
                        final cat = categories[index];
                        final isSelected = _selectedCategory == cat;
                        final color = cat == 'All'
                            ? Colorsmanger.Blue
                            : _colorFor(cat);
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedCategory = cat),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: EdgeInsets.symmetric(
                                horizontal: 14.w, vertical: 6.h),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? color
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: isSelected
                                    ? color
                                    : Colors.grey.shade200,
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: color.withValues(alpha: 0.3),
                                        blurRadius: 6,
                                        offset: const Offset(0, 3),
                                      )
                                    ]
                                  : [],
                            ),
                            child: Text(
                              cat == 'All'
                                  ? cat
                                  : cat[0].toUpperCase() + cat.substring(1),
                              style: GoogleFonts.inter(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                                color: isSelected ? Colors.white : Colorsmanger.Grey,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // ── Exercise List ──────────────────────────────────────────
                filtered.isEmpty
                    ? SliverFillRemaining(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off_rounded,
                                  size: 60.sp,
                                  color: Colors.grey.shade300),
                              SizedBox(height: 16.h),
                              Text(
                                l.no_workouts_found,
                                style: GoogleFonts.inter(
                                  fontSize: 16.sp,
                                  color: Colorsmanger.Grey,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding:
                            EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 100.h),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final exercise = filtered[index];
                              return _ExerciseListItem(
                                exercise: exercise,
                                accentColor: _colorFor(exercise.bodyPart),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ExerciseDetails(
                                          exercise: exercise),
                                    ),
                                  );
                                },
                              );
                            },
                            childCount: filtered.length,
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

  Widget _buildLoadingState() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 130.h,
          pinned: true,
          backgroundColor: Colorsmanger.Blue,
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.vertical(bottom: Radius.circular(30.r)),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colorsmanger.Blue,
                    Colorsmanger.darkblue.withValues(alpha: 0.85)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(30.r)),
              ),
            ),
          ),
        ),
        const SliverFillRemaining(
          child: Center(
              child: CircularProgressIndicator(color: Colorsmanger.Blue)),
        ),
      ],
    );
  }

  Widget _buildErrorState(AppLocalizations l, Object? error) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline_rounded,
                color: Colors.red.shade400, size: 60.sp),
            SizedBox(height: 16.h),
            Text(
              l.error_loading_workouts,
              style: GoogleFonts.inter(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colorsmanger.darkblue,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 12.sp, color: Colorsmanger.Grey),
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _exercisesFuture =
                      _apiService.fetchExercises(forceRefresh: true);
                });
              },
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colorsmanger.Blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Exercise Media Thumbnail ─────────────────────────────────────────────────
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
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(14.r),
        ),
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
          return Container(
            color: Colors.grey[200],
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

// ── Exercise List Item ───────────────────────────────────────────────────────
class _ExerciseListItem extends StatelessWidget {
  final FreeExerciseModel exercise;
  final VoidCallback onTap;
  final Color accentColor;

  const _ExerciseListItem({
    required this.exercise,
    required this.onTap,
    required this.accentColor,
  });

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
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: _ExerciseMediaThumb(exercise: exercise),
                ),
                SizedBox(width: 12.w),
                // Info
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
                      // Muscle group + equipment tags
                      Row(
                        children: [
                          _tag(exercise.bodyPart, accentColor),
                          SizedBox(width: 6.w),
                          if (exercise.equipment.isNotEmpty)
                            _tag(exercise.equipment, Colors.grey.shade400),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        exercise.instructions.isNotEmpty
                            ? exercise.instructions.first
                            : '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11.sp,
                          color: Colors.black54,
                          height: 1.4,
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

  Widget _tag(String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 9.sp,
          fontWeight: FontWeight.w700,
          color: color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
