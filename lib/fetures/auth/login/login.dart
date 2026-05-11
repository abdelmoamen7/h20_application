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
                  "Welcome Back",
                  style: GoogleFonts.inter(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colorsmanger.darkblue,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  "Sign in to continue your fitness journey",
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
                      return "Please enter your email";
                    }
                    if (!Validator.isValidEmail(input)) {
                      return "The email format is incorrect";
                    }
                    return null;
                  },
                  isObscure: false,
                  keyboardType: TextInputType.emailAddress,
                  labelText: AppLocalizations.of(context)!.email,
                  prefixIcon: Icons.email_outlined,
                ),
                SizedBox(height: 20.h),
                CustomTextForm(
                  controller: _passwordcontroller,
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return "Please enter your password";
                    }
                    if (input.length < 6) {
                      return "Password must be at least 6 characters";
                    }
                    return null;
                  },
                  isObscure: securePassword,
                  labelText: AppLocalizations.of(context)!.password,
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
                    texts: AppLocalizations.of(context)!.forget_password,
                    onTap: () {
                      Navigator.pushReplacementNamed(context, Routesmanger.forgetPassword);
                    },
                  ),
                ),
                SizedBox(height: 30.h),
                Coustom_Elvated_Button(
                  text: AppLocalizations.of(context)!.login,
                  onPress: _login,
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.dont_have_account,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Colorsmanger.Grey,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    CustomTextButton(
                      texts: AppLocalizations.of(context)!.create_account,
                      onTap: () {
                        Navigator.pushNamed(context, Routesmanger.Registes);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 30.h),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        "OR",
                        style: GoogleFonts.inter(
                          color: Colorsmanger.Grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey.shade300,
                        thickness: 1,
                      ),
                    ),
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
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(Imagemanger.Googlephoto, height: 24.h),
                      SizedBox(width: 12.w),
                      Text(
                        "Continue with Google",
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
        
        // If the user has valid profile data, they have completed onboarding
        if (user.age > 0 || user.weight > 0) {
          await prefs.setBool('onboardingCompleted', true);
          if (!mounted) return;
          Navigator.pushNamedAndRemoveUntil(context, Routesmanger.mainlayout, (route) => false);
        } else {
          // Exists in DB but no profile data
          await prefs.setBool('onboardingCompleted', false);
          if (!mounted) return;
          Navigator.pushNamedAndRemoveUntil(context, Routesmanger.Onbording, (route) => false);
        }
      } else {
        // Authenticated but no Firestore document found, need onboarding
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
      uitils.ShowToastMassage("Failed to Login", Colors.red);
    }
  }
}
