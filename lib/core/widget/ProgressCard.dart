import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../models/HealthMetricsModel.dart';
import '../colorsmanger/colorsmanger.dart';
import '../../../../l10n/app_localizations.dart';

class ProgressCard extends StatelessWidget {
  final HealthMetricsModel metrics;
  final VoidCallback? onTap;

  const ProgressCard({
    super.key,
    required this.metrics,
    this.onTap,
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
                AppLocalizations.of(context)!.health_summary,
                style: GoogleFonts.inter(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w700,
                  color: Colorsmanger.darkblue,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: Colorsmanger.Blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  metrics.bmiCategory,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: Colorsmanger.Blue,
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _metricItem(AppLocalizations.of(context)!.bmi, metrics.bmiText, Icons.monitor_weight_outlined),
              Container(width: 1, height: 40.h, color: Colors.grey.shade200),
              _metricItem(AppLocalizations.of(context)!.target, "${metrics.goalProgress * 100}%", Icons.flag_outlined),
              Container(width: 1, height: 40.h, color: Colors.grey.shade200),
              _metricItem(AppLocalizations.of(context)!.water, metrics.waterTargetText, Icons.water_drop_outlined),
            ],
          ),
          SizedBox(height: 25.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.goal_progress,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colorsmanger.Grey,
                ),
              ),
              Text(
                "${(metrics.goalProgress * 100).toInt()}%",
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  color: Colorsmanger.Blue,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: metrics.goalProgress,
              minHeight: 8.h,
              backgroundColor: Colorsmanger.Whiteblue,
              valueColor: AlwaysStoppedAnimation<Color>(Colorsmanger.Blue),
            ),
          ),
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

  Widget _metricItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colorsmanger.Blue, size: 28.sp),
        SizedBox(height: 8.h),
        Text(
          value,
          style: GoogleFonts.inter(
            fontWeight: FontWeight.w700,
            color: Colorsmanger.darkblue,
            fontSize: 16.sp,
          ),
        ),
        SizedBox(height: 4.h),
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