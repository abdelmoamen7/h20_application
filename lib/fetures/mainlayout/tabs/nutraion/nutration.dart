import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../../../models/nutrition_model.dart';
import '../../../../services/NutrationServices/nutrition_provider.dart';

class NutritionScreen extends StatelessWidget {
  const NutritionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NutritionProvider(),
      child: const _NutritionView(),
    );
  }
}

class _NutritionView extends StatefulWidget {
  const _NutritionView();

  @override
  State<_NutritionView> createState() => _NutritionViewState();
}

class _NutritionViewState extends State<_NutritionView> {
  final TextEditingController _foodController = TextEditingController();

  @override
  void dispose() {
    _foodController.dispose();
    super.dispose();
  }

  Future<void> _submitFoodText() async {
    FocusScope.of(context).unfocus();
    await context.read<NutritionProvider>().analyzeFoodText(
      _foodController.text,
    );
  }

  Future<void> _openBarcodeScanner() async {
    final provider = context.read<NutritionProvider>();
    final scannedBarcode = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (_) => const _BarcodeScannerPage()),
    );

    if (scannedBarcode == null || scannedBarcode.isEmpty) {
      return;
    }

    await provider.analyzeBarcode(scannedBarcode);

    if (!mounted) return;
    final n = provider.nutrition;
    if (n != null && n.foodName.trim().isNotEmpty) {
      _foodController.text = n.foodName;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NutritionProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          appBar: AppBar(centerTitle: true, title: const Text('Nutrition')),
          body: SafeArea(
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _foodController,
                      onChanged: provider.onQueryChanged,
                      textInputAction: TextInputAction.search,
                      onFieldSubmitted: (_) => _submitFoodText(),
                      decoration: InputDecoration(
                        hintText: 'Example: 2 eggs and 1 banana',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _foodController.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  _foodController.clear();
                                  provider.clearState();
                                  setState(() {});
                                },
                                icon: const Icon(Icons.clear),
                              ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (provider.suggestions.isNotEmpty)
                      Container(
                        constraints: const BoxConstraints(maxHeight: 180),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black12),
                        ),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: provider.suggestions.length,
                          itemBuilder: (context, index) {
                            final suggestion = provider.suggestions[index];
                            return ListTile(
                              dense: true,
                              title: Text(suggestion.description),
                              onTap: () {
                                _foodController.text = suggestion.description;
                                provider.setNutritionFromSuggestion(
                                  suggestion.description,
                                );
                                _submitFoodText();
                                setState(() {});
                              },
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              onPressed: provider.isLoading
                                  ? null
                                  : _submitFoodText,
                              child: const Text('Analyze Food'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        SizedBox(
                          height: 52,
                          child: OutlinedButton.icon(
                            onPressed: provider.isLoading
                                ? null
                                : _openBarcodeScanner,
                            icon: const Icon(Icons.qr_code_scanner),
                            label: const Text('Barcode'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: _NutritionStateView(
                        isLoading: provider.isLoading,
                        errorMessage: provider.errorMessage,
                        nutrition: provider.nutrition,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NutritionStateView extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final NutritionModel? nutrition;

  const _NutritionStateView({
    required this.isLoading,
    required this.errorMessage,
    required this.nutrition,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null) {
      return Center(
        child: Text(
          errorMessage!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.redAccent,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    if (nutrition == null) {
      return const Center(
        child: Text(
          'Search food text or scan barcode to see nutrition data.',
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.blueGrey.shade50,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Product name',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                nutrition!.foodName,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              if (nutrition!.brand != null &&
                  nutrition!.brand!.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Brand: ${nutrition!.brand}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                ),
              ],
              if (nutrition!.quantity != null &&
                  nutrition!.quantity!.trim().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Pack / quantity: ${nutrition!.quantity}',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade800),
                ),
              ],
              if (nutrition!.barcode != null &&
                  nutrition!.barcode!.trim().isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  'Barcode: ${nutrition!.barcode}',
                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                ),
              ],
              const SizedBox(height: 10),
              Text(
                'Source: ${nutrition!.source} | Serving: ${nutrition!.servingSize}',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        _nutritionCard(
          'Calories',
          '${nutrition!.calories.toStringAsFixed(0)} kcal',
          Icons.local_fire_department,
        ),
        _nutritionCard(
          'Protein',
          '${nutrition!.protein.toStringAsFixed(1)} g',
          Icons.fitness_center,
        ),
        _nutritionCard(
          'Carbs',
          '${nutrition!.carbs.toStringAsFixed(1)} g',
          Icons.rice_bowl,
        ),
        _nutritionCard(
          'Fat',
          '${nutrition!.fat.toStringAsFixed(1)} g',
          Icons.opacity,
        ),
        _nutritionCard(
          'Sugar',
          '${nutrition!.sugar.toStringAsFixed(1)} g',
          Icons.cake,
        ),
        _nutritionCard(
          'Fiber',
          '${nutrition!.fiber.toStringAsFixed(1)} g',
          Icons.eco,
        ),
        _nutritionCard(
          'Sodium',
          '${nutrition!.sodium.toStringAsFixed(1)} mg',
          Icons.water_drop,
        ),
        _nutritionCard(
          'Potassium',
          '${nutrition!.potassium.toStringAsFixed(1)} mg',
          Icons.bolt,
        ),
        _nutritionCard(
          'Cholesterol',
          '${nutrition!.cholesterol.toStringAsFixed(1)} mg',
          Icons.favorite,
        ),
      ],
    );
  }

  Widget _nutritionCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}

class _BarcodeScannerPage extends StatefulWidget {
  const _BarcodeScannerPage();

  @override
  State<_BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<_BarcodeScannerPage> {
  bool _hasScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      body: MobileScanner(
        onDetect: (capture) {
          if (_hasScanned) return;
          final value = capture.barcodes.isEmpty
              ? null
              : capture.barcodes.first.rawValue;
          if (value == null || value.isEmpty) return;

          _hasScanned = true;
          Navigator.pop(context, value);
        },
      ),
    );
  }
}
