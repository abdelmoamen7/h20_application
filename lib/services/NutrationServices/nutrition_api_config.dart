class NutritionApiConfig {
  static const String usdaBaseUrl = 'https://api.nal.usda.gov/fdc/v1';
  static const String openFoodFactsBaseUrl =
      'https://world.openfoodfacts.org/api/v2';

  // Use: flutter run --dart-define=USDA_API_KEY=your_key
  static const String usdaApiKey = String.fromEnvironment(
    'USDA_API_KEY',
    defaultValue: 'DEMO_KEY',
  );
}
