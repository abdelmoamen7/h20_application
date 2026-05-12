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
    final l = AppLocalizations.of(context)!;
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
          l.register,
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
                  l.create_account,
                  style: GoogleFonts.inter(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colorsmanger.darkblue,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.h),
                Text(
                  l.join_us,
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
                      return l.val_enter_name;
                    }
                    return null;
                  },
                  isObscure: false,
                  labelText: l.name,
                  prefixIcon: Icons.person_outline,
                ),
                SizedBox(height: 16.h),
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
                SizedBox(height: 16.h),
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
                SizedBox(height: 16.h),
                CustomTextForm(
                  controller: _repasswordcontroller,
                  validator: (input) {
                    if (input == null || input.trim().isEmpty) {
                      return l.val_reenter_password;
                    }
                    if (input != _passwordcontroller.text) {
                      return l.val_passwords_mismatch;
                    }
                    return null;
                  },
                  isObscure: securePassword,
                  labelText: l.re_password,
                  prefixIcon: Icons.lock_outline,
                ),
                SizedBox(height: 30.h),
                Coustom_Elvated_Button(
                  text: l.create_account,
                  onPress: _registered,
                ),
                SizedBox(height: 24.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l.already_have_account,
                      style: GoogleFonts.inter(
                        fontSize: 14.sp,
                        color: Colorsmanger.Grey,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    CustomTextButton(
                      texts: l.login,
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
    final l = AppLocalizations.of(context)!;
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
      Navigator.pushReplacementNamed(context, Routesmanger.Onbording);
    } on FirebaseAuthException catch (e) {
      uitils.hideDialog(context);
      uitils.ShowToastMassage(e.message ?? e.code, Colors.red);
    } catch (e) {
      uitils.hideDialog(context);
      uitils.ShowToastMassage(l.failed_register, Colors.red);
    }
  }
}
