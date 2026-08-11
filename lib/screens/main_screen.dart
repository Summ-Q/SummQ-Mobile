import 'package:flutter/material.dart';
import '../bottom_nav.dart';
import '../theme.dart';
import 'home_screen.dart';
import 'performance_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _index = 1;

  final List<Widget> _tabs = const [
    PerformanceTab(),
    HomeTab(),
    ProfileTab(),
  ];

  final List<NavTabData> _navTabs = const [
    NavTabData(icon: Icons.show_chart_rounded, label: 'performance', color: AppColors.lightBlue),
    NavTabData(icon: Icons.home_rounded, label: 'Home', color: AppColors.yellowCard),
    NavTabData(icon: Icons.person_rounded, label: 'profile', color: AppColors.green),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.navy,
      body: SafeArea(
        bottom: false,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 260),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) => FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 0.03), end: Offset.zero).animate(animation),
              child: child,
            ),
          ),
          child: KeyedSubtree(
            key: ValueKey<int>(_index),
            child: _tabs[_index],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        child: BottomNav(
          currentIndex: _index,
          tabs: _navTabs,
          onTap: (i) => setState(() => _index = i),
        ),
      ),
    );
  }
}
