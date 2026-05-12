import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:h20_application/core/assetsmanger/assetsmanger.dart';

import '../../../core/routesmanger/routesManger.dart';
import '../../../core/utilis/Uiutills.dart';
import '../../../core/widget/Custom_Elvated button.dart';
import '../../../core/widget/Custom_text_form.dart';
import '../../../l10n/app_localizations.dart';
import '../../../models/UserModel.dart';
import '../../../services/FirebaseServcies/firebaseService.dart';
import 'CustomDropdown.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _weightController;
  late TextEditingController _targetWeightController;
  late TextEditingController _heightController;
  late TextEditingController _caloriesController;

  String? _selectedGender;
  String? _selectedGoal;
  String? _selectedActivityLevel;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _ageController = TextEditingController();
    _weightController = TextEditingController();
    _targetWeightController = TextEditingController();
    _heightController = TextEditingController();
    _caloriesController = TextEditingController();
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
    final l = AppLocalizations.of(context)!;

    final List<String> genders = [l.male, l.female];
    final List<String> goals = [l.lose_weight, l.gain_muscle, l.stay_fit];
    final List<String> activityLevels = [l.beginner, l.moderate, l.advanced];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          child: SingleChildScrollView(
            child: Form(
              key: formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image(
                        image: AssetImage(Imagemanger.onbordingimage),
                        width: 300,
                        height: 200,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l.personal_information,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l.personalize_journey,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 30),
                  CustomTextForm(
                    controller: _nameController,
                    labelText: l.name,
                    prefixIcon: Icons.person,
                    validator: (input) {
                      if (input == null || input.trim().isEmpty) {
                        return l.val_enter_name;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextForm(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    labelText: l.age,
                    prefixIcon: Icons.cake,
                    validator: (input) {
                      final age = int.tryParse(input?.trim() ?? "");
                      if (age == null) return l.val_enter_age;
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextForm(
                    controller: _weightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    labelText: l.weight_kg,
                    prefixIcon: Icons.monitor_weight,
                    validator: (input) {
                      final value = double.tryParse(input?.trim() ?? "");
                      if (value == null) return l.val_enter_weight;
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextForm(
                    controller: _targetWeightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    labelText: l.target_weight_kg,
                    prefixIcon: Icons.flag,
                    validator: (input) {
                      final value = double.tryParse(input?.trim() ?? "");
                      if (value == null) return l.val_enter_target_weight;
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextForm(
                    controller: _heightController,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    labelText: l.height_cm,
                    prefixIcon: Icons.height,
                    validator: (input) {
                      final value = double.tryParse(input?.trim() ?? "");
                      if (value == null) return l.val_enter_height;
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomTextForm(
                    controller: _caloriesController,
                    keyboardType: TextInputType.number,
                    labelText: l.calories_target,
                    prefixIcon: Icons.local_fire_department,
                    validator: (input) {
                      final value = int.tryParse(input?.trim() ?? "");
                      if (value == null) return l.val_enter_calories;
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomDropdown(
                    label: l.gender,
                    selectedItem: _selectedGender,
                    items: genders,
                    prefixIcon: Icons.wc,
                    onChanged: (value) => setState(() => _selectedGender = value),
                    validator: (value) {
                      if (value == null) return l.val_choose_gender;
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomDropdown(
                    label: l.goal,
                    selectedItem: _selectedGoal,
                    items: goals,
                    prefixIcon: Icons.flag,
                    onChanged: (value) => setState(() => _selectedGoal = value),
                    validator: (value) {
                      if (value == null) return l.val_choose_goal;
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  CustomDropdown(
                    label: l.activity_level,
                    selectedItem: _selectedActivityLevel,
                    items: activityLevels,
                    prefixIcon: Icons.fitness_center,
                    onChanged: (value) => setState(() => _selectedActivityLevel = value),
                    validator: (value) {
                      if (value == null) return l.val_choose_activity;
                      return null;
                    },
                  ),
                  const SizedBox(height: 35),
                  Coustom_Elvated_Button(
                    text: l.continue_btn,
                    onPress: _savePersonalInfo,
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

  /// Convert localized gender display string → canonical key stored in Firestore
  String _genderToKey(String display, AppLocalizations l) {
    if (display == l.male) return 'male';
    if (display == l.female) return 'female';
    return display.toLowerCase();
  }

  /// Convert localized goal display string → canonical key stored in Firestore
  String _goalToKey(String display, AppLocalizations l) {
    if (display == l.lose_weight) return 'lose_weight';
    if (display == l.gain_muscle) return 'gain_muscle';
    if (display == l.stay_fit) return 'stay_fit';
    return display.toLowerCase().replaceAll(' ', '_');
  }

  /// Convert localized activity level display string → canonical key
  String _activityToKey(String display, AppLocalizations l) {
    if (display == l.beginner) return 'beginner';
    if (display == l.moderate) return 'moderate';
    if (display == l.advanced) return 'advanced';
    return display.toLowerCase();
  }

  Future<void> _savePersonalInfo() async {
    final l = AppLocalizations.of(context)!;
    if (formkey.currentState?.validate() == false) return;

    try {
      uitils.ShowLoading(context);

      User? firebaseUser = FirebaseAuth.instance.currentUser;
      if (firebaseUser == null) {
        uitils.hideDialog(context);
        uitils.ShowToastMassage(l.please_login_again, Colors.red);
        return;
      }

      UserModel user = UserModel(
        id: firebaseUser.uid,
        name: _nameController.text.trim(),
        email: firebaseUser.email ?? "",
        age: int.parse(_ageController.text.trim()),
        weight: double.parse(_weightController.text.trim()),
        targetWeight: double.parse(_targetWeightController.text.trim()),
        height: double.parse(_heightController.text.trim()),
        // Store canonical lowercase keys, not localized display strings
        gender: _genderToKey(_selectedGender!, l),
        goal: _goalToKey(_selectedGoal!, l),
        activityLevel: _activityToKey(_selectedActivityLevel!, l),
        waterIntake: 0,
        caloriesTarget: int.parse(_caloriesController.text.trim()),
        streakDays: 0,
        profileImage: null,
      );

      await Fairebaeservices.addUasertoFireStore(user);
      UserModel.currentUser = user;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboardingCompleted', true);

      if (!mounted) return;
      uitils.hideDialog(context);
      uitils.ShowToastMassage(l.info_saved, Colors.green);

      Navigator.pushNamedAndRemoveUntil(
        context,
        Routesmanger.mainlayout,
        (route) => false,
      );
    } on FirebaseException catch (e) {
      uitils.hideDialog(context);
      uitils.ShowToastMassage(e.code, Colors.red);
    } catch (e) {
      uitils.hideDialog(context);
      uitils.ShowToastMassage(l.failed_save, Colors.red);
    }
  }
}
