import 'dart:async';

import 'package:dio/dio.dart';

import '../../models/nutrition_model.dart';
import 'nutrition_api_config.dart';

class FoodSuggestion {
  final String description;
  final int fdcId;

  const FoodSuggestion({required this.description, required this.fdcId});
}

class NutritionRemoteDataSource {
  NutritionRemoteDataSource({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              connectTimeout: const Duration(seconds: 25),
              receiveTimeout: const Duration(seconds: 25),
            ),
          );

  final Dio _dio;

  static Options get _jsonPostOptions => Options(
    headers: {Headers.contentTypeHeader: Headers.jsonContentType},
    sendTimeout: const Duration(seconds: 25),
    receiveTimeout: const Duration(seconds: 25),
  );

  Map<String, dynamic>? _asJsonMap(dynamic value) {
    if (value == null) return null;
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    return null;
  }

  /// USDA FDC nutrient numbers (stable across datasets). See FDC API docs.
  static const int _nEnergyKcal = 1008;
  static const int _nEnergyKcalAlt = 208;
  static const int _nEnergyAtwater = 2047;
  static const int _nEnergyKj = 1062;
  static const int _nProtein = 1003;
  static const int _nFat = 1004;
  static const int _nCarbs = 1005;
  static const int _nFiber = 1079;
  static const int _nSugar = 2000;
  static const int _nSodium = 1093;
  static const int _nPotassium = 1092;
  static const int _nCholesterol = 1253;

  Future<List<FoodSuggestion>> searchFoods(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return const [];

    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '${NutritionApiConfig.usdaBaseUrl}/foods/search',
        queryParameters: {'api_key': NutritionApiConfig.usdaApiKey},
        data: {
          'query': trimmed,
          'pageSize': 8,
          'dataType': ['Foundation', 'SR Legacy', 'Survey (FNDDS)', 'Branded'],
        },
        options: _jsonPostOptions,
      );

      final foods = (response.data?['foods'] as List<dynamic>? ?? const []);
      return foods
          .map(_asJsonMap)
          .whereType<Map<String, dynamic>>()
          .where((e) => e['description'] != null && e['fdcId'] != null)
          .map(
            (e) => FoodSuggestion(
              description: e['description'].toString(),
              fdcId: (e['fdcId'] as num).toInt(),
            ),
          )
          .toList();
    } on DioException {
      return const [];
    } catch (_) {
      return const [];
    }
  }

  /// Resolves free-text meals (e.g. "2 eggs, banana, milk") using USDA search
  /// + full `/food/{fdcId}` documents for reliable macros.
  Future<NutritionModel?> analyzeFoodText(String query) async {
    try {
      final normalized = _normalizeMealText(query);
      if (normalized.isEmpty) return null;

      final phrases = _splitMealText(normalized);
      if (phrases.isEmpty) return null;

      final segments = <({String cleaned, double multiplier})>[];
      for (final raw in phrases) {
        final qty = _extractLeadingQuantity(raw);
        final cleaned = _cleanFoodPhrase(qty.remainder.isEmpty ? raw : qty.remainder);
        if (cleaned.isEmpty) continue;
        segments.add((cleaned: cleaned, multiplier: qty.multiplier));
      }
      if (segments.isEmpty) {
        return _resolveFromSearchPhrase(normalized);
      }

      // Sequential calls: USDA DEMO_KEY hits 429 if many requests run at once.
      final resolved = <NutritionModel>[];
      for (final seg in segments) {
        var nutrition = await _resolveFromSearchPhrase(seg.cleaned);
        if (nutrition != null && _hasAnyMacro(nutrition)) {
          if (seg.multiplier != 1) {
            nutrition = _scaleNutritionByPortion(nutrition, seg.multiplier);
          }
          resolved.add(nutrition);
        }
      }

      if (resolved.isEmpty) {
        final wholeQty = _extractLeadingQuantity(normalized);
        var searchPhrase = _cleanFoodPhrase(
          wholeQty.remainder.isNotEmpty ? wholeQty.remainder : normalized,
        );
        if (searchPhrase.isEmpty) searchPhrase = normalized;

        var fallback = await _resolveFromSearchPhrase(searchPhrase);
        if (fallback != null &&
            wholeQty.multiplier != 1 &&
            _hasAnyMacro(fallback)) {
          fallback = _scaleNutritionByPortion(fallback, wholeQty.multiplier);
        }
        return fallback;
      }

      if (resolved.length == 1) return resolved.first;
      return NutritionModel.aggregate(query, resolved);
    } catch (_) {
      return null;
    }
  }

  bool _hasAnyMacro(NutritionModel n) {
    return n.calories > 0 || n.protein > 0 || n.fat > 0 || n.carbs > 0;
  }

  /// Leading quantity in free text: `"3 eggs"` → `3` and `"eggs"`;
  /// no leading number → multiplier `1` and full string as remainder.
  ({String remainder, double multiplier}) _extractLeadingQuantity(
    String raw,
  ) {
    final s = raw.trim();
    if (s.isEmpty) return (remainder: '', multiplier: 1.0);

    final numMatch = RegExp(
      r'^(\d+(?:\.\d+)?|\d+\s*/\s*\d+)\s+',
      caseSensitive: false,
    ).firstMatch(s);
    if (numMatch != null) {
      final parsed = _parseLeadingQuantityToken(numMatch.group(1)!);
      if (parsed != null && parsed > 0) {
        return (remainder: s.substring(numMatch.end).trim(), multiplier: parsed);
      }
    }

    final wordMatch = RegExp(
      r'^(one|two|three|four|five|six|seven|eight|nine|ten|a|an)\s+',
      caseSensitive: false,
    ).firstMatch(s);
    if (wordMatch != null) {
      final mult = _wordQuantityToDouble(wordMatch.group(1)!);
      return (remainder: s.substring(wordMatch.end).trim(), multiplier: mult);
    }

    return (remainder: s, multiplier: 1.0);
  }

  double? _parseLeadingQuantityToken(String token) {
    final t = token.trim();
    if (t.contains('/')) {
      final parts = t.split('/');
      if (parts.length != 2) return null;
      final a = double.tryParse(parts[0].trim()) ?? 0;
      final b = double.tryParse(parts[1].trim()) ?? 0;
      if (b == 0) return null;
      return a / b;
    }
    return double.tryParse(t);
  }

  double _wordQuantityToDouble(String word) {
    switch (word.toLowerCase()) {
      case 'one':
        return 1;
      case 'two':
        return 2;
      case 'three':
        return 3;
      case 'four':
        return 4;
      case 'five':
        return 5;
      case 'six':
        return 6;
      case 'seven':
        return 7;
      case 'eight':
        return 8;
      case 'nine':
        return 9;
      case 'ten':
        return 10;
      case 'a':
      case 'an':
        return 1;
      default:
        return 1;
    }
  }

  NutritionModel _scaleNutritionByPortion(
    NutritionModel n,
    double multiplier,
  ) {
    if (multiplier == 1 || multiplier <= 0) return n;
    return n.copyWith(
      calories: n.calories * multiplier,
      protein: n.protein * multiplier,
      fat: n.fat * multiplier,
      carbs: n.carbs * multiplier,
      fiber: n.fiber * multiplier,
      sugar: n.sugar * multiplier,
      sodium: n.sodium * multiplier,
      potassium: n.potassium * multiplier,
      cholesterol: n.cholesterol * multiplier,
    );
  }

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

  /// Shared Open Food Facts → [NutritionModel] (per 100 g / serving fields).
  NutritionModel _nutritionModelFromOpenFoodFactsProduct(
    Map<String, dynamic> product,
    String lookupKey, {
    String? scannedBarcode,
  }) {
    final nutriments = _asJsonMap(product['nutriments']) ?? {};
    final displayName = _openFoodFactsDisplayName(product, lookupKey);
    final brand = _firstNonEmptyString(product, const [
      'brands',
      'brand_owner',
    ]);
    final quantity = _firstNonEmptyString(product, const [
      'quantity',
      'product_quantity',
    ]);
    final serving = (product['serving_size'] ?? '100 g').toString();

    final sodium100g = _toDouble(nutriments['sodium_100g']);
    return NutritionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      foodName: displayName,
      calories: _toDouble(
        nutriments['energy-kcal_100g'] ?? nutriments['energy-kcal'],
      ),
      protein: _toDouble(nutriments['proteins_100g'] ?? nutriments['proteins']),
      fat: _toDouble(nutriments['fat_100g'] ?? nutriments['fat']),
      carbs: _toDouble(
        nutriments['carbohydrates_100g'] ?? nutriments['carbohydrates'],
      ),
      fiber: _toDouble(nutriments['fiber_100g'] ?? nutriments['fiber']),
      sugar: _toDouble(nutriments['sugars_100g'] ?? nutriments['sugars']),
      servingSize: serving,
      sodium: sodium100g > 0 ? sodium100g * 1000 : 0, // g -> mg
      potassium: _toDouble(
        nutriments['potassium_100g'] ?? nutriments['potassium'],
      ),
      cholesterol: _toDouble(
        nutriments['cholesterol_100g'] ?? nutriments['cholesterol'],
      ),
      source: 'OpenFoodFacts',
      brand: brand,
      quantity: quantity,
      barcode: scannedBarcode ?? product['code']?.toString(),
    );
  }

  /// Picks the best product title from Open Food Facts (names vary by locale).
  String _openFoodFactsDisplayName(
    Map<String, dynamic> product,
    String fallbackBarcode,
  ) {
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

  /// USDA first (accurate when the key works), then Open Food Facts text search.
  Future<NutritionModel?> _resolveFromSearchPhrase(String phrase) async {
    final usda = await _resolveFromUsdaSearchPhrase(phrase);
    if (usda != null && _hasAnyMacro(usda)) return usda;

    final off = await _resolveFromOpenFoodFactsSearch(phrase);
    if (off != null && _hasAnyMacro(off)) return off;

    return usda ?? off;
  }

  Future<NutritionModel?> _resolveFromUsdaSearchPhrase(String phrase) async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '${NutritionApiConfig.usdaBaseUrl}/foods/search',
        queryParameters: {'api_key': NutritionApiConfig.usdaApiKey},
        data: {
          'query': phrase,
          'pageSize': 5,
          'dataType': ['Foundation', 'SR Legacy', 'Survey (FNDDS)', 'Branded'],
        },
        options: _jsonPostOptions,
      );

      final foods = (response.data?['foods'] as List<dynamic>? ?? const []);
      if (foods.isEmpty) return null;

      NutritionModel? bestEffort;
      var detailFetches = 0;
      const maxDetailFetches = 2;

      for (final raw in foods) {
        final hit = _asJsonMap(raw);
        if (hit == null) continue;
        final id = hit['fdcId'];
        if (id is! num) continue;
        final fdcId = id.toInt();

        Map<String, dynamic> foodMap = hit;
        if (detailFetches < maxDetailFetches) {
          detailFetches++;
          final detail = await _fetchFoodDetail(fdcId);
          if (detail != null) {
            foodMap = detail;
          }
        }

        final model = _mapUsdaFoodToNutrition(foodMap);
        bestEffort ??= model;
        if (_hasAnyMacro(model)) {
          return model;
        }
      }
      return bestEffort;
    } on DioException {
      return null;
    } catch (_) {
      return null;
    }
  }

  /// Free text search on Open Food Facts (no API key; good when USDA is rate-limited).
  Future<NutritionModel?> _resolveFromOpenFoodFactsSearch(String phrase) async {
    try {
      final uri = Uri.parse('https://world.openfoodfacts.org/cgi/search.pl')
          .replace(
            queryParameters: {
              'search_terms': phrase,
              'search_simple': '1',
              'action': 'process',
              'json': '1',
              'page_size': '8',
            },
          );

      final response = await _dio.get<Map<String, dynamic>>(
        uri.toString(),
        options: Options(
          sendTimeout: const Duration(seconds: 20),
          receiveTimeout: const Duration(seconds: 20),
        ),
      );

      final products = response.data?['products'] as List<dynamic>? ?? const [];
      NutritionModel? any;
      for (final raw in products) {
        final p = _asJsonMap(raw);
        if (p == null) continue;
        final model = _nutritionModelFromOpenFoodFactsProduct(p, phrase);
        any ??= model;
        if (_hasAnyMacro(model)) {
          return model;
        }
      }
      return any;
    } catch (_) {
      return null;
    }
  }

  Future<Map<String, dynamic>?> _fetchFoodDetail(int fdcId) async {
    try {
      final response = await _dio.get<Map<String, dynamic>>(
        '${NutritionApiConfig.usdaBaseUrl}/food/$fdcId',
        queryParameters: {'api_key': NutritionApiConfig.usdaApiKey},
        options: Options(
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );
      return response.data;
    } catch (_) {
      return null;
    }
  }

  NutritionModel _mapUsdaFoodToNutrition(Map<String, dynamic> food) {
    final rawNutrients = food['foodNutrients'] as List<dynamic>? ?? const [];
    final byId = _nutrientsById(rawNutrients);

    double firstNonZero(List<int> ids) {
      for (final id in ids) {
        final v = byId[id];
        if (v != null && v > 0) return v;
      }
      return 0;
    }

    double calories = firstNonZero([
      _nEnergyKcal,
      _nEnergyKcalAlt,
      _nEnergyAtwater,
    ]);
    if (calories <= 0) {
      final kj = byId[_nEnergyKj];
      if (kj != null && kj > 0) {
        calories = kj / 4.184;
      }
    }
    if (calories <= 0) {
      calories = _nutrientByName(rawNutrients, const [
        'energy',
        'calorie',
        'kcal',
      ]);
    }

    double protein = firstNonZero([_nProtein]);
    if (protein <= 0) {
      protein = _nutrientByName(rawNutrients, const ['protein']);
    }

    double fat = firstNonZero([_nFat]);
    if (fat <= 0) {
      fat = _nutrientByName(rawNutrients, const [
        'total lipid',
        'fat',
        'lipid',
      ]);
    }

    double carbs = firstNonZero([_nCarbs]);
    if (carbs <= 0) {
      carbs = _nutrientByName(rawNutrients, const [
        'carbohydrate',
        'carb',
        'by difference',
      ]);
    }

    double fiber = firstNonZero([_nFiber]);
    if (fiber <= 0) {
      fiber = _nutrientByName(rawNutrients, const ['fiber', 'dietary fiber']);
    }

    double sugar = firstNonZero([_nSugar]);
    if (sugar <= 0) {
      sugar = _nutrientByName(rawNutrients, const ['sugar', 'sugars']);
    }

    double sodium = firstNonZero([_nSodium]);
    if (sodium <= 0) {
      sodium = _nutrientByName(rawNutrients, const ['sodium']);
    }

    double potassium = firstNonZero([_nPotassium]);
    if (potassium <= 0) {
      potassium = _nutrientByName(rawNutrients, const ['potassium']);
    }

    double cholesterol = firstNonZero([_nCholesterol]);
    if (cholesterol <= 0) {
      cholesterol = _nutrientByName(rawNutrients, const ['cholesterol']);
    }

    final servingG = _toDouble(food['servingSize'] ?? 100);
    final desc = (food['description'] ?? food['lowercaseDescription'] ?? '')
        .toString();

    return NutritionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      foodName: desc.isEmpty ? 'Food item' : desc,
      calories: calories,
      protein: protein,
      fat: fat,
      carbs: carbs,
      fiber: fiber,
      sugar: sugar,
      servingSize: '${servingG > 0 ? servingG : 100} g',
      sodium: sodium,
      potassium: potassium,
      cholesterol: cholesterol,
      source: 'USDA',
    );
  }

  Map<int, double> _nutrientsById(List<dynamic> rawNutrients) {
    final map = <int, double>{};
    for (final item in rawNutrients) {
      if (item is! Map) continue;
      final row = Map<String, dynamic>.from(item);
      final id = _readNutrientId(row);
      if (id == null) continue;
      final amount = _readNutrientAmount(row);
      if (amount != null) {
        map[id] = amount;
      }
    }
    return map;
  }

  int? _readNutrientId(Map<String, dynamic> item) {
    final nested = item['nutrient'];
    if (nested is Map) {
      final nm = Map<String, dynamic>.from(nested);
      final id = nm['id'];
      if (id is num) return id.toInt();
      final numStr = nm['number'];
      if (numStr != null) return int.tryParse(numStr.toString());
    }
    final legacy = item['nutrientId'];
    if (legacy is num) return legacy.toInt();
    return null;
  }

  double? _readNutrientAmount(Map<String, dynamic> item) {
    final a = item['amount'] ?? item['value'];
    final d = _toDouble(a);
    return d == 0 && a == null ? null : d;
  }

  double _nutrientByName(List<dynamic> rawNutrients, List<String> needles) {
    for (final raw in rawNutrients) {
      if (raw is! Map) continue;
      final row = Map<String, dynamic>.from(raw);
      String name = '';
      final nested = row['nutrient'];
      if (nested is Map) {
        final nm = Map<String, dynamic>.from(nested);
        name = (nm['name'] ?? '').toString().toLowerCase();
      }
      name = name.isEmpty
          ? (row['nutrientName'] ?? '').toString().toLowerCase()
          : name;
      if (name.isEmpty) continue;
      if (needles.any((n) => name.contains(n.toLowerCase()))) {
        return _toDouble(row['amount'] ?? row['value']);
      }
    }
    return 0;
  }

  String _normalizeMealText(String input) {
    var s = input.replaceAll(RegExp(r'\s+'), ' ');
    s = s.replaceAllMapped(RegExp(r'\s*([,;+|&])\s*'), (m) => '${m[1]} ');
    return s.trim();
  }

  List<String> _splitMealText(String input) {
    final lower = input.toLowerCase().trim();
    if (lower.isEmpty) return const [];

    return lower
        .split(
          RegExp(
            r'\s*,\s*|\s*;\s*|\s*\|\s*|\s*\+\s*|\s*&\s*|\s+و\s+|\s+and\s+|\s+with\s+',
            caseSensitive: false,
          ),
        )
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  /// Strips leading quantities so "2 large eggs" searches closer to "eggs".
  String _cleanFoodPhrase(String raw) {
    var s = raw.trim();
    if (s.isEmpty) return '';

    // Remove leading counts: 2, 1.5, 1/2, two… (compact pattern — no free spaces)
    s = s.replaceFirst(
      RegExp(
        r'^(\d+(\.\d+)?|\d+\s*/\s*\d+|one|two|three|four|five|six|seven|eight|nine|ten|a|an|the)\s+',
        caseSensitive: false,
      ),
      '',
    );

    // "2 cups of rice" / "1 slice of bread"
    s = s.replaceFirst(
      RegExp(
        r'^(\d+(\.\d+)?\s*)?(cups?|c\.|tbsp\.?|tsp\.?|oz\.?|lb\.?|lbs|kg|ml|liters?|litres?|slices?|pieces?|sticks?|scoops?)\s+of\s+',
        caseSensitive: false,
      ),
      '',
    );

    // "2 cups rice" / "1 large apple" (avoid bare `\bg\b` — would match "green")
    s = s.replaceFirst(
      RegExp(
        r'^(\d+(\.\d+)?\s*)?(cups?|tbsp\.?|tsp\.?|oz\.?|lb\.?|lbs|kg|ml|liters?|litres?|slices?|pieces?|grams?|small|medium|large|whole)\s+',
        caseSensitive: false,
      ),
      '',
    );

    s = s.trim();
    return s.isEmpty ? raw.trim() : s;
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}
