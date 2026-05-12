import '../../models/nutrition_model.dart';
import 'nutrition_remote_datasource.dart';

class NutritionRepository {
  NutritionRepository({NutritionRemoteDataSource? remoteDataSource})
    : _remote = remoteDataSource ?? NutritionRemoteDataSource();

  final NutritionRemoteDataSource _remote;

  final Map<String, NutritionModel> _textNutritionCache = {};
  final Map<String, List<FoodSuggestion>> _searchCache = {};
  final Map<String, NutritionModel> _barcodeCache = {};

  Future<NutritionModel?> analyzeMealText(String query) async {
    final key = query.trim().toLowerCase();
    if (key.isEmpty) return null;

    if (_textNutritionCache.containsKey(key)) {
      return _textNutritionCache[key];
    }

    final result = await _remote.analyzeFoodText(query);
    if (result != null) {
      _textNutritionCache[key] = result;
    }
    return result;
  }

  Future<List<FoodSuggestion>> searchAutocomplete(String query) async {
    final key = query.trim().toLowerCase();
    if (key.isEmpty) return const [];

    if (_searchCache.containsKey(key)) {
      return _searchCache[key]!;
    }

    final result = await _remote.searchFoods(query);
    _searchCache[key] = result;
    return result;
  }

  Future<NutritionModel?> analyzeBarcode(String barcode) async {
    final key = barcode.trim();
    if (key.isEmpty) return null;

    if (_barcodeCache.containsKey(key)) {
      return _barcodeCache[key];
    }

    final result = await _remote.analyzeBarcode(barcode);
    if (result != null) {
      _barcodeCache[key] = result;
    }
    return result;
  }
}
