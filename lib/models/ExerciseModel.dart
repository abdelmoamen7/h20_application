/// ======================================================
/// EXERCISE MODEL
/// ======================================================

class ExerciseModel {

  String? id;

  String? name;

  String? bodyPart;

  String? equipment;

  String? target;

  String? gifUrl;

  String? videoUrl;

  String? description;

  List<String>? instructions;

  int? sets;

  int? reps;

  int? restSeconds;

  String? difficulty;

  double? caloriesBurned;

  ExerciseModel(
      this.id,
      this.name,
      this.bodyPart,
      this.equipment,
      this.target,
      this.gifUrl,
      this.videoUrl,
      this.description,
      this.instructions,
      this.sets,
      this.reps,
      this.restSeconds,
      this.difficulty,
      this.caloriesBurned,
      );

  factory ExerciseModel.fromJson(
      Map<String, dynamic> json) {

    return ExerciseModel(

      json["id"],

      json["name"],

      json["bodyPart"],

      json["equipment"],

      json["target"],

      json["gifUrl"],

      json["videoUrl"],

      json["description"],

      json["instructions"] != null
          ? List<String>.from(
          json["instructions"])
          : [],

      json["sets"],

      json["reps"],

      json["restSeconds"],

      json["difficulty"],

      (json["caloriesBurned"] as num?)
          ?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "name": name,

      "bodyPart": bodyPart,

      "equipment": equipment,

      "target": target,

      "gifUrl": gifUrl,

      "videoUrl": videoUrl,

      "description": description,

      "instructions": instructions,

      "sets": sets,

      "reps": reps,

      "restSeconds": restSeconds,

      "difficulty": difficulty,

      "caloriesBurned": caloriesBurned,
    };
  }
}