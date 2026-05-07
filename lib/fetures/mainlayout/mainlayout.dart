
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:h20_application/fetures/mainlayout/tabs/home/home.dart';
import 'package:h20_application/fetures/mainlayout/tabs/nutraion/nutration.dart';
import 'package:h20_application/fetures/mainlayout/tabs/profile/profile.dart';
import 'package:h20_application/fetures/mainlayout/tabs/workout/workout.dart';

import '../../core/colorsmanger/colorsmanger.dart';
import '../../core/routesmanger/routesManger.dart';
import '../../l10n/app_localizations.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});


  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {

  final List<Widget> tab = [
    Home(),
    nutraion(),
    workout(),
    profile(),
  ];

  int selectedIndex = 0;

  void _onTap(int newIndex) {
    setState(() {
      selectedIndex = newIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    AppLocalizations? appLocalizations = AppLocalizations.of(context);
    return Scaffold(
      extendBody: true,
      body: tab[selectedIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: _buildBottomNavigationBar(),
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

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      onTap: _onTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.white70,
      backgroundColor: Colorsmanger.Blue,
      items: [
        BottomNavigationBarItem(icon:  Icon(Icons.home), label: AppLocalizations.of(context)!.home),
        BottomNavigationBarItem(icon: Icon(Icons.no_meals), label:AppLocalizations.of(context)!.nutrition),
        BottomNavigationBarItem(icon: Icon(Icons.sports_gymnastics), label: AppLocalizations.of(context)!.workout),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: AppLocalizations.of(context)!.profile),
      ],
    );
  }
}
