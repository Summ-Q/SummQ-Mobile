import 'package:flutter/material.dart';

enum SlideDirection { right, up, fade }

Route<T> smoothRoute<T>(Widget page, {SlideDirection direction = SlideDirection.up}) {
  return PageRouteBuilder<T>(
    transitionDuration: const Duration(milliseconds: 420),
    reverseTransitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);

      Offset begin;
      switch (direction) {
        case SlideDirection.right:
          begin = const Offset(0.18, 0);
          break;
        case SlideDirection.up:
          begin = const Offset(0, 0.10);
          break;
        case SlideDirection.fade:
          begin = Offset.zero;
          break;
      }

      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(begin: begin, end: Offset.zero).animate(curved),
          child: child,
        ),
      );
    },
  );
}
