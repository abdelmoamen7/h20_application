import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/Providers/CalculationProvider.dart';
import '../../../../core/colorsmanger/colorsmanger.dart';

import '../../../../core/widget/MacroCard.dart';
import '../../../../core/widget/ProgressCard.dart';
import '../../../../core/widget/WorkoutCard.dart';
import '../../../../models/UserModel.dart';
import '../../../../models/HealthMetricsModel.dart';

import '../../../../services/FirebaseServcies/firebaseService.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: Fairebaeservices.streamCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.data == null) {
          return const Center(child: Text("No User Data"));
        }

        UserModel user = snapshot.data!;
        HealthMetricsModel metrics = CalculationProvider.calculate(user);

        return Scaffold(
          backgroundColor: Colorsmanger.Whiteblue,
          body: ListView(
            padding: EdgeInsets.zero,
            children: [
              _buildModernHeader(user, context),
              SizedBox(height: 25.h),
              
              _buildDailyProgressGrid(user, metrics),
              SizedBox(height: 25.h),

              ProgressCard(metrics: metrics), // BMI / Health Summary
              SizedBox(height: 25.h),
              
              WorkoutCard(metrics: metrics), // Today's Workouts
              SizedBox(height: 25.h),
              
              MacroCard(metrics: metrics), // Nutrition Section
              SizedBox(height: 25.h),
              
              _buildRecommendedExercises(),
              SizedBox(height: 25.h),

              _buildMotivationBanner(),
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
          CircleAvatar(
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
          SizedBox(width: 15.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Good Morning, 👋",
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
                  "Ready to crush your goals today?",
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
            onTap: () {},
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

  Widget _buildDailyProgressGrid(UserModel user, HealthMetricsModel metrics) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Daily Progress",
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: Colorsmanger.darkblue,
            ),
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Expanded(child: _buildGridCard("Calories", "${metrics.calories} kcal", Icons.local_fire_department, 0.7)),
              SizedBox(width: 15.w),
              Expanded(child: _buildGridCard("Water", metrics.waterTargetText, Icons.water_drop, 0.4)),
            ],
          ),
          SizedBox(height: 15.h),
          Row(
            children: [
              Expanded(child: _buildGridCard("Streak", "${user.streakDays} Days", Icons.local_fire_department_outlined, user.streakDays > 0 ? 1.0 : 0.0)),
              SizedBox(width: 15.w),
              Expanded(child: _buildGridCard("Goal", user.goal.replaceAll('_', ' ').toUpperCase(), Icons.flag_outlined, metrics.goalProgress)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridCard(String title, String value, IconData icon, double progress) {
    // Select an emoji based on the title to serve as a nice graphic shape
    String graphicEmoji = "✨";
    if (title.contains("Calories")) graphicEmoji = "🔥";
    if (title.contains("Water")) graphicEmoji = "💧";
    if (title.contains("Streak")) graphicEmoji = "⚡";
    if (title.contains("Goal")) graphicEmoji = "🎯";

    return Container(
      height: 140.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colorsmanger.Blue, Colorsmanger.darkblue.withValues(alpha: 0.9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
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
    );
  }

  Widget _buildMotivationBanner() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      padding: EdgeInsets.all(25.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colorsmanger.darkblue, Colorsmanger.Blue],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(25.r),
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
            "Push Yourself, Because No One Else Will Do It For You.",
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
    );
  }

  Widget _buildRecommendedExercises() {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Quick Exercises",
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
        SizedBox(height: 15.h),
        SizedBox(
          height: 140.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            itemCount: exercises.length,
            itemBuilder: (context, index) {
              final ex = exercises[index];
              return Container(
                width: 120.w,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
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
                      child: Image.network(
                        ex["image"]!,
                        height: 80.h,
                        width: double.infinity,
                        fit: BoxFit.cover,
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
              );
            },
          ),
        ),
      ],
    );
  }
}