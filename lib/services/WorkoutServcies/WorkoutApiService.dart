import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../../models/FreeExerciseModel.dart';

class WorkoutApiService {
  static const String _baseUrl =
      'https://raw.githubusercontent.com/hasaneyldrm/exercises-dataset/main/data/exercises.json';
  static List<FreeExerciseModel>? _cachedExercises;
  static Future<List<FreeExerciseModel>>? _inFlightRequest;

  Future<List<FreeExerciseModel>> fetchExercises({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cachedExercises != null) {
      return _cachedExercises!;
    }

    if (!forceRefresh && _inFlightRequest != null) {
      return _inFlightRequest!;
    }

    _inFlightRequest = _fetchAndParseExercises();
    try {
      final exercises = await _inFlightRequest!;
      _cachedExercises = exercises;
      return exercises;
    } finally {
      _inFlightRequest = null;
    }
  }

  Future<List<FreeExerciseModel>> _fetchAndParseExercises() async {
    try {
      final response = await http
          .get(Uri.parse(_baseUrl))
          .timeout(const Duration(seconds: 25));

      if (response.statusCode != 200) {
        throw Exception('Failed to load exercises');
      }

      // Parsing a large JSON on the UI isolate makes the Workout tab feel slow.
      // Decode in a background isolate to keep scrolling / transitions smooth.
      final exercises = await compute(_decodeExercisesJson, response.body);

      exercises.shuffle();
      return exercises.take(50).toList();
    } catch (e) {
      throw Exception('Error fetching exercises: $e');
    }
  }
}

List<FreeExerciseModel> _decodeExercisesJson(String body) {
  final List<dynamic> data = json.decode(body) as List<dynamic>;
  return data
      .map((e) => FreeExerciseModel.fromJson(e as Map<String, dynamic>))
      .toList();
}
