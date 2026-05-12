import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/HealthMetricsModel.dart';
import '../../../../models/UserModel.dart';
import '../colorsmanger/colorsmanger.dart';
import '../../../../l10n/app_localizations.dart';

class ProgressCard extends StatelessWidget {
  final HealthMetricsModel metrics;
  final UserModel user;
  final VoidCallback? onTap;

  const ProgressCard({
    super.key,
    required this.metrics,
    required this.user,
    this.onTap,
  });

  // BMI color: blue=underweight, green=normal, orange=overweight, red=obese
  Color _bmiColor(double bmi) {
    if (bmi < 18.5) return Colors.blue.shade400;
    if (bmi < 25.0) return Colors.green.shade500;
    if (bmi < 30.0) return Colors.orange.shade500;
    return Colors.red.shade500;
  }

  // BMI position on the bar (0.0 – 1.0), clamped between 10 and 40
  double _bmiBarPosition(double bmi) {
    return ((bmi - 10) / 30).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final bmi = metrics.bmi;
    final bmiColor = _bmiColor(bmi);

    // Daily progress ratios
    final calRatio = metrics.calories > 0
        ? (user.dailyCaloriesConsumed / metrics.calories).clamp(0.0, 1.0)
        : 0.0;
    final proteinRatio = metrics.proteinTarget > 0
        ? (user.dailyProteinConsumed / metrics.proteinTarget).clamp(0.0, 1.0)
        : 0.0;
    final waterRatio = metrics.waterTarget > 0
        ? (user.dailyWaterConsumed / metrics.waterTarget).clamp(0.0, 1.0)
        : 0.0;

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
                l.health_summary,
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colorsmanger.darkblue,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: bmiColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  metrics.bmiCategory,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: bmiColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // ── BMI Section ──────────────────────────────────────────────────
          Row(
            children: [
              Icon(Icons.monitor_weight_outlined,
                  color: bmiColor, size: 20.sp),
              SizedBox(width: 8.w),
              Text(
                l.bmi,
                style: GoogleFonts.inter(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: Colorsmanger.Grey,
                ),
              ),
              const Spacer(),
              Text(
                metrics.bmiText,
                style: GoogleFonts.inter(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w800,
                  color: bmiColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // BMI color bar with marker
          Stack(
            clipBehavior: Clip.none,
            children: [
              // Gradient bar: blue → green → orange → red
              ClipRRect(
                borderRadius: BorderRadius.circular(6.r),
                child: Container(
                  height: 10.h,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF42A5F5), // underweight
                        Color(0xFF66BB6A), // normal
                        Color(0xFFFFA726), // overweight
                        Color(0xFFEF5350), // obese
                      ],
                    ),
                  ),
                ),
              ),
              // Marker dot
              Positioned(
                left: (_bmiBarPosition(bmi) *
                        (MediaQuery.of(context).size.width - 80.w))
                    .clamp(0.0, MediaQuery.of(context).size.width - 80.w),
                top: -3.h,
                child: Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: bmiColor, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: bmiColor.withValues(alpha: 0.4),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          // BMI range labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('< 18.5',
                  style: GoogleFonts.inter(
                      fontSize: 9.sp, color: Colors.blue.shade400)),
              Text('18.5–25',
                  style: GoogleFonts.inter(
                      fontSize: 9.sp, color: Colors.green.shade500)),
              Text('25–30',
                  style: GoogleFonts.inter(
                      fontSize: 9.sp, color: Colors.orange.shade500)),
              Text('> 30',
                  style: GoogleFonts.inter(
                      fontSize: 9.sp, color: Colors.red.shade500)),
            ],
          ),

          SizedBox(height: 20.h),
          Divider(color: Colors.grey.shade100, height: 1),
          SizedBox(height: 16.h),

          // ── Today's Progress ─────────────────────────────────────────────
          Text(
            "Today's Progress",
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
              color: Colorsmanger.darkblue,
            ),
          ),
          SizedBox(height: 14.h),

          _progressRow(
            context,
            icon: Icons.local_fire_department_rounded,
            color: Colors.orange.shade500,
            label: l.calories,
            value:
                '${user.dailyCaloriesConsumed} / ${metrics.calories} kcal',
            ratio: calRatio,
          ),
          SizedBox(height: 10.h),
          _progressRow(
            context,
            icon: Icons.fitness_center_rounded,
            color: Colorsmanger.Blue,
            label: l.protein,
            value: '${user.dailyProteinConsumed} / ${metrics.proteinTarget} g',
            ratio: proteinRatio,
          ),
          SizedBox(height: 10.h),
          _progressRow(
            context,
            icon: Icons.water_drop_rounded,
            color: Colors.blue.shade400,
            label: l.water,
            value:
                '${user.dailyWaterConsumed.toStringAsFixed(1)} / ${metrics.waterTarget.toStringAsFixed(1)} L',
            ratio: waterRatio,
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

  Widget _progressRow(
    BuildContext context, {
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    required double ratio,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 16.sp),
            SizedBox(width: 6.w),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Colorsmanger.Grey,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                color: Colorsmanger.darkblue,
              ),
            ),
          ],
        ),
        SizedBox(height: 5.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(6.r),
          child: LinearProgressIndicator(
            value: ratio,
            minHeight: 7.h,
            backgroundColor: color.withValues(alpha: 0.12),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
