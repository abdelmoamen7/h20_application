import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  // ── Navigation ──
  String get home;
  String get profile;
  String get nutrition;
  String get workout;
  String get workouts;

  // ── Auth ──
  String get register;
  String get login;
  String get create_account;
  String get already_have_account;
  String get dont_have_account;
  String get email;
  String get password;
  String get re_password;
  String get forget_password;
  String get reset_password;
  String get login_with_google;
  String get logout;
  String get name;
  String get phone;
  String get welcome;
  String get welcome_back;
  String get welcome_message;
  String get join_us;
  String get or;
  String get enter_your_email;
  String get reset_password_subtitle;
  String get send_reset_link;

  // ── Validation ──
  String get val_enter_name;
  String get val_enter_email;
  String get val_invalid_email;
  String get val_enter_password;
  String get val_password_short;
  String get val_reenter_password;
  String get val_passwords_mismatch;
  String get val_enter_age;
  String get val_enter_weight;
  String get val_enter_target_weight;
  String get val_enter_height;
  String get val_enter_calories;
  String get val_choose_gender;
  String get val_choose_goal;
  String get val_choose_activity;
  String get val_enter_email_short;
  String get val_invalid_email_short;

  // ── Toast / Snackbar messages ──
  String get failed_register;
  String get failed_login;
  String get failed_google;
  String get failed_save;
  String get please_login_again;
  String get info_saved;
  String get reset_link_sent;
  String get failed_reset;

  // ── Onboarding ──
  String get personal_information;
  String get personalize_journey;
  String get age;
  String get weight_kg;
  String get target_weight_kg;
  String get height_cm;
  String get calories_target;
  String get gender;
  String get goal;
  String get activity_level;
  String get continue_btn;
  String get male;
  String get female;
  String get lose_weight;
  String get gain_muscle;
  String get stay_fit;
  String get moderate;

  // ── Home ──
  String get good_morning;
  String get good_evening;
  String get good_morning_greeting;
  String get ready_to_crush;
  String get daily_progress;
  String get streak;
  String get days;
  String get quick_exercises;
  String get motivation_quote;
  String get no_user_data;
  String get browse_workouts_hint;
  String get notifications;
  String get notifications_empty;
  String get ok;
  String get stay_motivated;
  String get motivation_tip1;
  String get motivation_tip2;
  String get motivation_tip3;
  String get go_to_workouts;
  String get lets_start;
  String get stay_healthy;

  // ── Workout ──
  String get nutrition_plan;
  String get nutrition_details;
  String get daily_nutrition;
  String get nutrition_goal;
  String get workout_plan;
  String get workout_details;
  String get daily_workout;
  String get weekly_workout;
  String get start_workout;
  String get complete_workout;
  String get workout_completed;
  String get exercise;
  String get exercises;
  String get push_workout;
  String get pull_workout;
  String get legs_workout;
  String get cardio_workout;
  String get full_body_workout;
  String get workout_duration;
  String get workout_level;
  String get beginner;
  String get intermediate;
  String get advanced;
  String get todays_workouts;
  String get see_all;
  String get no_workouts_available;
  String get discover_workouts;
  String get error_loading_workouts;
  String get retry;
  String get no_workouts_found;
  String get no_instructions;
  String get back_to_workout;
  String get instructions;

  // ── Nutrition ──
  String get meal_plan;
  String get meal_details;
  String get meal_category;
  String get healthy_food;
  String get recommended_meals;
  String get recommended_meal;
  String get view_meal;
  String get calories;
  String get protein;
  String get carbohydrates;
  String get fats;
  String get carbs;
  String get fat;
  String get sugar;
  String get fiber;
  String get sodium;
  String get potassium;
  String get cholesterol;
  String get macronutrients;
  String get more_details;
  String get product;
  String get kcal;
  String get calories_intake;
  String get water_goal;
  String get water_tracker;
  String get water;
  String get analyze_meal;
  String get type_ingredients;
  String get meal_hint;
  String get analyze_food;
  String get scan;
  String get fetching_nutrition;
  String get something_went_wrong;
  String get no_results_yet;
  String get no_results_subtitle;
  String get scan_barcode;
  String get search_exercise;
  String get search_meal;
  String get favorite_meals;
  String get favorite_exercises;

  // ── Body / Health ──
  String get body_analysis;
  String get fitness_goal;
  String get muscle_gain;
  String get fat_loss;
  String get track_progress;
  String get exercise_details;
  String get watch_video;
  String get sets;
  String get reps;
  String get rest_time;
  String get nutrition_summary;
  String get log_meal;
  String get health_summary;
  String get bmi;
  String get target;
  String get goal_progress;

  // ── Profile ──
  String get personal_info;
  String get fitness_nutrition_goals;
  String get day_streak;
  String get sign_out;
  String get no_user_data_found;
  String get camera;
  String get gallery;
  String get age_label;
  String get height_label;
  String get weight_label;
  String get gender_label;
  String get goal_label;
  String get activity_level_label;
  String get target_weight_label;
  String get water_intake_label;
  String get daily_calories_label;
  String get years;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }
  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale".',
  );
}
