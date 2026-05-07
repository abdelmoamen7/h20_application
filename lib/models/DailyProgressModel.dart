import 'package:cloud_firestore/cloud_firestore.dart';

/// ======================================================
/// DAILY PROGRESS MODEL
/// ======================================================

class DailyProgressModel {

  String? id;

  String? userId;

  int? caloriesConsumed;

  int? caloriesBurned;

  double? waterIntake;

  int? steps;

  double? weight;

  bool? completedWorkout;

  String? mood;

  DateTime? date;

  DailyProgressModel(
      this.id,
      this.userId,
      this.caloriesConsumed,
      this.caloriesBurned,
      this.waterIntake,
      this.steps,
      this.weight,
      this.completedWorkout,
      this.mood,
      this.date,
      );

  factory DailyProgressModel.fromJson(
      Map<String, dynamic> json) {

    return DailyProgressModel(

      json["id"],

      json["userId"],

      json["caloriesConsumed"],

      json["caloriesBurned"],

      (json["waterIntake"] as num?)
          ?.toDouble(),

      json["steps"],

      (json["weight"] as num?)
          ?.toDouble(),

      json["completedWorkout"],

      json["mood"],

      json["date"] != null
          ? (json["date"] as Timestamp)
          .toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "userId": userId,

      "caloriesConsumed":
      caloriesConsumed,

      "caloriesBurned":
      caloriesBurned,

      "waterIntake":
      waterIntake,

      "steps": steps,

      "weight": weight,

      "completedWorkout":
      completedWorkout,

      "mood": mood,

      "date": date != null
          ? Timestamp.fromDate(date!)
          : null,
    };
  }
}