import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:h20_application/core/assetsmanger/assetsmanger.dart';

import '../../../core/routesmanger/routesManger.dart';
import '../../../core/utilis/Uiutills.dart';
import '../../../core/widget/Custom_Elvated button.dart';
import '../../../core/widget/Custom_text_form.dart';
import '../../../models/UserModel.dart';
import '../../../services/FirebaseServcies/firebaseService.dart';
import 'CustomDropdown.dart';

class OnBoarding extends StatefulWidget {

  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() =>
      _OnBoardingState();
}

class _OnBoardingState
    extends State<OnBoarding> {

  final GlobalKey<FormState>
  formkey =
  GlobalKey<FormState>();

  late TextEditingController
  _nameController;

  late TextEditingController
  _ageController;

  late TextEditingController
  _weightController;

  late TextEditingController
  _targetWeightController;

  late TextEditingController
  _heightController;

  late TextEditingController
  _caloriesController;

  String? _selectedGender;

  String? _selectedGoal;

  String? _selectedActivityLevel;

  final List<String> _genders = [

    "Male",

    "Female",
  ];

  final List<String> _goals = [

    "Lose Weight",

    "Gain Muscle",

    "Stay Fit",
  ];

  final List<String>
  _activityLevels = [

    "Beginner",

    "Moderate",

    "Advanced",
  ];

  @override
  void initState() {

    super.initState();

    _nameController =
        TextEditingController();

    _ageController =
        TextEditingController();

    _weightController =
        TextEditingController();

    _targetWeightController =
        TextEditingController();

    _heightController =
        TextEditingController();

    _caloriesController =
        TextEditingController();
  }

  @override
  void dispose() {

    _nameController.dispose();

    _ageController.dispose();

    _weightController.dispose();

    _targetWeightController.dispose();

    _heightController.dispose();

    _caloriesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: SafeArea(

        child: Padding(

          padding:
          const EdgeInsets.symmetric(

            horizontal: 22,

            vertical: 18,
          ),

          child: SingleChildScrollView(

            child: Form(

              key: formkey,

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.stretch,

                children: [

                  Center(

                    child: Container(
                  child:  Image(image: AssetImage(Imagemanger.onbordingimage,),width: 300,height: 200,),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              )


                    ),


                   SizedBox(height: 20),

                  /// HEADING


                  Text(

                    "Personal Information",

                    textAlign:
                    TextAlign.center,

                    style:
                    Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(

                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(

                    "Let's personalize your fitness journey.",

                    textAlign:
                    TextAlign.center,

                    style:
                    Theme.of(context)
                        .textTheme
                        .bodyMedium,
                  ),

                  const SizedBox(height: 30),

                  /// NAME

                  CustomTextForm(

                    controller:
                    _nameController,

                    labelText: "Name",

                    prefixIcon:
                    Icons.person,

                    validator: (input) {

                      if (input == null ||
                          input
                              .trim()
                              .isEmpty) {

                        return
                          "Enter your name";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  /// AGE

                  CustomTextForm(

                    controller:
                    _ageController,

                    keyboardType:
                    TextInputType.number,

                    labelText: "Age",

                    prefixIcon:
                    Icons.cake,

                    validator: (input) {

                      final age =
                      int.tryParse(
                        input?.trim() ??
                            "",
                      );

                      if (age == null) {

                        return
                          "Enter valid age";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  /// WEIGHT

                  CustomTextForm(

                    controller:
                    _weightController,

                    keyboardType:
                    const TextInputType
                        .numberWithOptions(
                      decimal: true,
                    ),

                    labelText:
                    "Weight (kg)",

                    prefixIcon:
                    Icons.monitor_weight,

                    validator: (input) {

                      final value =
                      double.tryParse(
                        input?.trim() ??
                            "",
                      );

                      if (value == null) {

                        return
                          "Enter weight";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  /// TARGET WEIGHT

                  CustomTextForm(

                    controller:
                    _targetWeightController,

                    keyboardType:
                    const TextInputType
                        .numberWithOptions(
                      decimal: true,
                    ),

                    labelText:
                    "Target Weight (kg)",

                    prefixIcon:
                    Icons.flag,

                    validator: (input) {

                      final value =
                      double.tryParse(
                        input?.trim() ??
                            "",
                      );

                      if (value == null) {

                        return
                          "Enter target weight";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  /// HEIGHT

                  CustomTextForm(

                    controller:
                    _heightController,

                    keyboardType:
                    const TextInputType
                        .numberWithOptions(
                      decimal: true,
                    ),

                    labelText:
                    "Height (cm)",

                    prefixIcon:
                    Icons.height,

                    validator: (input) {

                      final value =
                      double.tryParse(
                        input?.trim() ??
                            "",
                      );

                      if (value == null) {

                        return
                          "Enter height";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  /// CALORIES TARGET

                  CustomTextForm(

                    controller:
                    _caloriesController,

                    keyboardType:
                    TextInputType.number,

                    labelText:
                    "Calories Target",

                    prefixIcon:
                    Icons.local_fire_department,

                    validator: (input) {

                      final value =
                      int.tryParse(
                        input?.trim() ??
                            "",
                      );

                      if (value == null) {

                        return
                          "Enter calories";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  /// GENDER

                  CustomDropdown(

                    label: "Gender",

                    selectedItem:
                    _selectedGender,

                    items: _genders,

                    prefixIcon:
                    Icons.wc,

                    onChanged: (value) {

                      setState(() {

                        _selectedGender =
                            value;
                      });
                    },

                    validator: (value) {

                      if (value == null) {

                        return
                          "Choose gender";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  /// GOAL

                  CustomDropdown(

                    label: "Goal",

                    selectedItem:
                    _selectedGoal,

                    items: _goals,

                    prefixIcon:
                    Icons.flag,

                    onChanged: (value) {

                      setState(() {

                        _selectedGoal =
                            value;
                      });
                    },

                    validator: (value) {

                      if (value == null) {

                        return
                          "Choose goal";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  /// ACTIVITY LEVEL

                  CustomDropdown(

                    label:
                    "Activity Level",

                    selectedItem:
                    _selectedActivityLevel,

                    items:
                    _activityLevels,

                    prefixIcon:
                    Icons.fitness_center,

                    onChanged: (value) {

                      setState(() {

                        _selectedActivityLevel =
                            value;
                      });
                    },

                    validator: (value) {

                      if (value == null) {

                        return
                          "Choose activity level";
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 35),

                  /// BUTTON

                  Coustom_Elvated_Button(

                    text: "Continue",

                    onPress:
                    _savePersonalInfo,
                  ),

                  const SizedBox(height: 20),

              ],
              ),
              ),
            ),
          ),
      ),
    );
  }

  Future<void>
  _savePersonalInfo() async {

    if (formkey.currentState
        ?.validate() ==
        false) return;

    try {

      uitils.ShowLoading(context);


      User? firebaseUser =
          FirebaseAuth.instance
              .currentUser;

      if (firebaseUser == null) {

        uitils.hideDialog(context);

        uitils.ShowToastMassage(

          "Please Login Again",

          Colors.red,
        );

        return;
      }

      /// create user model

      UserModel user = UserModel(

        id: firebaseUser.uid,

        name:
        _nameController.text
            .trim(),

        email:
        firebaseUser.email ??
            "",

        age: int.parse(
          _ageController.text
              .trim(),
        ),

        weight:
        double.parse(
          _weightController
              .text
              .trim(),
        ),

        targetWeight:
        double.parse(
          _targetWeightController
              .text
              .trim(),
        ),

        height:
        double.parse(
          _heightController
              .text
              .trim(),
        ),

        gender:
        _selectedGender!
            .toLowerCase(),

        goal:
        _selectedGoal ??
            "stay_fit",

        activityLevel:
        _selectedActivityLevel ??
            "moderate",

        waterIntake: 0,

        caloriesTarget:
        int.parse(
          _caloriesController
              .text
              .trim(),
        ),

        streakDays: 0,

        profileImage: null,
      );

      await Fairebaeservices
          .addUasertoFireStore(
        user,
      );

      UserModel.currentUser =
          user;

      // Mark onboarding as completed in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboardingCompleted', true);

      if (!mounted) return;
      uitils.hideDialog(context);

      uitils.ShowToastMassage(
        "Information Saved",
        Colors.green,
      );

      // Navigate to Home and remove all previous routes (no back button allowed)
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routesmanger.mainlayout,
        (route) => false,
      );

    } on FirebaseException catch (e) {

      uitils.hideDialog(context);

      uitils.ShowToastMassage(

        e.code,

        Colors.red,
      );

    } catch (e) {

      uitils.hideDialog(context);

      uitils.ShowToastMassage(

        "Failed To Save Information",

        Colors.red,
      );
    }
  }
}