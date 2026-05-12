import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/assetsmanger/assetsmanger.dart';
import '../../../core/colorsmanger/colorsmanger.dart';
import '../../../core/resources/isvalidat.dart';
import '../../../core/routesmanger/routesManger.dart';
import '../../../core/utilis/Uiutills.dart';
import '../../../core/widget/Custom_Elvated button.dart';
import '../../../core/widget/Custom_Text_Button.dart';
import '../../../core/widget/Custom_text_form.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/UserModel.dart';
import '../../../services/FirebaseServcies/firebaseService.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool securePassword = true;
  late TextEditingController _emailcontroller;
  late TextEditingController _passwordcontroller;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailcontroller = TextEditingController();
    _passwordcontroller = TextEditingController();
  }

  @override
  void dispose() {
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 20.h),
                Center(
                  child: Image.asset(
                    Imagemanger.logoimage,
                    width: 120.w,
                    height: 150.h,
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  l.welcome_back,
                  style: GoogleFonts.inter(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colorsmanger.darkblue,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  l.welcome_message,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Colorsmanger.Grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40.h),
                CustomTextForm(
                  controller: _emailcontroller,
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return l.val_enter_email;
                    }
                    if (!Validator.isValidEmail(input)) {
                      return l.val_invalid_email;
                    }
                    return null;
                  },
                  isObscure: false,
                  keyboardType: TextInputType.emailAddress,
                  labelText: l.email,
                  prefixIcon: Icons.email_outlined,
                ),
                SizedBox(height: 20.h),
                CustomTextForm(
                  controller: _passwordcontroller,
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return l.val_enter_password;
                    }
                    if (input.length < 6) {
                      return l.val_password_short;
                    }
                    return null;
                  },
                  isObscure: securePassword,
                  labelText: l.password,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        securePassword = !securePassword;
                      });
                    },
                    icon: Icon(
                      securePassword ? Icons.visibility_off : Icons.visibility,
                      color: Colorsmanger.Grey,
                    ),
                  ),
                  keyboardType: TextInputType.visiblePassword,
                ),
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomTextButton(
                    texts: l.forget_password,
                    onTap: () {
                      Navigator.pushReplacementNamed(context, Routesmanger.forgetPassword);
                    },
                  ),
                ),
                SizedBox(height: 30.h),
                Coustom_Elvated_Button(
                  text: l.login,
                  onPress: _login,
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l.dont_have_account,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Colorsmanger.Grey,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    CustomTextButton(
                      texts: l.create_account,
                      onTap: () {
                        Navigator.pushNamed(context, Routesmanger.Registes);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        l.or,
                        style: GoogleFonts.inter(
                          color: Colorsmanger.Grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300, thickness: 1)),
                  ],
                ),
                SizedBox(height: 24.h),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    side: BorderSide(color: Colors.grey.shade300),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  ),
                  onPressed: _signInWithGoogle,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Imagemanger.Googlephoto, height: 24.h),
                      SizedBox(width: 12.w),
                      Text(
                        l.login_with_google,
                        style: GoogleFonts.inter(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colorsmanger.darkblue,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _login() async {
    final l = AppLocalizations.of(context)!;
    if (_formkey.currentState?.validate() == false) return;
    try {
      uitils.ShowLoading(context);
      UserCredential userCredential = await Fairebaeservices.login(
        _emailcontroller.text.trim(),
        _passwordcontroller.text,
      );
      UserModel? user = await Fairebaeservices.getUserId(userCredential.user!.uid);
      if (!mounted) return;
      uitils.hideDialog(context);
      if (user != null) {
        UserModel.currentUser = user;
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (user.age > 0 || user.weight > 0) {
          await prefs.setBool('onboardingCompleted', true);
          if (!mounted) return;
          Navigator.pushNamedAndRemoveUntil(context, Routesmanger.mainlayout, (route) => false);
        } else {
          await prefs.setBool('onboardingCompleted', false);
          if (!mounted) return;
          Navigator.pushNamedAndRemoveUntil(context, Routesmanger.Onbording, (route) => false);
        }
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('onboardingCompleted', false);
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, Routesmanger.Onbording, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      uitils.hideDialog(context);
      uitils.ShowToastMassage(e.message ?? e.code, Colors.red);
    } catch (e) {
      uitils.hideDialog(context);
      uitils.ShowToastMassage(l.failed_login, Colors.red);
    }
  }

  void _signInWithGoogle() async {
    final l = AppLocalizations.of(context)!;
    try {
      uitils.ShowLoading(context);
      final userCredential = await Fairebaeservices.signInWithGoogle();
      if (userCredential == null) {
        if (!mounted) return;
        uitils.hideDialog(context);
        return;
      }
      final user = userCredential.user!;
      UserModel? existingUser = await Fairebaeservices.getUserId(user.uid);
      if (existingUser == null) {
        await Fairebaeservices.addUasertoFireStore(UserModel(
          name: user.displayName ?? "",
          id: user.uid,
          email: user.email ?? "",
          height: 0, weight: 0, caloriesTarget: 0, waterIntake: 0,
          streakDays: 0, age: 0, gender: "", activityLevel: "",
          goal: "", targetWeight: 0,
        ));
      }
      if (!mounted) return;
      uitils.hideDialog(context);
      final prefs = await SharedPreferences.getInstance();
      if (existingUser != null && (existingUser.age > 0 || existingUser.weight > 0)) {
        UserModel.currentUser = existingUser;
        await prefs.setBool('onboardingCompleted', true);
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, Routesmanger.mainlayout, (route) => false);
      } else {
        await prefs.setBool('onboardingCompleted', false);
        if (!mounted) return;
        Navigator.pushNamedAndRemoveUntil(context, Routesmanger.Onbording, (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      uitils.hideDialog(context);
      uitils.ShowToastMassage(e.message ?? e.code, Colors.red);
    } catch (e) {
      uitils.hideDialog(context);
      uitils.ShowToastMassage(l.failed_google, Colors.red);
    }
  }
}
