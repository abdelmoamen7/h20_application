import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/HealthMetricsModel.dart';
import '../../../../models/UserModel.dart';
import '../colorsmanger/colorsmanger.dart';
import '../../../../l10n/app_localizations.dart';

class MacroCard extends StatelessWidget {
  final HealthMetricsModel metrics;
  final UserModel user;
  final VoidCallback? onTap;
  final VoidCallback? onLogMeal;

  const MacroCard({
    super.key,
    required this.metrics,
    required this.user,
    this.onTap,
    this.onLogMeal,
  });

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;

    // Real consumed values from daily tracking
    final calConsumed = user.dailyCaloriesConsumed;
    final calTarget = metrics.calories > 0 ? metrics.calories : 1;
    final calRatio = (calConsumed / calTarget).clamp(0.0, 1.0);

    final proteinConsumed = user.dailyProteinConsumed;
    final proteinTarget = metrics.proteinTarget > 0 ? metrics.proteinTarget : 1;
    final proteinRatio = (proteinConsumed / proteinTarget).clamp(0.0, 1.0);

    // Carbs and fats are estimated from calorie ratio (no separate tracking yet)
    final carbsTarget = metrics.carbsTarget > 0 ? metrics.carbsTarget : 1;
    final fatsTarget = metrics.fatsTarget > 0 ? metrics.fatsTarget : 1;
    final carbsConsumed = (carbsTarget * calRatio).round();
    final fatsConsumed = (fatsTarget * calRatio).round();

    final radius = BorderRadius.circular(20.r);
    final card = Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l.nutrition_summary,
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colorsmanger.darkblue,
                ),
              ),
              Icon(Icons.pie_chart_outline,
                  color: Colorsmanger.Blue, size: 24.sp),
            ],
          ),
          SizedBox(height: 20.h),

          // ── Macro rings ──────────────────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _macroRing(
                context,
                label: l.protein,
                consumed: proteinConsumed,
                target: metrics.proteinTarget,
                unit: 'g',
                color: Colorsmanger.Blue,
                ratio: proteinRatio,
              ),
              _macroRing(
                context,
                label: l.carbs,
                consumed: carbsConsumed,
                target: metrics.carbsTarget,
                unit: 'g',
                color: Colors.orange.shade500,
                ratio: (carbsConsumed / carbsTarget).clamp(0.0, 1.0),
              ),
              _macroRing(
                context,
                label: l.fats,
                consumed: fatsConsumed,
                target: metrics.fatsTarget,
                unit: 'g',
                color: Colors.redAccent,
                ratio: (fatsConsumed / fatsTarget).clamp(0.0, 1.0),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // ── Calories bar ─────────────────────────────────────────────────
          Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: Colorsmanger.Whiteblue,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l.calories_intake,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colorsmanger.Grey,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '$calConsumed',
                                style: GoogleFonts.inter(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w800,
                                  color: Colorsmanger.darkblue,
                                ),
                              ),
                              TextSpan(
                                text: ' / $calTarget kcal',
                                style: GoogleFonts.inter(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colorsmanger.Grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Material(
                      color: Colorsmanger.Blue,
                      borderRadius: BorderRadius.circular(20.r),
                      child: InkWell(
                        onTap: onLogMeal,
                        borderRadius: BorderRadius.circular(20.r),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add_rounded,
                                  color: Colors.white, size: 16.sp),
                              SizedBox(width: 4.w),
                              Text(
                                l.log_meal,
                                style: GoogleFonts.inter(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                // Calorie progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: LinearProgressIndicator(
                    value: calRatio,
                    minHeight: 8.h,
                    backgroundColor:
                        Colorsmanger.Blue.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      calRatio >= 1.0
                          ? Colors.green.shade500
                          : Colorsmanger.Blue,
                    ),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  calRatio >= 1.0
                      ? '✅ ${l.calories} ${l.target}'
                      : '${((1 - calRatio) * calTarget).round()} kcal ${_remaining(context)}',
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    color: calRatio >= 1.0
                        ? Colors.green.shade600
                        : Colorsmanger.Grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return card;
    return Material(
      color: Colors.transparent,
      child: InkWell(onTap: onTap, borderRadius: radius, child: card),
    );
  }

  String _remaining(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return l.localeName == 'ar' ? 'متبقية' : 'remaining';
  }

  Widget _macroRing(
    BuildContext context, {
    required String label,
    required int consumed,
    required int target,
    required String unit,
    required Color color,
    required double ratio,
  }) {
    return Column(
      children: [
        SizedBox(
          width: 72.w,
          height: 72.w,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: ratio,
                strokeWidth: 7,
                backgroundColor: color.withValues(alpha: 0.12),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$consumed',
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w800,
                        fontSize: 14.sp,
                        color: Colorsmanger.darkblue,
                      ),
                    ),
                    Text(
                      unit,
                      style: GoogleFonts.inter(
                        fontSize: 9.sp,
                        color: Colorsmanger.Grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colorsmanger.Grey,
          ),
        ),
        Text(
          '/ $target$unit',
          style: GoogleFonts.inter(
            fontSize: 10.sp,
            color: Colorsmanger.Grey.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
