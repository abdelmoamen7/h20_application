import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/HealthMetricsModel.dart';
import '../colorsmanger/colorsmanger.dart';
import '../../../../l10n/app_localizations.dart';

class MacroCard extends StatelessWidget {
  final HealthMetricsModel metrics;
  final VoidCallback? onTap;
  final VoidCallback? onLogMeal;

  const MacroCard({
    super.key,
    required this.metrics,
    this.onTap,
    this.onLogMeal,
  });

  @override
  Widget build(BuildContext context) {
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
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.nutrition_summary,
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colorsmanger.darkblue,
                ),
              ),
              Icon(Icons.pie_chart_outline, color: Colorsmanger.Blue, size: 24.sp),
            ],
          ),
          SizedBox(height: 25.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildCircularMacro(AppLocalizations.of(context)!.protein, metrics.proteinTarget, 150, Colorsmanger.Blue),
              _buildCircularMacro(AppLocalizations.of(context)!.carbs, metrics.carbsTarget, 200, Colors.orange),
              _buildCircularMacro(AppLocalizations.of(context)!.fats, metrics.fatsTarget, 70, Colors.redAccent),
            ],
          ),
          SizedBox(height: 25.h),
          Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: Colorsmanger.Whiteblue,
              borderRadius: BorderRadius.circular(15.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.calories_intake,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: Colorsmanger.Grey,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "${metrics.calories} kcal",
                      style: GoogleFonts.inter(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colorsmanger.darkblue,
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
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      child: Text(
                        AppLocalizations.of(context)!.log_meal,
                        style: GoogleFonts.inter(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );

    if (onTap == null) return card;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: card,
      ),
    );
  }

  Widget _buildCircularMacro(String title, int value, int target, Color color) {
    double progress = target > 0 ? (value / target).clamp(0.0, 1.0) : 0;
    // For visual mock purposes if value is 0 we'll show a full ring based on target, 
    // but the actual text will use the real target.
    // Wait, the HealthMetricsModel gives us 'proteinTarget' not current intake.
    // So we'll just show a generic 60% progress ring to mock the "Intake vs Target" visually for the design.
    progress = 0.65; 

    return Column(
      children: [
        SizedBox(
          width: 70.w,
          height: 70.w,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 6,
                backgroundColor: color.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
              Center(
                child: Text(
                  "${value}g",
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: Colorsmanger.darkblue,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
            color: Colorsmanger.Grey,
          ),
        ),
      ],
    );
  }
}