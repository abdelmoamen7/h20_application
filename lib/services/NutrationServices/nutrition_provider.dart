import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../models/nutrition_model.dart';
import 'nutrition_remote_datasource.dart';
import 'nutrition_repository.dart';

class NutritionProvider extends ChangeNotifier {
  NutritionProvider({NutritionRepository? repository})
    : _repository = repository ?? NutritionRepository();

  final NutritionRepository _repository;

  bool _isLoading = false;
  String? _errorMessage;
  NutritionModel? _nutrition;
  List<FoodSuggestion> _suggestions = const [];

  Timer? _debounce;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  NutritionModel? get nutrition => _nutrition;
  List<FoodSuggestion> get suggestions => _suggestions;

  Future<void> analyzeFoodText(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) {
      _errorMessage = 'Please enter food text first.';
      notifyListeners();
      return;
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      final result = await _repository.analyzeMealText(trimmed);
      if (result == null) {
        _nutrition = null;
        _errorMessage = 'No nutrition result found for this food.';
      } else {
        _nutrition = result;
      }
    } catch (e) {
      _nutrition = null;
      _errorMessage = 'Failed to load nutrition. Please try again.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> analyzeBarcode(String barcode) async {
    final trimmed = barcode.trim();
    if (trimmed.isEmpty) {
      _errorMessage = 'Barcode value is empty.';
      notifyListeners();
      return;
    }

    _setLoading(true);
    _errorMessage = null;

    try {
      final result = await _repository.analyzeBarcode(trimmed);
      if (result == null) {
        _nutrition = null;
        _errorMessage = 'No product found for this barcode.';
      } else {
        _nutrition = result;
      }
    } catch (_) {
      _nutrition = null;
      _errorMessage = 'Failed to lookup barcode.';
    } finally {
      _setLoading(false);
    }
  }

  void onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () async {
      final trimmed = query.trim();
      if (trimmed.isEmpty) {
        _suggestions = const [];
        notifyListeners();
        return;
      }

      try {
        _suggestions = await _repository.searchAutocomplete(trimmed);
      } catch (_) {
        _suggestions = const [];
      }
      notifyListeners();
    });
  }

  void setNutritionFromSuggestion(String foodName) {
    _errorMessage = null;
    _nutrition = null;
    _suggestions = const [];
    notifyListeners();
  }

  void clearState() {
    _errorMessage = null;
    _nutrition = null;
    _suggestions = const [];
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}
