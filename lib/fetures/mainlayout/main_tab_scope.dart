import 'package:flutter/material.dart';

/// Lets deep widgets (e.g. [Home]) switch the main bottom navigation tab
/// without duplicating routes.
class MainTabScope extends InheritedWidget {
  final void Function(int index) goToTab;

  const MainTabScope({
    super.key,
    required this.goToTab,
    required super.child,
  });

  static MainTabScope? _maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<MainTabScope>();
  }

  /// Tab indices: 0 Home, 1 Nutrition, 2 Workout, 3 Profile
  static void goTo(BuildContext context, int index) {
    _maybeOf(context)?.goToTab(index);
  }

  @override
  bool updateShouldNotify(covariant MainTabScope oldWidget) {
    return goToTab != oldWidget.goToTab;
  }
}
