import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'home/lesson_map_screen.dart';
import 'leaderboard/leaderboard_screen.dart';
import 'practice/practice_screen.dart';
import 'practice/practice_hub_screen.dart';
import 'profile/profile_screen.dart';
import 'shop/shop_screen.dart';
import 'stories/stories_tab_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    LessonMapScreen(),
    StoriesTabScreen(),
    PracticeHubScreen(),
    LeaderboardScreen(),
    ShopScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.greyBorder, width: 2)),
        ),
        child: SafeArea(
          top: false,
          child: SizedBox(
            height: 64,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_rounded, 'Learn'),
                _buildNavItem(1, Icons.auto_stories_rounded, 'Stories'),
                _buildNavItem(2, Icons.fitness_center_rounded, 'Practice'),
                _buildNavItem(3, Icons.shield_rounded, 'League'),
                _buildNavItem(4, Icons.storefront_rounded, 'Shop'),
                _buildNavItem(5, Icons.face_rounded, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _selectedIndex == index;

    return InkWell(
      onTap: () => setState(() => _selectedIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blueBg : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
          border: isSelected
              ? Border.all(color: AppColors.blue, width: 2)
              : null,
        ),
        child: Icon(
          icon,
          size: 26,
          color: isSelected ? AppColors.blue : AppColors.greyDark,
        ),
      ),
    );
  }
}
