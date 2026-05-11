class NutritionModel {
  final String id;
  final String foodName;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;
  final double fiber;
  final double sugar;
  final String servingSize;
  final double sodium;
  final double potassium;
  final double cholesterol;
  final String source;

  /// Set for barcode (OpenFoodFacts) products: brand line, pack size, scanned code.
  final String? brand;
  final String? quantity;
  final String? barcode;

  NutritionModel({
    required this.id,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.fiber,
    required this.sugar,
    required this.servingSize,
    required this.sodium,
    required this.potassium,
    required this.cholesterol,
    required this.source,
    this.brand,
    this.quantity,
    this.barcode,
  });

  factory NutritionModel.fromJson(Map<String, dynamic> json) {
    return NutritionModel(
      id: (json['id'] ?? DateTime.now().millisecondsSinceEpoch).toString(),
      foodName: (json['foodName'] ?? json['name'] ?? '').toString(),
      calories: _toDouble(json['calories']),
      protein: _toDouble(json['protein']),
      fat: _toDouble(json['fat']),
      carbs: _toDouble(json['carbs']),
      fiber: _toDouble(json['fiber']),
      sugar: _toDouble(json['sugar']),
      servingSize: (json['servingSize'] ?? '100 g').toString(),
      sodium: _toDouble(json['sodium']),
      potassium: _toDouble(json['potassium']),
      cholesterol: _toDouble(json['cholesterol']),
      source: (json['source'] ?? 'unknown').toString(),
      brand: json['brand']?.toString(),
      quantity: json['quantity']?.toString(),
      barcode: json['barcode']?.toString(),
    );
  }

  NutritionModel copyWith({
    String? id,
    String? foodName,
    double? calories,
    double? protein,
    double? fat,
    double? carbs,
    double? fiber,
    double? sugar,
    String? servingSize,
    double? sodium,
    double? potassium,
    double? cholesterol,
    String? source,
    String? brand,
    String? quantity,
    String? barcode,
  }) {
    return NutritionModel(
      id: id ?? this.id,
      foodName: foodName ?? this.foodName,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbs: carbs ?? this.carbs,
      fiber: fiber ?? this.fiber,
      sugar: sugar ?? this.sugar,
      servingSize: servingSize ?? this.servingSize,
      sodium: sodium ?? this.sodium,
      potassium: potassium ?? this.potassium,
      cholesterol: cholesterol ?? this.cholesterol,
      source: source ?? this.source,
      brand: brand ?? this.brand,
      quantity: quantity ?? this.quantity,
      barcode: barcode ?? this.barcode,
    );
  }

  static NutritionModel aggregate(String query, List<NutritionModel> items) {
    if (items.isEmpty) {
      return NutritionModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        foodName: query,
        calories: 0,
        protein: 0,
        fat: 0,
        carbs: 0,
        fiber: 0,
        sugar: 0,
        servingSize: 'N/A',
        sodium: 0,
        potassium: 0,
        cholesterol: 0,
        source: 'USDA',
        brand: null,
        quantity: null,
        barcode: null,
      );
    }

    double calories = 0;
    double protein = 0;
    double fat = 0;
    double carbs = 0;
    double fiber = 0;
    double sugar = 0;
    double sodium = 0;
    double potassium = 0;
    double cholesterol = 0;

    for (final item in items) {
      calories += item.calories;
      protein += item.protein;
      fat += item.fat;
      carbs += item.carbs;
      fiber += item.fiber;
      sugar += item.sugar;
      sodium += item.sodium;
      potassium += item.potassium;
      cholesterol += item.cholesterol;
    }

    return NutritionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      foodName: query,
      calories: calories,
      protein: protein,
      fat: fat,
      carbs: carbs,
      fiber: fiber,
      sugar: sugar,
      servingSize: 'Mixed serving',
      sodium: sodium,
      potassium: potassium,
      cholesterol: cholesterol,
      source: items.first.source,
      brand: null,
      quantity: null,
      barcode: null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'foodName': foodName,
      'calories': calories,
      'protein': protein,
      'fat': fat,
      'carbs': carbs,
      'fiber': fiber,
      'sugar': sugar,
      'servingSize': servingSize,
      'sodium': sodium,
      'potassium': potassium,
      'cholesterol': cholesterol,
      'source': source,
      if (brand != null) 'brand': brand,
      if (quantity != null) 'quantity': quantity,
      if (barcode != null) 'barcode': barcode,
    };
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}
