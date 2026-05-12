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

  // Daily tracking — reset each new day
  int dailyCaloriesConsumed;
  double dailyWaterConsumed; // in litres
  int dailyProteinConsumed;  // in grams
  String lastTrackingDate; // "yyyy-MM-dd" — used to auto-reset daily values

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
    this.dailyCaloriesConsumed = 0,
    this.dailyWaterConsumed = 0.0,
    this.dailyProteinConsumed = 0,
    this.lastTrackingDate = '',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final today = _todayStr();
    final lastDate = (json["lastTrackingDate"] ?? '') as String;
    final isNewDay = lastDate != today;

    return UserModel(
      name: json["name"] ?? "",
      id: json["id"] ?? "",
      email: json["email"] ?? "",
      age: json["age"] ?? 0,
      weight: (json["weight"] as num?)?.toDouble() ?? 0,
      height: (json["height"] as num?)?.toDouble() ?? 0,
      gender: json["gender"] ?? "male",
      goal: json["goal"] ?? "stay_fit",
      activityLevel: json["activityLevel"] ?? "moderate",
      waterIntake: (json["waterIntake"] as num?)?.toDouble() ?? 0,
      caloriesTarget: json["caloriesTarget"] ?? 0,
      streakDays: json["streakDays"] ?? 0,
      profileImage: json["profileImage"],
      targetWeight: (json["targetWeight"] as num?)?.toDouble() ?? 0,
      // Reset daily values if it's a new day
      dailyCaloriesConsumed: isNewDay ? 0 : (json["dailyCaloriesConsumed"] ?? 0),
      dailyWaterConsumed: isNewDay ? 0.0 : (json["dailyWaterConsumed"] as num?)?.toDouble() ?? 0.0,
      dailyProteinConsumed: isNewDay ? 0 : (json["dailyProteinConsumed"] ?? 0),
      lastTrackingDate: isNewDay ? today : lastDate,
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
      "activityLevel": activityLevel,
      "waterIntake": waterIntake,
      "caloriesTarget": caloriesTarget,
      "streakDays": streakDays,
      "profileImage": profileImage,
      "targetWeight": targetWeight,
      "dailyCaloriesConsumed": dailyCaloriesConsumed,
      "dailyWaterConsumed": dailyWaterConsumed,
      "dailyProteinConsumed": dailyProteinConsumed,
      "lastTrackingDate": lastTrackingDate,
    };
  }

  static String _todayStr() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}