class FreeExerciseModel {
  /// CDN root for `gif_url` / `image` paths from the exercises dataset.
  static const String kMediaCdnBase =
      'https://raw.githubusercontent.com/hasaneyldrm/exercises-dataset/main/';

  final String id;
  final String name;
  final String bodyPart;
  final String equipment;
  final String target;
  final List<String> instructions;
  final String category;
  final String gifUrl;

  /// Still image path (jpg) when GIF is missing or fails.
  final String imageUrl;

  FreeExerciseModel({
    required this.id,
    required this.name,
    required this.bodyPart,
    required this.equipment,
    required this.target,
    required this.instructions,
    required this.category,
    required this.gifUrl,
    required this.imageUrl,
  });

  /// Absolute URL for the animated GIF (empty if none).
  String get gifAbsoluteUrl => _absoluteMediaUrl(gifUrl);

  /// Absolute URL for the still preview image.
  String get stillImageAbsoluteUrl => _absoluteMediaUrl(imageUrl);

  /// Prefer GIF for motion; otherwise still image.
  String get previewMediaUrl {
    final g = gifAbsoluteUrl;
    if (g.isNotEmpty) return g;
    return stillImageAbsoluteUrl;
  }

  static String _absoluteMediaUrl(String relativeOrAbsolute) {
    final raw = relativeOrAbsolute.trim();
    if (raw.isEmpty) return '';
    if (raw.startsWith('http://') || raw.startsWith('https://')) {
      return raw;
    }
    final path = raw.startsWith('/') ? raw.substring(1) : raw;
    return '$kMediaCdnBase$path';
  }

  factory FreeExerciseModel.fromJson(Map<String, dynamic> json) {
    List<String> parsedInstructions = [];
    if (json['instruction_steps'] != null &&
        json['instruction_steps']['en'] != null) {
      parsedInstructions = List<String>.from(json['instruction_steps']['en']);
    } else if (json['instructions'] != null &&
        json['instructions']['en'] != null) {
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
      imageUrl: json['image'] ?? '',
    );
  }
}
