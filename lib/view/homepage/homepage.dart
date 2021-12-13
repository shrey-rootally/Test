import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rootally/constants/app_colors.dart';
import 'package:rootally/view/demo_screen/demo_screen.dart';
import 'package:rootally/view/profile_screen/profile_screen.dart';
import 'package:rootally/view/raheb_screen/raheb_screen.dart';
import 'package:rootally/view/today_screen/today_screen.dart';

class HomePage extends StatefulWidget {
  final String from;

  const HomePage({Key? key, required this.from}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        elevation: 0,
        selectedItemColor: AppColors.selectedColor,
        unselectedItemColor: AppColors.unSelectedColor,
        showUnselectedLabels: true,
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        type: BottomNavigationBarType.shifting,
        items: const [
          BottomNavigationBarItem(
            label: 'Today',
            icon: Icon(Icons.calendar_today_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Rehab',
            icon: Icon(Icons.hiking_rounded),
          ),
          BottomNavigationBarItem(
            label: 'Demo',
            icon: Icon(Icons.explore_outlined),
          ),
          BottomNavigationBarItem(
            label: 'Profile',
            icon: Icon(Icons.person_outline_rounded),
          ),
        ],
      ),
      body: SafeArea(
        child: getCurrentScreen(widget.from),
      ),
    );
  }

  Widget getCurrentScreen(String from) {
    switch (_currentIndex) {
      case 0:
        return TodayScreen(
          from: from,
        );
      case 1:
        return const RahebScreen();
      case 2:
        return const DemoScreen();
      case 3:
        return ProfileScreen();
      default:
        return Container();
    }
  }
}
