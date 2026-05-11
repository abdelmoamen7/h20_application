import 'package:flutter/material.dart';
import 'package:h20_application/fetures/mainlayout/tabs/home/home.dart';
import 'package:h20_application/fetures/mainlayout/tabs/nutraion/nutration.dart';
import 'package:h20_application/fetures/mainlayout/tabs/profile/profile.dart';
import 'package:h20_application/fetures/mainlayout/tabs/workout/workout.dart';
import '../../core/colorsmanger/colorsmanger.dart';
import '../../l10n/app_localizations.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  static const int _tabCount = 4;

  int selectedIndex = 0;

  /// Build only the visible tab so Workout/Nutrition network work does not run at startup.
  Widget _pageFor(int index) {
    switch (index) {
      case 0:
        return const Home();
      case 1:
        return const NutritionScreen();
      case 2:
        return const workout();
      case 3:
        return const Profile();
      default:
        return const Home();
    }
  }

  void _onTap(int newIndex) {
    setState(() {
      selectedIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pageFor(selectedIndex),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildCustomBottomNavigationBar(),
    );
  }

  // Widget _buildFloatingActionButton() {
  //   return FloatingActionButton(
  //     onPressed: () {
  //       Navigator.pushNamed(context, Routesmanger.CreateEvents);
  //     },
  //     child: Icon(Icons.add),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(20),
  //       side: BorderSide(color: Colorsmanger.Whiteblue, width: 4),
  //     ),
  //   );
  // }

  Widget _buildCustomBottomNavigationBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
        decoration: BoxDecoration(
          color: Colorsmanger.Blue,
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colorsmanger.Blue.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(_tabCount, (index) {
            bool isSelected = selectedIndex == index;
            IconData icon = _getIcon(index);
            String label = _getLabel(index, context);

            return GestureDetector(
              onTap: () => _onTap(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white.withValues(alpha: 0.25) : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        icon,
                        key: ValueKey<bool>(isSelected),
                        color: Colors.white,
                        size: isSelected ? 26 : 24,
                      ),
                    ),
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  IconData _getIcon(int index) {
    switch (index) {
      case 0: return Icons.home_rounded;
      case 1: return Icons.restaurant_menu_rounded;
      case 2: return Icons.fitness_center_rounded;
      case 3: return Icons.person_rounded;
      default: return Icons.home;
    }
  }

  String _getLabel(int index, BuildContext context) {
    switch (index) {
      case 0: return AppLocalizations.of(context)!.home;
      case 1: return AppLocalizations.of(context)!.nutrition;
      case 2: return AppLocalizations.of(context)!.workout;
      case 3: return AppLocalizations.of(context)!.profile;
      default: return "";
    }
  }
}
