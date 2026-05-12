import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/Providers/CalculationProvider.dart';
import '../../../../core/colorsmanger/colorsmanger.dart';
import '../../../../l10n/app_localizations.dart';

import '../../../../core/widget/FreeExerciseCard.dart';
import '../../../../core/widget/MacroCard.dart';
import '../../../../core/widget/ProgressCard.dart';
import '../../../../core/widget/WorkoutCard.dart';
import '../../../../models/FreeExerciseModel.dart';
import '../../../../models/UserModel.dart';
import '../../../../models/HealthMetricsModel.dart';

import '../../../../services/FirebaseServcies/firebaseService.dart';
import '../../../../services/WorkoutServcies/WorkoutApiService.dart';
import '../../main_tab_scope.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  static const int _tabNutrition = 1;
  static const int _tabWorkout = 2;
  static const int _tabProfile = 3;

  // Stream is created once in initState, not on every rebuild
  late final Stream<UserModel?> _userStream;

  @override
  void initState() {
    super.initState();
    _userStream = Fairebaeservices.streamCurrentUser();
  }

  void _goNutrition(BuildContext context) =>
      MainTabScope.goTo(context, _tabNutrition);

  void _goWorkout(BuildContext context) => MainTabScope.goTo(context, _tabWorkout);

  void _goProfile(BuildContext context) => MainTabScope.goTo(context, _tabProfile);

  void _showNotificationsSheet(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(24.w, 20.h, 24.w, 24.h + MediaQuery.paddingOf(ctx).bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l.notifications,
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colorsmanger.darkblue,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              l.notifications_empty,
              style: GoogleFonts.inter(fontSize: 14.sp, color: Colorsmanger.Grey, height: 1.4),
            ),
            SizedBox(height: 20.h),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(ctx),
                style: FilledButton.styleFrom(
                  backgroundColor: Colorsmanger.Blue,
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                ),
                child: Text(l.ok, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMotivationSheet(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.45,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        builder: (_, scrollController) => ListView(
          controller: scrollController,
          padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 24.h + MediaQuery.paddingOf(ctx).bottom),
          children: [
            Text(
              l.stay_motivated,
              style: GoogleFonts.inter(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: Colorsmanger.darkblue,
              ),
            ),
            SizedBox(height: 16.h),
            _motivationTip(l.motivation_tip1),
            _motivationTip(l.motivation_tip2),
            _motivationTip(l.motivation_tip3),
            SizedBox(height: 12.h),
            FilledButton(
              onPressed: () {
                Navigator.pop(ctx);
                _goWorkout(context);
              },
              style: FilledButton.styleFrom(backgroundColor: Colorsmanger.Blue),
              child: Text(l.go_to_workouts, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _motivationTip(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_circle_outline, color: Colorsmanger.Blue, size: 22.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(fontSize: 14.sp, color: Colorsmanger.Grey, height: 1.45),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openQuickExercise(BuildContext context, String label) async {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );
    try {
      final list = await WorkoutApiService().fetchExercises();
      final q = label.toLowerCase().replaceAll('-', ' ');
      FreeExerciseModel? match;
      for (final e in list) {
        final n = e.name.toLowerCase();
        if (n.contains(q) || q.split(' ').where((w) => w.isNotEmpty).every((w) => n.contains(w))) {
          match = e;
          break;
        }
      }
      if (!context.mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      if (match != null) {
        await Navigator.push<void>(
          context,
          MaterialPageRoute<void>(builder: (_) => ExerciseDetails(exercise: match!)),
        );
      } else {
        _goWorkout(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.browse_workouts_hint)),
        );
      }
    } catch (_) {
      if (context.mounted) {
        Navigator.of(context, rootNavigator: true).pop();
        _goWorkout(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: _userStream,
      // Use cached user so the UI renders immediately without waiting for Firestore
      initialData: UserModel.currentUser,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            snapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == null) {
          return Center(child: Text(AppLocalizations.of(context)!.no_user_data));
        }

        UserModel user = snapshot.data!;
        HealthMetricsModel metrics = CalculationProvider.calculate(user);

        // Daily calorie progress (0.0 – 1.0)
        final calTarget = metrics.calories > 0 ? metrics.calories : 1;
        final calProgress = (user.dailyCaloriesConsumed / calTarget).clamp(0.0, 1.0);

        // Daily protein progress (0.0 – 1.0)
        final proteinTarget = metrics.proteinTarget > 0 ? metrics.proteinTarget : 1;
        final proteinProgress = (user.dailyProteinConsumed / proteinTarget).clamp(0.0, 1.0);

        // Daily water progress (0.0 – 1.0)
        final waterTarget = metrics.waterTarget > 0 ? metrics.waterTarget : 1.0;
        final waterProgress = (user.dailyWaterConsumed / waterTarget).clamp(0.0, 1.0);

        return Scaffold(
          backgroundColor: Colorsmanger.Whiteblue,
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildModernHeader(user, context),
              SizedBox(height: 25.h),
              
              _buildDailyProgressGrid(user, metrics, calProgress, waterProgress, proteinProgress),
              SizedBox(height: 25.h),

              ProgressCard(
                metrics: metrics,
                user: user,
              ),
              SizedBox(height: 25.h),
              
              WorkoutCard(
                metrics: metrics,
                onSeeAll: () => _goWorkout(context),
              ),
              SizedBox(height: 25.h),
              
              MacroCard(
                metrics: metrics,
                onTap: () => _goNutrition(context),
                onLogMeal: () => _goNutrition(context),
              ),
              SizedBox(height: 25.h),
              
              _buildRecommendedExercises(context),
              SizedBox(height: 25.h),

              _buildMotivationBanner(context),
              SizedBox(height: 120.h), // padding for floating nav bar
            ],
          ),
        );
      },
    );
  }

  Widget _buildModernHeader(UserModel user, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 60.h, bottom: 25.h, left: 20.w, right: 20.w),
      decoration: BoxDecoration(
        color: Colorsmanger.Blue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.r),
          bottomRight: Radius.circular(40.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colorsmanger.Blue.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _goProfile(context),
              customBorder: const CircleBorder(),
              child: CircleAvatar(
                radius: 32.r,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                backgroundImage: user.profileImage != null && user.profileImage!.isNotEmpty
                    ? NetworkImage(user.profileImage!)
                    : null,
                child: user.profileImage == null || user.profileImage!.isEmpty
                    ? Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                        style: GoogleFonts.inter(
                          fontSize: 26.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : null,
              ),
            ),
          ),
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.good_morning_greeting,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  user.name,
                  style: GoogleFonts.inter(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  AppLocalizations.of(context)!.ready_to_crush,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () => _showNotificationsSheet(context),
            borderRadius: BorderRadius.circular(20.r),
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Stack(
                children: [
                  Icon(Icons.notifications_none, color: Colors.white, size: 24.sp),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: const BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyProgressGrid(UserModel user, HealthMetricsModel metrics,
      double calProgress, double waterProgress, double proteinProgress) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppLocalizations.of(context)!.daily_progress,
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colorsmanger.darkblue,
            ),
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Expanded(
                child: _buildGridCard(
                  AppLocalizations.of(context)!.calories,
                  "${user.dailyCaloriesConsumed} / ${metrics.calories} kcal",
                  Icons.local_fire_department,
                  calProgress,
                  () => _goNutrition(context),
                  emojiKey: 'calories',
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: _buildWaterCard(user, metrics, waterProgress, context),
              ),
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Expanded(
                child: _buildGridCard(
                  AppLocalizations.of(context)!.streak,
                  "${user.streakDays} ${AppLocalizations.of(context)!.days}",
                  Icons.local_fire_department_outlined,
                  user.streakDays > 0 ? 1.0 : 0.0,
                  () => _goProfile(context),
                  emojiKey: 'streak',
                ),
              ),
              SizedBox(width: 15.w),
              Expanded(
                child: _buildGridCard(
                  AppLocalizations.of(context)!.protein,
                  "${user.dailyProteinConsumed} / ${metrics.proteinTarget}g",
                  Icons.fitness_center,
                  proteinProgress,
                  () => _goNutrition(context),
                  emojiKey: 'protein',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Water card with +/- buttons to log intake directly from home
  Widget _buildWaterCard(UserModel user, HealthMetricsModel metrics,
      double progress, BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final radius = BorderRadius.circular(20.r);
    return Container(
      height: 140.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colorsmanger.Blue, Colorsmanger.darkblue.withValues(alpha: 0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colorsmanger.Blue.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Positioned(
            right: -30.w, top: -30.h,
            child: Container(
              width: 100.w, height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(Icons.water_drop, color: Colors.white, size: 18.sp),
                    ),
                    SizedBox(
                      width: 22.w, height: 22.w,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 3,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '💧 ${user.dailyWaterConsumed.toStringAsFixed(1)} / ${metrics.waterTarget.toStringAsFixed(1)} L',
                      style: GoogleFonts.inter(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Text(
                          l.water,
                          style: GoogleFonts.inter(fontSize: 11.sp, color: Colors.white70),
                        ),
                        const Spacer(),
                        // Remove 0.25L
                        _waterBtn(Icons.remove, () async {
                          await Fairebaeservices.updateDailyTracking(addWater: -0.25);
                        }),
                        SizedBox(width: 4.w),
                        // Add 0.25L
                        _waterBtn(Icons.add, () async {
                          await Fairebaeservices.updateDailyTracking(addWater: 0.25);
                        }),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _waterBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24.w,
        height: 24.w,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.25),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white, size: 14.sp),
      ),
    );
  }

  Widget _buildGridCard(
    String title,
    String value,
    IconData icon,
    double progress,
    VoidCallback onTap, {
    String? emojiKey, // locale-independent key for emoji selection
  }) {
    String graphicEmoji = "✨";
    if (emojiKey == 'calories') graphicEmoji = "🔥";
    if (emojiKey == 'water') graphicEmoji = "💧";
    if (emojiKey == 'streak') graphicEmoji = "⚡";
    if (emojiKey == 'goal') graphicEmoji = "🎯";
    if (emojiKey == 'protein') graphicEmoji = "💪";

    final radius = BorderRadius.circular(20.r);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
      height: 140.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colorsmanger.Blue, Colorsmanger.darkblue.withValues(alpha: 0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colorsmanger.Blue.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          // Graphic Shape 1: Large overlapping background circle
          Positioned(
            right: -30.w,
            top: -30.h,
            child: Container(
              width: 100.w,
              height: 100.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
          ),
          // Graphic Shape 2: Small bottom-left abstract circle
          Positioned(
            left: -20.w,
            bottom: -20.h,
            child: Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.05),
              ),
            ),
          ),
          
          // Actual Content
          Padding(
            padding: EdgeInsets.all(15.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(icon, color: Colors.white, size: 20.sp),
                    ),
                    SizedBox(
                      width: 24.w,
                      height: 24.w,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 3,
                        backgroundColor: Colors.white.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          graphicEmoji,
                          style: TextStyle(fontSize: 18.sp),
                        ),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            value,
                            style: GoogleFonts.inter(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 12.sp,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
        ),
      ),
    );
  }

  Widget _buildMotivationBanner(BuildContext context) {
    final radius = BorderRadius.circular(25.r);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _showMotivationSheet(context),
        borderRadius: radius,
        child: Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colorsmanger.darkblue, Colorsmanger.Blue],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colorsmanger.darkblue.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: Column(
        children: [
          Icon(Icons.format_quote_rounded, color: Colors.white.withValues(alpha: 0.5), size: 40.sp),
          SizedBox(height: 10.h),
          Text(
            AppLocalizations.of(context)!.motivation_quote,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
        ),
      ),
    );
  }

  Widget _buildRecommendedExercises(BuildContext context) {
    final List<Map<String, String>> exercises = [
      {"name": "Squats", "target": "Legs", "image": "https://images.unsplash.com/photo-1566241440091-ec10ee8f6b14?auto=format&fit=crop&w=400&q=80"},
      {"name": "Push-ups", "target": "Chest", "image": "https://images.unsplash.com/photo-1598971639058-fab3c3109a00?auto=format&fit=crop&w=400&q=80"},
      {"name": "Plank", "target": "Core", "image": "https://images.unsplash.com/photo-1566241477600-ac026ad43874?auto=format&fit=crop&w=400&q=80"},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _goWorkout(context),
              borderRadius: BorderRadius.circular(12.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.quick_exercises,
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                        color: Colorsmanger.darkblue,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 14.sp, color: Colorsmanger.Blue),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 15.h),
        SizedBox(
          height: 140.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final ex = exercises[index];
              final name = ex["name"]!;
              final cardRadius = BorderRadius.circular(20.r);
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _openQuickExercise(context, name),
                  borderRadius: cardRadius,
                  child: Container(
                width: 120.w,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: cardRadius,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                      child: CachedNetworkImage(
                        imageUrl: ex["image"]!,
                        height: 80.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          height: 80.h,
                          color: Colors.grey.shade200,
                          child: const Center(
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          height: 80.h,
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.fitness_center, color: Colors.grey),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              ex["name"]!,
                              style: GoogleFonts.inter(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.bold,
                                color: Colorsmanger.darkblue,
                              ),
                            ),
                            Text(
                              ex["target"]!,
                              style: GoogleFonts.inter(
                                fontSize: 11.sp,
                                color: Colorsmanger.Grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}