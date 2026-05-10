import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/colorsmanger/colorsmanger.dart';
import '../../../../core/routesmanger/routesManger.dart';
import '../../../../models/UserModel.dart';
import '../../../../services/FirebaseServcies/firebaseService.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserModel?>(
      stream: Fairebaeservices.streamCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("No User Data Found"));
        }

        UserModel user = snapshot.data!;

        return Scaffold(
          backgroundColor: Colorsmanger.Whiteblue,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildHeader(user, context),
                SizedBox(height: 20.h),
                _buildSectionTitle("Personal Info"),
                _buildPersonalInfoCard(user),
                SizedBox(height: 20.h),
                _buildSectionTitle("Fitness & Nutrition Goals"),
                _buildGoalsCard(user),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(UserModel user, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 60.h, bottom: 30.h, left: 20.w, right: 20.w),
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
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              icon: Icon(Icons.logout, color: Colors.white, size: 28.sp),
              tooltip: 'Sign Out',
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    Routesmanger.Logins,
                    (route) => false,
                  );
                }
              },
            ),
          ),
          CircleAvatar(
            radius: 50.r,
            backgroundColor: Colors.white,
            backgroundImage: user.profileImage != null && user.profileImage!.isNotEmpty
                ? NetworkImage(user.profileImage!)
                : null,
            child: user.profileImage == null || user.profileImage!.isEmpty
                ? Text(
                    user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                    style: GoogleFonts.inter(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                      color: Colorsmanger.Blue,
                    ),
                  )
                : null,
          ),
          SizedBox(height: 15.h),
          Text(
            user.name,
            style: GoogleFonts.inter(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 5.h),
          Text(
            user.email,
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 15.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.local_fire_department, color: Colors.orangeAccent, size: 20.sp),
                SizedBox(width: 5.w),
                Text(
                  "${user.streakDays} Day Streak",
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: Colorsmanger.darkblue,
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard(UserModel user) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.all(20.w),
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
        children: [
          _buildInfoRow(Icons.cake, "Age", "${user.age} Years"),
          Divider(color: Colors.grey.shade200, height: 20.h),
          _buildInfoRow(Icons.height, "Height", "${user.height} cm"),
          Divider(color: Colors.grey.shade200, height: 20.h),
          _buildInfoRow(Icons.monitor_weight, "Weight", "${user.weight} kg"),
          Divider(color: Colors.grey.shade200, height: 20.h),
          _buildInfoRow(
            user.gender.toLowerCase() == "male" ? Icons.male : Icons.female,
            "Gender",
            user.gender,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalsCard(UserModel user) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      padding: EdgeInsets.all(20.w),
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
        children: [
          _buildInfoRow(Icons.flag, "Goal", user.goal.replaceAll("_", " ").toUpperCase()),
          Divider(color: Colors.grey.shade200, height: 20.h),
          _buildInfoRow(Icons.fitness_center, "Activity Level", user.activityLevel.toUpperCase()),
          Divider(color: Colors.grey.shade200, height: 20.h),
          _buildInfoRow(Icons.monitor_weight_outlined, "Target Weight", "${user.targetWeight} kg"),
          Divider(color: Colors.grey.shade200, height: 20.h),
          _buildInfoRow(Icons.water_drop, "Water Intake", "${user.waterIntake.toStringAsFixed(1)} L"),
          Divider(color: Colors.grey.shade200, height: 20.h),
          _buildInfoRow(Icons.local_dining, "Daily Calories", "${user.caloriesTarget} kcal"),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colorsmanger.Whiteblue,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: Colorsmanger.Blue, size: 24.sp),
        ),
        SizedBox(width: 15.w),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: Colorsmanger.Grey,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: Colorsmanger.darkblue,
          ),
        ),
      ],
    );
  }

}
