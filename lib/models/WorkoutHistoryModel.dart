import 'package:cloud_firestore/cloud_firestore.dart';

/// ======================================================
/// WORKOUT HISTORY MODEL
/// ======================================================

class WorkoutHistoryModel {

  String? id;

  String? userId;

  String? workoutId;

  String? workoutName;

  int? duration;

  int? caloriesBurned;

  DateTime? completedAt;

  WorkoutHistoryModel(
      this.id,
      this.userId,
      this.workoutId,
      this.workoutName,
      this.duration,
      this.caloriesBurned,
      this.completedAt,
      );

  factory WorkoutHistoryModel.fromJson(
      Map<String, dynamic> json) {

    return WorkoutHistoryModel(

      json["id"],

      json["userId"],

      json["workoutId"],

      json["workoutName"],

      json["duration"],

      json["caloriesBurned"],

      json["completedAt"] != null
          ? (json["completedAt"]
      as Timestamp)
          .toDate()
          : null,
    );
  }

  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "userId": userId,

      "workoutId": workoutId,

      "workoutName": workoutName,

      "duration": duration,

      "caloriesBurned":
      caloriesBurned,

      "completedAt":
      completedAt != null
          ? Timestamp.fromDate(
          completedAt!)
          : null,
    };
  }
}