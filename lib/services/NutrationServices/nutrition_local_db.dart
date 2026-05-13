import '../../models/nutrition_model.dart';

/// Per-100g nutrition values for common foods.
/// Fields: [calories, protein, fat, carbs, fiber, sugar, sodium, potassium, cholesterol]
class _FoodEntry {
  final double cal, pro, fat, carb, fib, sug, sod, pot, cho;
  /// Default serving size in grams (used when no quantity is specified)
  final double defaultServing;

  const _FoodEntry({
    required this.cal,
    required this.pro,
    required this.fat,
    required this.carb,
    this.fib = 0,
    this.sug = 0,
    this.sod = 0,
    this.pot = 0,
    this.cho = 0,
    this.defaultServing = 100,
  });

  _FoodEntry scale(double grams) {
    final f = grams / 100.0;
    return _FoodEntry(
      cal: cal * f,
      pro: pro * f,
      fat: fat * f,
      carb: carb * f,
      fib: fib * f,
      sug: sug * f,
      sod: sod * f,
      pot: pot * f,
      cho: cho * f,
      defaultServing: grams,
    );
  }
}

class NutritionLocalDb {
  NutritionLocalDb._();

  /// All values are per 100 g (USDA / standard references).
  static const Map<String, _FoodEntry> entries = {
    // ── Proteins ──────────────────────────────────────────────────────────────
    'chicken breast': _FoodEntry(cal: 165, pro: 31, fat: 3.6, carb: 0, sod: 74, pot: 256, cho: 85, defaultServing: 100),
    'chicken': _FoodEntry(cal: 165, pro: 31, fat: 3.6, carb: 0, sod: 74, pot: 256, cho: 85, defaultServing: 100),
    'grilled chicken': _FoodEntry(cal: 165, pro: 31, fat: 3.6, carb: 0, sod: 74, pot: 256, cho: 85, defaultServing: 100),
    'beef': _FoodEntry(cal: 250, pro: 26, fat: 15, carb: 0, sod: 72, pot: 318, cho: 90, defaultServing: 100),
    'ground beef': _FoodEntry(cal: 254, pro: 26, fat: 17, carb: 0, sod: 75, pot: 270, cho: 88, defaultServing: 100),
    'meat': _FoodEntry(cal: 250, pro: 26, fat: 15, carb: 0, sod: 72, pot: 318, cho: 90, defaultServing: 100),
    'lamb': _FoodEntry(cal: 294, pro: 25, fat: 21, carb: 0, sod: 72, pot: 310, cho: 97, defaultServing: 100),
    'fish': _FoodEntry(cal: 136, pro: 20, fat: 6, carb: 0, sod: 63, pot: 384, cho: 63, defaultServing: 100),
    'salmon': _FoodEntry(cal: 208, pro: 20, fat: 13, carb: 0, sod: 59, pot: 363, cho: 63, defaultServing: 100),
    'tuna': _FoodEntry(cal: 132, pro: 29, fat: 1, carb: 0, sod: 50, pot: 444, cho: 49, defaultServing: 100),
    'shrimp': _FoodEntry(cal: 99, pro: 24, fat: 0.3, carb: 0.2, sod: 111, pot: 259, cho: 189, defaultServing: 100),
    'turkey': _FoodEntry(cal: 189, pro: 29, fat: 7, carb: 0, sod: 70, pot: 298, cho: 76, defaultServing: 100),
    'pork': _FoodEntry(cal: 242, pro: 27, fat: 14, carb: 0, sod: 62, pot: 423, cho: 80, defaultServing: 100),
    'egg': _FoodEntry(cal: 155, pro: 13, fat: 11, carb: 1.1, sod: 124, pot: 126, cho: 373, defaultServing: 50),
    'eggs': _FoodEntry(cal: 155, pro: 13, fat: 11, carb: 1.1, sod: 124, pot: 126, cho: 373, defaultServing: 50),
    'boiled egg': _FoodEntry(cal: 155, pro: 13, fat: 11, carb: 1.1, sod: 124, pot: 126, cho: 373, defaultServing: 50),
    'fried egg': _FoodEntry(cal: 196, pro: 14, fat: 15, carb: 0.4, sod: 207, pot: 138, cho: 401, defaultServing: 50),
    'egg white': _FoodEntry(cal: 52, pro: 11, fat: 0.2, carb: 0.7, sod: 166, pot: 163, cho: 0, defaultServing: 33),
    'cottage cheese': _FoodEntry(cal: 98, pro: 11, fat: 4.3, carb: 3.4, sod: 364, pot: 104, cho: 17, defaultServing: 100),
    'greek yogurt': _FoodEntry(cal: 59, pro: 10, fat: 0.4, carb: 3.6, sug: 3.2, sod: 36, pot: 141, cho: 5, defaultServing: 150),
    'yogurt': _FoodEntry(cal: 61, pro: 3.5, fat: 3.3, carb: 4.7, sug: 4.7, sod: 46, pot: 155, cho: 13, defaultServing: 150),

    // ── Dairy ─────────────────────────────────────────────────────────────────
    'milk': _FoodEntry(cal: 61, pro: 3.2, fat: 3.3, carb: 4.8, sug: 5.1, sod: 43, pot: 150, cho: 10, defaultServing: 240),
    'whole milk': _FoodEntry(cal: 61, pro: 3.2, fat: 3.3, carb: 4.8, sug: 5.1, sod: 43, pot: 150, cho: 10, defaultServing: 240),
    'cheese': _FoodEntry(cal: 402, pro: 25, fat: 33, carb: 1.3, sod: 621, pot: 98, cho: 105, defaultServing: 30),
    'cheddar cheese': _FoodEntry(cal: 403, pro: 25, fat: 33, carb: 1.3, sod: 621, pot: 98, cho: 105, defaultServing: 30),
    'butter': _FoodEntry(cal: 717, pro: 0.9, fat: 81, carb: 0.1, sod: 11, pot: 24, cho: 215, defaultServing: 14),

    // ── Grains & Carbs ────────────────────────────────────────────────────────
    'rice': _FoodEntry(cal: 130, pro: 2.7, fat: 0.3, carb: 28, fib: 0.4, sug: 0, sod: 1, pot: 35, defaultServing: 100),
    'white rice': _FoodEntry(cal: 130, pro: 2.7, fat: 0.3, carb: 28, fib: 0.4, sod: 1, pot: 35, defaultServing: 100),
    'brown rice': _FoodEntry(cal: 123, pro: 2.7, fat: 1, carb: 26, fib: 1.8, sod: 4, pot: 79, defaultServing: 100),
    'bread': _FoodEntry(cal: 265, pro: 9, fat: 3.2, carb: 49, fib: 2.7, sug: 5, sod: 491, pot: 115, defaultServing: 30),
    'white bread': _FoodEntry(cal: 265, pro: 9, fat: 3.2, carb: 49, fib: 2.7, sug: 5, sod: 491, pot: 115, defaultServing: 30),
    'pasta': _FoodEntry(cal: 131, pro: 5, fat: 1.1, carb: 25, fib: 1.8, sod: 1, pot: 44, defaultServing: 100),
    'oats': _FoodEntry(cal: 389, pro: 17, fat: 7, carb: 66, fib: 11, sug: 1, sod: 2, pot: 429, defaultServing: 40),
    'oatmeal': _FoodEntry(cal: 68, pro: 2.4, fat: 1.4, carb: 12, fib: 1.7, sod: 49, pot: 61, defaultServing: 100),
    'potato': _FoodEntry(cal: 77, pro: 2, fat: 0.1, carb: 17, fib: 2.2, sug: 0.8, sod: 6, pot: 421, defaultServing: 150),
    'sweet potato': _FoodEntry(cal: 86, pro: 1.6, fat: 0.1, carb: 20, fib: 3, sug: 4.2, sod: 55, pot: 337, defaultServing: 150),
    'corn': _FoodEntry(cal: 86, pro: 3.3, fat: 1.4, carb: 19, fib: 2.7, sug: 3.2, sod: 15, pot: 270, defaultServing: 100),
    'tortilla': _FoodEntry(cal: 218, pro: 5.7, fat: 5.3, carb: 37, fib: 2.5, sod: 400, pot: 107, defaultServing: 45),

    // ── Vegetables ────────────────────────────────────────────────────────────
    'broccoli': _FoodEntry(cal: 34, pro: 2.8, fat: 0.4, carb: 7, fib: 2.6, sug: 1.7, sod: 33, pot: 316, defaultServing: 100),
    'spinach': _FoodEntry(cal: 23, pro: 2.9, fat: 0.4, carb: 3.6, fib: 2.2, sug: 0.4, sod: 79, pot: 558, defaultServing: 100),
    'tomato': _FoodEntry(cal: 18, pro: 0.9, fat: 0.2, carb: 3.9, fib: 1.2, sug: 2.6, sod: 5, pot: 237, defaultServing: 100),
    'cucumber': _FoodEntry(cal: 15, pro: 0.7, fat: 0.1, carb: 3.6, fib: 0.5, sug: 1.7, sod: 2, pot: 147, defaultServing: 100),
    'carrot': _FoodEntry(cal: 41, pro: 0.9, fat: 0.2, carb: 10, fib: 2.8, sug: 4.7, sod: 69, pot: 320, defaultServing: 100),
    'onion': _FoodEntry(cal: 40, pro: 1.1, fat: 0.1, carb: 9.3, fib: 1.7, sug: 4.2, sod: 4, pot: 146, defaultServing: 100),
    'garlic': _FoodEntry(cal: 149, pro: 6.4, fat: 0.5, carb: 33, fib: 2.1, sug: 1, sod: 17, pot: 401, defaultServing: 5),
    'lettuce': _FoodEntry(cal: 15, pro: 1.4, fat: 0.2, carb: 2.9, fib: 1.3, sug: 1.2, sod: 28, pot: 194, defaultServing: 100),
    'pepper': _FoodEntry(cal: 31, pro: 1, fat: 0.3, carb: 6, fib: 2.1, sug: 4.2, sod: 4, pot: 211, defaultServing: 100),
    'mushroom': _FoodEntry(cal: 22, pro: 3.1, fat: 0.3, carb: 3.3, fib: 1, sug: 2, sod: 5, pot: 318, defaultServing: 100),

    // ── Fruits ────────────────────────────────────────────────────────────────
    'banana': _FoodEntry(cal: 89, pro: 1.1, fat: 0.3, carb: 23, fib: 2.6, sug: 12, sod: 1, pot: 358, defaultServing: 120),
    'apple': _FoodEntry(cal: 52, pro: 0.3, fat: 0.2, carb: 14, fib: 2.4, sug: 10, sod: 1, pot: 107, defaultServing: 182),
    'orange': _FoodEntry(cal: 47, pro: 0.9, fat: 0.1, carb: 12, fib: 2.4, sug: 9.4, sod: 0, pot: 181, defaultServing: 131),
    'mango': _FoodEntry(cal: 60, pro: 0.8, fat: 0.4, carb: 15, fib: 1.6, sug: 14, sod: 1, pot: 168, defaultServing: 165),
    'strawberry': _FoodEntry(cal: 32, pro: 0.7, fat: 0.3, carb: 7.7, fib: 2, sug: 4.9, sod: 1, pot: 153, defaultServing: 100),
    'grapes': _FoodEntry(cal: 69, pro: 0.7, fat: 0.2, carb: 18, fib: 0.9, sug: 15, sod: 2, pot: 191, defaultServing: 100),
    'watermelon': _FoodEntry(cal: 30, pro: 0.6, fat: 0.2, carb: 7.6, fib: 0.4, sug: 6.2, sod: 1, pot: 112, defaultServing: 280),
    'avocado': _FoodEntry(cal: 160, pro: 2, fat: 15, carb: 9, fib: 7, sug: 0.7, sod: 7, pot: 485, defaultServing: 150),
    'dates': _FoodEntry(cal: 277, pro: 1.8, fat: 0.2, carb: 75, fib: 6.7, sug: 63, sod: 1, pot: 696, defaultServing: 24),

    // ── Legumes & Nuts ────────────────────────────────────────────────────────
    'lentils': _FoodEntry(cal: 116, pro: 9, fat: 0.4, carb: 20, fib: 7.9, sug: 1.8, sod: 2, pot: 369, defaultServing: 100),
    'chickpeas': _FoodEntry(cal: 164, pro: 8.9, fat: 2.6, carb: 27, fib: 7.6, sug: 4.8, sod: 7, pot: 291, defaultServing: 100),
    'black beans': _FoodEntry(cal: 132, pro: 8.9, fat: 0.5, carb: 24, fib: 8.7, sug: 0.3, sod: 1, pot: 355, defaultServing: 100),
    'almonds': _FoodEntry(cal: 579, pro: 21, fat: 50, carb: 22, fib: 12.5, sug: 4.4, sod: 1, pot: 733, cho: 0, defaultServing: 28),
    'peanuts': _FoodEntry(cal: 567, pro: 26, fat: 49, carb: 16, fib: 8.5, sug: 4, sod: 18, pot: 705, defaultServing: 28),
    'peanut butter': _FoodEntry(cal: 588, pro: 25, fat: 50, carb: 20, fib: 6, sug: 9, sod: 459, pot: 558, defaultServing: 32),
    'walnuts': _FoodEntry(cal: 654, pro: 15, fat: 65, carb: 14, fib: 6.7, sug: 2.6, sod: 2, pot: 441, defaultServing: 28),

    // ── Oils & Fats ───────────────────────────────────────────────────────────
    'olive oil': _FoodEntry(cal: 884, pro: 0, fat: 100, carb: 0, sod: 2, pot: 1, cho: 0, defaultServing: 14),
    'oil': _FoodEntry(cal: 884, pro: 0, fat: 100, carb: 0, defaultServing: 14),

    // ── Beverages ─────────────────────────────────────────────────────────────
    'orange juice': _FoodEntry(cal: 45, pro: 0.7, fat: 0.2, carb: 10, sug: 8.4, sod: 1, pot: 200, defaultServing: 240),
    'coffee': _FoodEntry(cal: 2, pro: 0.3, fat: 0, carb: 0, sod: 5, pot: 49, defaultServing: 240),
    'tea': _FoodEntry(cal: 1, pro: 0, fat: 0, carb: 0.2, sod: 7, pot: 37, defaultServing: 240),

    // ── Prepared / Fast food ──────────────────────────────────────────────────
    'pizza': _FoodEntry(cal: 266, pro: 11, fat: 10, carb: 33, fib: 2.3, sug: 3.6, sod: 598, pot: 172, cho: 17, defaultServing: 100),
    'burger': _FoodEntry(cal: 295, pro: 17, fat: 14, carb: 24, fib: 1.3, sug: 5, sod: 396, pot: 227, cho: 44, defaultServing: 150),
    'sandwich': _FoodEntry(cal: 250, pro: 12, fat: 9, carb: 30, fib: 2, sug: 4, sod: 500, pot: 200, cho: 30, defaultServing: 150),
    'salad': _FoodEntry(cal: 20, pro: 1.5, fat: 0.3, carb: 3.5, fib: 1.5, sug: 1.5, sod: 15, pot: 200, defaultServing: 100),
    'soup': _FoodEntry(cal: 50, pro: 3, fat: 1.5, carb: 7, fib: 1, sug: 2, sod: 400, pot: 150, defaultServing: 240),
  };

  /// Parses a natural language meal description and returns aggregated nutrition.
  /// Examples:
  ///   "100g chicken, two eggs"
  ///   "200g beef, 2 eggs and 2 bananas"
  ///   "chicken breast and rice"
  static NutritionModel? analyze(String query) {
    final lower = query.toLowerCase().trim();
    if (lower.isEmpty) return null;

    // Split on common separators: comma, "and", "with", "+", Arabic "و"
    final parts = lower
        .split(RegExp(r',|\band\b|\bwith\b|\+|،|\bو\b', caseSensitive: false))
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final resolved = <({String name, _FoodEntry entry, double grams})>[];

    for (final part in parts) {
      final parsed = _parsePart(part);
      if (parsed != null) resolved.add(parsed);
    }

    if (resolved.isEmpty) return null;

    // Aggregate totals
    double cal = 0, pro = 0, fat = 0, carb = 0;
    double fib = 0, sug = 0, sod = 0, pot = 0, cho = 0;
    final names = <String>[];

    for (final r in resolved) {
      final s = r.entry.scale(r.grams);
      cal += s.cal;
      pro += s.pro;
      fat += s.fat;
      carb += s.carb;
      fib += s.fib;
      sug += s.sug;
      sod += s.sod;
      pot += s.pot;
      cho += s.cho;
      names.add(r.name);
    }

    return NutritionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      foodName: names.join(', '),
      calories: _round(cal),
      protein: _round(pro),
      fat: _round(fat),
      carbs: _round(carb),
      fiber: _round(fib),
      sugar: _round(sug),
      sodium: _round(sod),
      potassium: _round(pot),
      cholesterol: _round(cho),
      servingSize: 'As entered',
      source: 'Built-in DB',
    );
  }

  /// Parses a single food part like "100g chicken", "two eggs", "banana"
  static ({String name, _FoodEntry entry, double grams})? _parsePart(
      String part) {
    final s = part.trim().toLowerCase();
    if (s.isEmpty) return null;

    // Try to extract a leading quantity + unit
    double? qty;
    String remainder = s;

    // Pattern: "100g", "100 g", "200 grams", "1.5 kg", "2 cups"
    final qtyUnitMatch = RegExp(
      r'^(\d+(?:\.\d+)?)\s*(g|grams?|kg|kilograms?|ml|l|liters?|cups?|tbsp|tsp|oz|lb|lbs|pieces?|slices?|scoops?)\s+',
      caseSensitive: false,
    ).firstMatch(s);

    if (qtyUnitMatch != null) {
      final num = double.tryParse(qtyUnitMatch.group(1)!) ?? 1;
      final unit = qtyUnitMatch.group(2)!.toLowerCase();
      qty = _convertToGrams(num, unit);
      remainder = s.substring(qtyUnitMatch.end).trim();
    } else {
      // Pattern: word number "two eggs", "3 bananas", "a banana"
      final wordNumMatch = RegExp(
        r'^(one|two|three|four|five|six|seven|eight|nine|ten|a|an|\d+(?:\.\d+)?)\s+',
        caseSensitive: false,
      ).firstMatch(s);

      if (wordNumMatch != null) {
        final token = wordNumMatch.group(1)!.toLowerCase();
        final count = _wordToNumber(token);
        remainder = s.substring(wordNumMatch.end).trim();
        // qty will be count × defaultServing — resolved after food lookup
        qty = count; // store count, multiply by defaultServing below
      }
    }

    // Find best matching food entry
    final entry = _findBestMatch(remainder.isEmpty ? s : remainder);
    if (entry == null) return null;

    double grams;
    if (qtyUnitMatch != null) {
      // qty is already in grams
      grams = qty!;
    } else if (qty != null) {
      // qty is a count — multiply by default serving
      grams = qty * entry.defaultServing;
    } else {
      // No quantity — use default serving
      grams = entry.defaultServing;
    }

    final displayName = remainder.isEmpty ? s : remainder;
    return (name: displayName, entry: entry, grams: grams);
  }

  static _FoodEntry? _findBestMatch(String phrase) {
    // Exact match first
    if (entries.containsKey(phrase)) return entries[phrase];

    // Longest key that is contained in the phrase
    _FoodEntry? best;
    int bestLen = 0;
    for (final key in entries.keys) {
      if (phrase.contains(key) && key.length > bestLen) {
        best = entries[key];
        bestLen = key.length;
      }
    }
    if (best != null) return best;

    // Phrase contains any word from a key
    final words = phrase.split(RegExp(r'\s+'));
    for (final word in words) {
      if (word.length < 3) continue;
      for (final key in entries.keys) {
        if (key.contains(word)) return entries[key];
      }
    }

    return null;
  }

  static double _convertToGrams(double value, String unit) {
    switch (unit) {
      case 'kg':
      case 'kilogram':
      case 'kilograms':
        return value * 1000;
      case 'lb':
      case 'lbs':
        return value * 453.6;
      case 'oz':
        return value * 28.35;
      case 'cup':
      case 'cups':
        return value * 240;
      case 'tbsp':
        return value * 15;
      case 'tsp':
        return value * 5;
      case 'ml':
        return value; // approximate 1ml ≈ 1g
      case 'l':
      case 'liter':
      case 'liters':
        return value * 1000;
      default:
        return value; // g, grams, pieces, slices, scoops → treat as grams
    }
  }

  static double _wordToNumber(String word) {
    switch (word) {
      case 'one':
      case 'a':
      case 'an':
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
      default:
        return double.tryParse(word) ?? 1;
    }
  }

  static double _round(double v) => double.parse(v.toStringAsFixed(1));
}
