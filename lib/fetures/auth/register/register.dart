import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

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

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool securePassword = true;
  late TextEditingController _namecontroller;
  late TextEditingController _emailcontroller;
  late TextEditingController _passwordcontroller;
  late TextEditingController _repasswordcontroller;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _namecontroller = TextEditingController();
    _emailcontroller = TextEditingController();
    _passwordcontroller = TextEditingController();
    _repasswordcontroller = TextEditingController();
  }

  @override
  void dispose() {
    _namecontroller.dispose();
    _emailcontroller.dispose();
    _passwordcontroller.dispose();
    _repasswordcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colorsmanger.darkblue),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.register,
          style: GoogleFonts.inter(
            color: Colorsmanger.darkblue,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
          child: Form(
            key: formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Image.asset(
                    Imagemanger.logoimage,
                    width: 100.w,
                    height: 120.h,
                  ),
                ),
                SizedBox(height: 20.h),
                Text(
                  "Create Account",
                  style: GoogleFonts.inter(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colorsmanger.darkblue,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  "Join us and transform your body",
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    color: Colorsmanger.Grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30.h),
                CustomTextForm(
                  controller: _namecontroller,
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return "Please enter your name";
                    }
                    return null;
                  },
                  isObscure: false,
                  labelText: AppLocalizations.of(context)!.name,
                  prefixIcon: Icons.person_outline,
                ),
                SizedBox(height: 16.h),
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
                SizedBox(height: 16.h),
                CustomTextForm(
                  controller: _passwordcontroller,
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return "Please enter a password";
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
                SizedBox(height: 16.h),
                CustomTextForm(
                  controller: _repasswordcontroller,
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return "Please re-enter your password";
                    }
                    if (input != _passwordcontroller.text) {
                      return "Passwords do not match";
                    }
                    return null;
                  },
                  isObscure: securePassword,
                  labelText: AppLocalizations.of(context)!.re_password,
                  prefixIcon: Icons.lock_outline,
                ),
                SizedBox(height: 30.h),
                Coustom_Elvated_Button(
                  text: AppLocalizations.of(context)!.create_account,
                  onPress: _registered,
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account?",
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Colorsmanger.Grey,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    CustomTextButton(
                      texts: AppLocalizations.of(context)!.login,
                      onTap: () {
                        Navigator.pushReplacementNamed(context, Routesmanger.Logins);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _registered() async {
    if (formkey.currentState?.validate() == false) return;
    try {
      uitils.ShowLoading(context);
      
      UserCredential userCredential = await Fairebaeservices.registers(
        _emailcontroller.text.trim(), 
        _passwordcontroller.text,
      );
      
      await Fairebaeservices.addUasertoFireStore(UserModel(
        name: _namecontroller.text.trim(), 
        id: userCredential.user!.uid, 
        email: _emailcontroller.text.trim(),
        height: 0, weight: 0, caloriesTarget: 0, waterIntake: 0,
        streakDays: 0, age: 0, gender: "", activityLevel: "",
        goal: "", targetWeight: 0,
      ));
      
      if (!mounted) return;
      uitils.hideDialog(context);
      
      // Navigate straight to Onboarding after successful registration
      Navigator.pushReplacementNamed(context, Routesmanger.Onbording);
      
    } on FirebaseAuthException catch (e) {
      uitils.hideDialog(context);
      uitils.ShowToastMassage(e.message ?? e.code, Colors.red);
    } catch (e) {
      uitils.hideDialog(context);
      uitils.ShowToastMassage("Failed to register", Colors.red);
    }
  }
}
