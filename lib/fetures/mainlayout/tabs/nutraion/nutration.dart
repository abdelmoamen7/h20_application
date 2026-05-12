import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';

import '../../../../core/colorsmanger/colorsmanger.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../models/nutrition_model.dart';
import '../../../../services/FirebaseServcies/firebaseService.dart';
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
  void initState() {
    super.initState();
    _foodController.addListener(() => setState(() {}));
  }

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

  Future<void> _logToToday(NutritionModel nutrition) async {
    final calories = nutrition.calories.round();
    final protein = nutrition.protein.round();
    await Fairebaeservices.updateDailyTracking(
      addCalories: calories,
      addProtein: protein,
    );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '+ $calories kcal  •  + ${protein}g protein',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colorsmanger.Blue,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NutritionProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colorsmanger.Blue, Colorsmanger.darkblue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(24.r),
                ),
              ),
            ),
            title: Text(
              AppLocalizations.of(context)!.nutrition,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w800,
                fontSize: 18.sp,
                color: Colors.white,
              ),
            ),
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: SafeArea(
            top: false,
            child: GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: ColoredBox(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SearchCard(
                        controller: _foodController,
                        provider: provider,
                        onClear: () {
                          _foodController.clear();
                          provider.clearState();
                          setState(() {});
                        },
                        onSubmit: _submitFoodText,
                      ),
                      if (provider.suggestions.isNotEmpty) ...[
                        SizedBox(height: 10.h),
                        _SuggestionsPanel(
                          provider: provider,
                          onPick: (text) {
                            _foodController.text = text;
                            provider.setNutritionFromSuggestion(text);
                            _submitFoodText();
                            setState(() {});
                          },
                        ),
                      ],
                      SizedBox(height: 14.h),
                      _ActionRow(
                        isLoading: provider.isLoading,
                        onAnalyze: _submitFoodText,
                        onBarcode: _openBarcodeScanner,
                      ),
                      SizedBox(height: 16.h),
                      Expanded(
                        child: _NutritionStateView(
                          isLoading: provider.isLoading,
                          errorMessage: provider.errorMessage,
                          nutrition: provider.nutrition,
                          onLog: provider.nutrition != null
                              ? () => _logToToday(provider.nutrition!)
                              : null,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SearchCard extends StatelessWidget {
  final TextEditingController controller;
  final NutritionProvider provider;
  final VoidCallback onClear;
  final VoidCallback onSubmit;

  const _SearchCard({
    required this.controller,
    required this.provider,
    required this.onClear,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colorsmanger.Blue.withValues(alpha: 0.14)),
        boxShadow: [
          BoxShadow(
            color: Colorsmanger.Blue.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.restaurant_menu_rounded,
                color: Colorsmanger.Blue,
                size: 22.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                AppLocalizations.of(context)!.analyze_meal,
                style: GoogleFonts.inter(                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  color: Colorsmanger.darkblue,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            AppLocalizations.of(context)!.type_ingredients,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              color: Colorsmanger.Grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 14.h),
          TextFormField(
            controller: controller,
            onChanged: provider.onQueryChanged,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (_) => onSubmit(),
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              color: Colorsmanger.darkblue,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF5F7FF),
              hintText: AppLocalizations.of(context)!.meal_hint,
              hintStyle: GoogleFonts.inter(
                color: Colorsmanger.Grey,
                fontSize: 13.sp,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: Colorsmanger.Blue,
                size: 22.sp,
              ),
              suffixIcon: controller.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: onClear,
                      icon: Icon(
                        Icons.close_rounded,
                        color: Colorsmanger.Grey,
                        size: 20.sp,
                      ),
                    ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 4.w,
                vertical: 14.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: BorderSide(
                  color: Colorsmanger.Blue.withValues(alpha: 0.22),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
                borderSide: const BorderSide(
                  color: Colorsmanger.Blue,
                  width: 2,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuggestionsPanel extends StatelessWidget {
  final NutritionProvider provider;
  final void Function(String text) onPick;

  const _SuggestionsPanel({required this.provider, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 160.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colorsmanger.Blue.withValues(alpha: 0.18)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.symmetric(vertical: 4.h),
          itemCount: provider.suggestions.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            color: Colorsmanger.Blue.withValues(alpha: 0.08),
          ),
          itemBuilder: (context, index) {
            final s = provider.suggestions[index];
            return Material(
              color: Colors.white,
              child: InkWell(
                onTap: () => onPick(s.description),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.auto_awesome_rounded,
                        size: 18.sp,
                        color: Colorsmanger.Blue.withValues(alpha: 0.85),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          s.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: Colorsmanger.darkblue,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: Colorsmanger.Blue.withValues(alpha: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onAnalyze;
  final VoidCallback onBarcode;

  const _ActionRow({
    required this.isLoading,
    required this.onAnalyze,
    required this.onBarcode,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52.h,
            child: ElevatedButton(
              onPressed: isLoading ? null : onAnalyze,
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: Colorsmanger.Blue,
                foregroundColor: Colors.white,
                disabledBackgroundColor: Colorsmanger.Blue.withValues(
                  alpha: 0.45,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              child: isLoading
                  ? SizedBox(
                      width: 22.w,
                      height: 22.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2.2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      AppLocalizations.of(context)!.analyze_food,
                      style: GoogleFonts.inter(
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                      ),
                    ),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        SizedBox(
          height: 52.h,
          child: OutlinedButton(
            onPressed: isLoading ? null : onBarcode,
            style: OutlinedButton.styleFrom(
              foregroundColor: Colorsmanger.Blue,
              side: const BorderSide(color: Colorsmanger.Blue, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14.w),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.qr_code_scanner_rounded, size: 22.sp),
                SizedBox(width: 6.w),
                Text(
                  AppLocalizations.of(context)!.scan,
                  style: GoogleFonts.inter(
                    fontWeight: FontWeight.w700,
                    fontSize: 14.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _NutritionStateView extends StatelessWidget {
  final bool isLoading;
  final String? errorMessage;
  final NutritionModel? nutrition;
  final VoidCallback? onLog;

  const _NutritionStateView({
    required this.isLoading,
    required this.errorMessage,
    required this.nutrition,
    this.onLog,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 40.w,
              height: 40.w,
              child: const CircularProgressIndicator(
                color: Colorsmanger.Blue,
                strokeWidth: 3,
              ),
            ),
            SizedBox(height: 16.h),
            Text(
              AppLocalizations.of(context)!.fetching_nutrition,              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: Colorsmanger.Grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return _EmptyOrMessage(
        icon: Icons.error_outline_rounded,
        iconColor: Colorsmanger.Red.withValues(alpha: 0.9),
        title: AppLocalizations.of(context)!.something_went_wrong,
        subtitle: errorMessage!,
      );
    }

    if (nutrition == null) {
      return _EmptyOrMessage(
        icon: Icons.restaurant_rounded,
        iconColor: Colorsmanger.Blue.withValues(alpha: 0.85),
        title: AppLocalizations.of(context)!.no_results_yet,
        subtitle: AppLocalizations.of(context)!.no_results_subtitle,
      );
    }

    final n = nutrition!;
    return ListView(
      padding: EdgeInsets.only(bottom: 88.h),
      children: [
        _ProductHeaderCard(nutrition: n),
        SizedBox(height: 14.h),
        _CaloriesHeroCard(nutrition: n),
        SizedBox(height: 12.h),
        // ── Log to Today button ──────────────────────────────────────────
        SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton.icon(
            onPressed: onLog,
            icon: const Icon(Icons.add_circle_outline_rounded),
            label: Text(
              '${AppLocalizations.of(context)!.log_meal}  •  ${n.calories.toStringAsFixed(0)} kcal',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 15.sp,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade600,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
          ),
        ),
        SizedBox(height: 14.h),
        Text(
          AppLocalizations.of(context)!.macronutrients,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colorsmanger.darkblue,
          ),
        ),
        SizedBox(height: 10.h),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10.h,
          crossAxisSpacing: 10.w,
          childAspectRatio: 1.35,
          children: [
            _MacroTile(
              label: AppLocalizations.of(context)!.protein,
              value: '${n.protein.toStringAsFixed(1)} g',
              icon: Icons.fitness_center_rounded,
            ),
            _MacroTile(
              label: AppLocalizations.of(context)!.carbs,
              value: '${n.carbs.toStringAsFixed(1)} g',
              icon: Icons.grain_rounded,
            ),
            _MacroTile(
              label: AppLocalizations.of(context)!.fat,
              value: '${n.fat.toStringAsFixed(1)} g',
              icon: Icons.water_drop_rounded,
            ),
            _MacroTile(
              label: AppLocalizations.of(context)!.sugar,
              value: '${n.sugar.toStringAsFixed(1)} g',
              icon: Icons.icecream_rounded,
            ),
          ],
        ),
        SizedBox(height: 18.h),
        Text(
          AppLocalizations.of(context)!.more_details,
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w800,
            color: Colorsmanger.darkblue,
          ),
        ),
        SizedBox(height: 10.h),
        _DetailRow(
          icon: Icons.eco_rounded,
          label: AppLocalizations.of(context)!.fiber,
          value: '${n.fiber.toStringAsFixed(1)} g',
        ),
        _DetailRow(
          icon: Icons.opacity_rounded,
          label: AppLocalizations.of(context)!.sodium,
          value: '${n.sodium.toStringAsFixed(1)} mg',
        ),
        _DetailRow(
          icon: Icons.bolt_rounded,
          label: AppLocalizations.of(context)!.potassium,
          value: '${n.potassium.toStringAsFixed(1)} mg',
        ),
        _DetailRow(
          icon: Icons.favorite_rounded,
          label: AppLocalizations.of(context)!.cholesterol,
          value: '${n.cholesterol.toStringAsFixed(1)} mg',
        ),
      ],
    );
  }
}

class _EmptyOrMessage extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _EmptyOrMessage({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(18.w),
              decoration: BoxDecoration(
                color: const Color(0xFFF0F3FF),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40.sp, color: iconColor),
            ),
            SizedBox(height: 18.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: Colorsmanger.darkblue,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                height: 1.45,
                color: Colorsmanger.Grey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductHeaderCard extends StatelessWidget {
  final NutritionModel nutrition;

  const _ProductHeaderCard({required this.nutrition});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: Colorsmanger.Blue.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colorsmanger.Blue.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: Colorsmanger.Blue.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  nutrition.source,
                  style: GoogleFonts.inter(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: Colorsmanger.Blue,
                  ),
                ),
              ),
              const Spacer(),
              Icon(Icons.scale_rounded, size: 18.sp, color: Colorsmanger.Grey),
              SizedBox(width: 4.w),
              Flexible(
                child: Text(
                  nutrition.servingSize,
                  style: GoogleFonts.inter(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: Colorsmanger.Grey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            AppLocalizations.of(context)!.product,
            style: GoogleFonts.inter(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: Colorsmanger.Blue,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            nutrition.foodName,
            style: GoogleFonts.inter(
              fontSize: 19.sp,
              fontWeight: FontWeight.w800,
              height: 1.25,
              color: Colorsmanger.darkblue,
            ),
          ),
          if (nutrition.brand != null &&
              nutrition.brand!.trim().isNotEmpty) ...[
            SizedBox(height: 10.h),
            _MetaLine(icon: Icons.storefront_rounded, text: nutrition.brand!),
          ],
          if (nutrition.quantity != null &&
              nutrition.quantity!.trim().isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: _MetaLine(
                icon: Icons.inventory_2_outlined,
                text: nutrition.quantity!,
              ),
            ),
          if (nutrition.barcode != null && nutrition.barcode!.trim().isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: 6.h),
              child: _MetaLine(
                icon: Icons.qr_code_2_rounded,
                text: nutrition.barcode!,
              ),
            ),
        ],
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaLine({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16.sp, color: Colorsmanger.Grey),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              color: Colorsmanger.darkblue.withValues(alpha: 0.85),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _CaloriesHeroCard extends StatelessWidget {
  final NutritionModel nutrition;

  const _CaloriesHeroCard({required this.nutrition});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 18.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colorsmanger.Blue,
            Color.lerp(Colorsmanger.Blue, Colorsmanger.darkblue, 0.35)!,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colorsmanger.Blue.withValues(alpha: 0.35),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Icon(
              Icons.local_fire_department_rounded,
              color: Colors.white,
              size: 28.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.calories,
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  nutrition.calories.toStringAsFixed(0),
                  style: GoogleFonts.inter(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.kcal,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _MacroTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colorsmanger.Blue.withValues(alpha: 0.12)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF1FF),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: Colorsmanger.Blue, size: 20.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colorsmanger.Grey,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: Colorsmanger.darkblue,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFF),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colorsmanger.Blue.withValues(alpha: 0.08)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colorsmanger.Blue, size: 22.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colorsmanger.darkblue,
                ),
              ),
            ),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w800,
                color: Colorsmanger.Blue,
              ),
            ),
          ],
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colorsmanger.Blue, Colorsmanger.darkblue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.r)),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          AppLocalizations.of(context)!.scan_barcode,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 17.sp,
          ),
        ),
      ),
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
