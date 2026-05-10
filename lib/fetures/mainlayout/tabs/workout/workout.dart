import 'package:flutter/material.dart';
import '../../../../services/WorkoutServcies/WorkoutApiService.dart';
import '../../../../core/widget/FreeExerciseCard.dart';
import '../../../../models/FreeExerciseModel.dart';

class workout extends StatefulWidget {
  const workout({super.key});

  @override
  State<workout> createState() => _workoutState();
}

class _workoutState extends State<workout> {
  late Future<List<FreeExerciseModel>> _exercisesFuture;
  final WorkoutApiService _apiService = WorkoutApiService();

  @override
  void initState() {
    super.initState();
    _exercisesFuture = _apiService.fetchExercises();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Workouts', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<FreeExerciseModel>>(
        future: _exercisesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 50),
                  const SizedBox(height: 16),
                  Text('Error loading workouts:\n${snapshot.error}', textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _exercisesFuture = _apiService.fetchExercises();
                      });
                    },
                    child: const Text('Retry'),
                  )
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No workouts found.'));
          }

          final exercises = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _exercisesFuture = _apiService.fetchExercises();
              });
            },
            child: ListView.builder(
              padding: const EdgeInsets.only(bottom: 20),
              itemCount: exercises.length,
              itemBuilder: (context, index) {
                return FreeExerciseCard(exercise: exercises[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
