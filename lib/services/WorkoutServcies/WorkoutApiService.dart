import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/FreeExerciseModel.dart';

class WorkoutApiService {
  static const String _baseUrl = 'https://raw.githubusercontent.com/hasaneyldrm/exercises-dataset/main/data/exercises.json';

  Future<List<FreeExerciseModel>> fetchExercises() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        // Map the json data to a list of models
        List<FreeExerciseModel> exercises = data.map((json) => FreeExerciseModel.fromJson(json)).toList();
        
        // Optional: shuffle or return a subset so it doesn't always show the exact same in A-Z order
        exercises.shuffle();
        return exercises.take(50).toList(); // Return only 50 to avoid massive lists
      } else {
        throw Exception('Failed to load exercises');
      }
    } catch (e) {
      throw Exception('Error fetching exercises: $e');
    }
  }
}
