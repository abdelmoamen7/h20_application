import 'dart:async';

import 'package:dio/dio.dart';

import '../../models/nutrition_model.dart';
import 'nutrition_api_config.dart';
import 'nutrition_local_db.dart';

class FoodSuggestion {
  final String description;
  final int fdcId;

  const FoodSuggestion({required this.description, required this.fdcId});
}

class NutritionRemoteDataSource {
  NutritionRemoteDataSource({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 25),
                receiveTimeout: const Duration(seconds: 25),
              ),
            );

  final Dio _dio;

  Map<String, dynamic>? _asJsonMap(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  // ─── Autocomplete suggestions (local DB first, USDA fallback) ─────────────
  Future<List<FoodSuggestion>> searchFoods(String query) async {
    final trimmed = query.trim().toLowerCase();
    if (trimmed.isEmpty) return const [];

    // Local suggestions first (instant, no network)
    final localMatches = NutritionLocalDb.entries.keys
        .where((k) => k.contains(trimmed))
        .take(6)
        .map((k) => FoodSuggestion(description: k, fdcId: 0))
        .toList();

    if (localMatches.isNotEmpty) return localMatches;

    // USDA fallback
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '${NutritionApiConfig.usdaBaseUrl}/foods/search',
        queryParameters: {'api_key': NutritionApiConfig.usdaApiKey},
        data: {
          'query': trimmed,
          'pageSize': 8,
          'dataType': ['Foundation', 'SR Legacy', 'Survey (FNDDS)', 'Branded'],
        },
        options: Options(
          headers: {Headers.contentTypeHeader: Headers.jsonContentType},
          sendTimeout: const Duration(seconds: 25),
          receiveTimeout: const Duration(seconds: 25),
        ),
      );
      final foods = (response.data?['foods'] as List<dynamic>? ?? const []);
      return foods
          .map(_asJsonMap)
          .whereType<Map<String, dynamic>>()
          .where((e) => e['description'] != null && e['fdcId'] != null)
          .map((e) => FoodSuggestion(
                description: e['description'].toString(),
                fdcId: (e['fdcId'] as num).toInt(),
              ))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  // ─── Natural language food text → NutritionModel ──────────────────────────
  /// Parses queries like:
  ///   "100g chicken, two eggs"
  ///   "200g beef, 2 eggs and 2 bananas"
  /// Uses a built-in nutrition database (per 100 g values) + quantity parsing.
  Future<NutritionModel?> analyzeFoodText(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return null;

    final result = NutritionLocalDb.analyze(trimmed);
    return result;
  }

  // ─── Barcode → NutritionModel (OpenFoodFacts — unchanged) ─────────────────
  Future<NutritionModel?> analyzeBarcode(String barcode) async {
    final cleaned = barcode.trim();
    if (cleaned.isEmpty) return null;

    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${NutritionApiConfig.openFoodFactsBaseUrl}/product/$cleaned.json',
        options: Options(
          sendTimeout: const Duration(seconds: 12),
          receiveTimeout: const Duration(seconds: 12),
        ),
      );

      final product = _asJsonMap(response.data?['product']);
      if (product == null) return null;

      return _nutritionModelFromOpenFoodFactsProduct(
        product,
        cleaned,
        scannedBarcode: cleaned,
      );
    } catch (_) {
      return null;
    }
  }

  // ─── OpenFoodFacts helpers ─────────────────────────────────────────────────
  NutritionModel _nutritionModelFromOpenFoodFactsProduct(
    Map<String, dynamic> product,
    String lookupKey, {
    String? scannedBarcode,
  }) {
    final nutriments = _asJsonMap(product['nutriments']) ?? {};
    final displayName = _openFoodFactsDisplayName(product, lookupKey);
    final brand =
        _firstNonEmptyString(product, const ['brands', 'brand_owner']);
    final quantity =
        _firstNonEmptyString(product, const ['quantity', 'product_quantity']);
    final serving = (product['serving_size'] ?? '100 g').toString();

    final sodium100g = _toDouble(nutriments['sodium_100g']);
    return NutritionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      foodName: displayName,
      calories:
          _toDouble(nutriments['energy-kcal_100g'] ?? nutriments['energy-kcal']),
      protein:
          _toDouble(nutriments['proteins_100g'] ?? nutriments['proteins']),
      fat: _toDouble(nutriments['fat_100g'] ?? nutriments['fat']),
      carbs: _toDouble(
          nutriments['carbohydrates_100g'] ?? nutriments['carbohydrates']),
      fiber: _toDouble(nutriments['fiber_100g'] ?? nutriments['fiber']),
      sugar: _toDouble(nutriments['sugars_100g'] ?? nutriments['sugars']),
      servingSize: serving,
      sodium: sodium100g > 0 ? sodium100g * 1000 : 0,
      potassium:
          _toDouble(nutriments['potassium_100g'] ?? nutriments['potassium']),
      cholesterol: _toDouble(
          nutriments['cholesterol_100g'] ?? nutriments['cholesterol']),
      source: 'OpenFoodFacts',
      brand: brand,
      quantity: quantity,
      barcode: scannedBarcode ?? product['code']?.toString(),
    );
  }

  String _openFoodFactsDisplayName(
      Map<String, dynamic> product, String fallbackBarcode) {
    for (final key in const [
      'product_name',
      'product_name_en',
      'product_name_fr',
      'product_name_ar',
      'abbreviated_product_name',
      'generic_name',
    ]) {
      final v = product[key]?.toString().trim();
      if (v != null && v.isNotEmpty) return v;
    }
    final brands = product['brands']?.toString().trim();
    if (brands != null && brands.isNotEmpty) {
      return brands.split(',').first.trim();
    }
    return 'Product $fallbackBarcode';
  }

  String? _firstNonEmptyString(Map<String, dynamic> map, List<String> keys) {
    for (final key in keys) {
      final v = map[key]?.toString().trim();
      if (v != null && v.isNotEmpty) return v;
    }
    return null;
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}
