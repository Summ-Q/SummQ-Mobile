import 'package:flutter/material.dart';
import '../theme.dart';

class NavTabData {
  final IconData icon;
  final String label;
  final Color color;
  const NavTabData({required this.icon, required this.label, required this.color});
}

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavTabData> tabs;

  const BottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 78,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final slotWidth = constraints.maxWidth / tabs.length;

          return Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: List.generate(tabs.length, (index) {
                      final selected = index == currentIndex;
                      return Expanded(
                        child: GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () => onTap(index),
                          child: Center(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 220),
                              opacity: selected ? 0 : 1,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(tabs[index].icon, color: AppColors.navy.withOpacity(0.6), size: 22),
                                  const SizedBox(height: 2),
                                  Text(
                                    tabs[index].label,
                                    style: appFont(
                                      size: 12,
                                      weight: FontWeight.w600,
                                      color: AppColors.navy.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
                left: slotWidth * currentIndex,
                top: -18,
                width: slotWidth,
                child: Column(
                  children: [
                    TweenAnimationBuilder<Color?>(
                      duration: const Duration(milliseconds: 320),
                      tween: ColorTween(begin: tabs[currentIndex].color, end: tabs[currentIndex].color),
                      builder: (context, color, _) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 320),
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: tabs[currentIndex].color,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: tabs[currentIndex].color.withOpacity(0.45),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(tabs[currentIndex].icon, color: AppColors.navy, size: 28),
                        );
                      },
                    ),
                    const SizedBox(height: 2),
                    Text(
                      tabs[currentIndex].label,
                      style: appFont(size: 12, weight: FontWeight.w700, color: AppColors.navy),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
