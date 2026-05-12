class UserModel {

  String name;

  String id;

  String email;

  static UserModel? currentUser;

  int age;

  double weight;

  double height;

  String gender;

  String goal;

  String activityLevel;

  double waterIntake;

  int caloriesTarget;

  int streakDays;

  String? profileImage;
  double targetWeight;

  UserModel({

    required this.name,

    required this.id,

    required this.email,

    required this.age,

    required this.weight,

    required this.height,

    required this.gender,

    required this.goal,

    required this.activityLevel,

    required this.waterIntake,

    required this.caloriesTarget,

    required this.streakDays,

    this.profileImage,
    required this.targetWeight,

  });


  factory UserModel.fromJson(
      Map<String, dynamic> json) {
    return UserModel(

      name: json["name"] ?? "",

      id: json["id"] ?? "",

      email: json["email"] ?? "",

      age: json["age"] ?? 0,

      weight:
      (json["weight"] as num?)?.toDouble() ?? 0,

      height:
      (json["height"] as num?)?.toDouble() ?? 0,

      gender: json["gender"] ?? "male",

      goal: json["goal"] ?? "stay_fit",

      activityLevel:
      json["activityLevel"] ?? "moderate",

      waterIntake:
      (json["waterIntake"] as num?)
          ?.toDouble() ??
          0,

      caloriesTarget:
      json["caloriesTarget"] ?? 0,

      streakDays:
      json["streakDays"] ?? 0,

      profileImage:
      json["profileImage"],
      targetWeight: (json["targetWeight"] as num?)?.toDouble() ?? 0,
    );
  }
  Map<String, dynamic> toJosn() {

    return {

      "name": name,

      "id": id,

      "email": email,

      "age": age,

      "weight": weight,

      "height": height,

      "gender": gender,

      "goal": goal,

      "activityLevel":
      activityLevel,

      "waterIntake":
      waterIntake,

      "caloriesTarget":
      caloriesTarget,

      "streakDays":
      streakDays,

      "profileImage":
      profileImage,
      "targetWeight": targetWeight,
    };
  }
}