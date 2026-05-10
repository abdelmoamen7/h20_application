import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @nutrition.
  ///
  /// In en, this message translates to:
  /// **'Nutrition'**
  String get nutrition;

  /// No description provided for @nutrition_plan.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Plan'**
  String get nutrition_plan;

  /// No description provided for @nutrition_details.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Details'**
  String get nutrition_details;

  /// No description provided for @daily_nutrition.
  ///
  /// In en, this message translates to:
  /// **'Daily Nutrition'**
  String get daily_nutrition;

  /// No description provided for @nutrition_goal.
  ///
  /// In en, this message translates to:
  /// **'Nutrition Goal'**
  String get nutrition_goal;

  /// No description provided for @workout.
  ///
  /// In en, this message translates to:
  /// **'Workout'**
  String get workout;

  /// No description provided for @workouts.
  ///
  /// In en, this message translates to:
  /// **'Workouts'**
  String get workouts;

  /// No description provided for @workout_plan.
  ///
  /// In en, this message translates to:
  /// **'Workout Plan'**
  String get workout_plan;

  /// No description provided for @workout_details.
  ///
  /// In en, this message translates to:
  /// **'Workout Details'**
  String get workout_details;

  /// No description provided for @daily_workout.
  ///
  /// In en, this message translates to:
  /// **'Daily Workout'**
  String get daily_workout;

  /// No description provided for @weekly_workout.
  ///
  /// In en, this message translates to:
  /// **'Weekly Workout'**
  String get weekly_workout;

  /// No description provided for @start_workout.
  ///
  /// In en, this message translates to:
  /// **'Start Workout'**
  String get start_workout;

  /// No description provided for @complete_workout.
  ///
  /// In en, this message translates to:
  /// **'Complete Workout'**
  String get complete_workout;

  /// No description provided for @workout_completed.
  ///
  /// In en, this message translates to:
  /// **'Workout Completed'**
  String get workout_completed;

  /// No description provided for @exercise.
  ///
  /// In en, this message translates to:
  /// **'Exercise'**
  String get exercise;

  /// No description provided for @exercises.
  ///
  /// In en, this message translates to:
  /// **'Exercises'**
  String get exercises;

  /// No description provided for @push_workout.
  ///
  /// In en, this message translates to:
  /// **'Push Workout'**
  String get push_workout;

  /// No description provided for @pull_workout.
  ///
  /// In en, this message translates to:
  /// **'Pull Workout'**
  String get pull_workout;

  /// No description provided for @legs_workout.
  ///
  /// In en, this message translates to:
  /// **'Legs Workout'**
  String get legs_workout;

  /// No description provided for @cardio_workout.
  ///
  /// In en, this message translates to:
  /// **'Cardio Workout'**
  String get cardio_workout;

  /// No description provided for @full_body_workout.
  ///
  /// In en, this message translates to:
  /// **'Full Body Workout'**
  String get full_body_workout;

  /// No description provided for @workout_duration.
  ///
  /// In en, this message translates to:
  /// **'Workout Duration'**
  String get workout_duration;

  /// No description provided for @workout_level.
  ///
  /// In en, this message translates to:
  /// **'Workout Level'**
  String get workout_level;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @meal_plan.
  ///
  /// In en, this message translates to:
  /// **'Meal Plan'**
  String get meal_plan;

  /// No description provided for @meal_details.
  ///
  /// In en, this message translates to:
  /// **'Meal Details'**
  String get meal_details;

  /// No description provided for @meal_category.
  ///
  /// In en, this message translates to:
  /// **'Meal Category'**
  String get meal_category;

  /// No description provided for @healthy_food.
  ///
  /// In en, this message translates to:
  /// **'Healthy Food'**
  String get healthy_food;

  /// No description provided for @recommended_meals.
  ///
  /// In en, this message translates to:
  /// **'Recommended Meals'**
  String get recommended_meals;

  /// No description provided for @calories.
  ///
  /// In en, this message translates to:
  /// **'Calories'**
  String get calories;

  /// No description provided for @protein.
  ///
  /// In en, this message translates to:
  /// **'Protein'**
  String get protein;

  /// No description provided for @carbohydrates.
  ///
  /// In en, this message translates to:
  /// **'Carbohydrates'**
  String get carbohydrates;

  /// No description provided for @fats.
  ///
  /// In en, this message translates to:
  /// **'Fats'**
  String get fats;

  /// No description provided for @water_goal.
  ///
  /// In en, this message translates to:
  /// **'Water Goal'**
  String get water_goal;

  /// No description provided for @water_tracker.
  ///
  /// In en, this message translates to:
  /// **'Water Tracker'**
  String get water_tracker;

  /// No description provided for @body_analysis.
  ///
  /// In en, this message translates to:
  /// **'Body Analysis'**
  String get body_analysis;

  /// No description provided for @fitness_goal.
  ///
  /// In en, this message translates to:
  /// **'Fitness Goal'**
  String get fitness_goal;

  /// No description provided for @muscle_gain.
  ///
  /// In en, this message translates to:
  /// **'Muscle Gain'**
  String get muscle_gain;

  /// No description provided for @fat_loss.
  ///
  /// In en, this message translates to:
  /// **'Fat Loss'**
  String get fat_loss;

  /// No description provided for @track_progress.
  ///
  /// In en, this message translates to:
  /// **'Track Progress'**
  String get track_progress;

  /// No description provided for @exercise_details.
  ///
  /// In en, this message translates to:
  /// **'Exercise Details'**
  String get exercise_details;

  /// No description provided for @watch_video.
  ///
  /// In en, this message translates to:
  /// **'Watch Video'**
  String get watch_video;

  /// No description provided for @sets.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get sets;

  /// No description provided for @reps.
  ///
  /// In en, this message translates to:
  /// **'Reps'**
  String get reps;

  /// No description provided for @rest_time.
  ///
  /// In en, this message translates to:
  /// **'Rest Time'**
  String get rest_time;

  /// No description provided for @search_exercise.
  ///
  /// In en, this message translates to:
  /// **'Search Exercise'**
  String get search_exercise;

  /// No description provided for @search_meal.
  ///
  /// In en, this message translates to:
  /// **'Search Meal'**
  String get search_meal;

  /// No description provided for @favorite_meals.
  ///
  /// In en, this message translates to:
  /// **'Favorite Meals'**
  String get favorite_meals;

  /// No description provided for @favorite_exercises.
  ///
  /// In en, this message translates to:
  /// **'Favorite Exercises'**
  String get favorite_exercises;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get create_account;

  /// No description provided for @already_have_account.
  ///
  /// In en, this message translates to:
  /// **'Already Have Account?'**
  String get already_have_account;

  /// No description provided for @dont_have_account.
  ///
  /// In en, this message translates to:
  /// **'Don\'t Have Account?'**
  String get dont_have_account;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @re_password.
  ///
  /// In en, this message translates to:
  /// **'Re-Password'**
  String get re_password;

  /// No description provided for @forget_password.
  ///
  /// In en, this message translates to:
  /// **'Forget Password'**
  String get forget_password;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password;

  /// No description provided for @login_with_google.
  ///
  /// In en, this message translates to:
  /// **'Login With Google'**
  String get login_with_google;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @welcome_back.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcome_back;

  /// No description provided for @welcome_message.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back To Your Fitness Journey'**
  String get welcome_message;

  /// No description provided for @good_morning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get good_morning;

  /// No description provided for @good_evening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get good_evening;

  /// No description provided for @lets_start.
  ///
  /// In en, this message translates to:
  /// **'Let\'s Start Your Journey'**
  String get lets_start;

  /// No description provided for @stay_healthy.
  ///
  /// In en, this message translates to:
  /// **'Stay Healthy & Stay Strong'**
  String get stay_healthy;
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


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
