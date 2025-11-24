import 'package:flutter/material.dart';

// ============================================
// SOLUTION 1: Custom Page Route with Fade
// ============================================
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;

  FadePageRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 400),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           return FadeTransition(opacity: animation, child: child);
         },
       );
}

// ============================================
// SOLUTION 2: Custom Slide + Fade Route
// ============================================
class SmoothSlideRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;

  SmoothSlideRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 500),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           const begin = Offset(1.0, 0.0);
           const end = Offset.zero;
           const curve = Curves.easeInOutCubic;

           var slideTween = Tween(
             begin: begin,
             end: end,
           ).chain(CurveTween(curve: curve));
           var fadeTween = Tween<double>(
             begin: 0.0,
             end: 1.0,
           ).chain(CurveTween(curve: curve));

           return SlideTransition(
             position: animation.drive(slideTween),
             child: FadeTransition(
               opacity: animation.drive(fadeTween),
               child: child,
             ),
           );
         },
       );
}

// ============================================
// SOLUTION 3: Hero-like Transition
// ============================================
class ScalePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;

  ScalePageRoute({
    required this.page,
    this.duration = const Duration(milliseconds: 450),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => page,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           const curve = Curves.easeOutCubic;

           var scaleTween = Tween<double>(
             begin: 0.92,
             end: 1.0,
           ).chain(CurveTween(curve: curve));
           var fadeTween = Tween<double>(
             begin: 0.0,
             end: 1.0,
           ).chain(CurveTween(curve: curve));

           return ScaleTransition(
             scale: animation.drive(scaleTween),
             child: FadeTransition(
               opacity: animation.drive(fadeTween),
               child: child,
             ),
           );
         },
       );
}

// ============================================
// HOW TO USE IN YOUR PROFILE SCREEN
// ============================================

/* 
// OPTION 1: Simple Fade (Recommended - smoothest)
Navigator.push(
  context,
  FadePageRoute(page: ProfileSettingScreen()),
);

// OPTION 2: Slide + Fade
Navigator.push(
  context,
  SmoothSlideRoute(page: ProfileSettingScreen()),
);

// OPTION 3: Scale + Fade (Modern feel)
Navigator.push(
  context,
  ScalePageRoute(page: ProfileSettingScreen()),
);

// OPTION 4: Instant transition (no animation)
Navigator.push(
  context,
  PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => ProfileSettingScreen(),
    transitionDuration: Duration.zero,
    reverseTransitionDuration: const Duration(milliseconds: 300),
  ),
);
*/
