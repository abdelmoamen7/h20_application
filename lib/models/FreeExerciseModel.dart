class FreeExerciseModel {
  final String id;
  final String name;
  final String bodyPart;
  final String equipment;
  final String target;
  final List<String> instructions;
  final String category;
  final String gifUrl;

  FreeExerciseModel({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.equipment,
    required this.target,
    required this.instructions,
    required this.category,
    required this.gifUrl,
  });

  factory FreeExerciseModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedInstructions = [];
    if (json['instruction_steps'] != null && json['instruction_steps']['en'] != null) {
      parsedInstructions = List<String>.from(json['instruction_steps']['en']);
    } else if (json['instructions'] != null && json['instructions']['en'] != null) {
      parsedInstructions = [json['instructions']['en']];
    }

    return FreeExerciseModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      bodyPart: json['body_part'] ?? '',
      equipment: json['equipment'] ?? '',
      target: json['target'] ?? '',
      instructions: parsedInstructions,
      category: json['category'] ?? '',
      gifUrl: json['gif_url'] ?? '',
    );
  }
}
