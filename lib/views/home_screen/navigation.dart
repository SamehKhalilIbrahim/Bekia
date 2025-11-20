import 'dart:ui';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../cart_screen/cart_screen.dart';
import '../profile_screen/profile_screen.dart';
import '../wishlist_screen/wishlist_screen.dart';
import 'home.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({super.key});

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late ScrollController _scrollController;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final ValueNotifier<bool> _showBottomNav = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _pageController.dispose();
    _showBottomNav.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      _showBottomNav.value = false;
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      _showBottomNav.value = true;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              HomeScreen(scrollController: _scrollController),
              WishlistScreen(scrollController: _scrollController),
              CartScreen(scrollController: _scrollController),
              ProfileScreen(scrollController: _scrollController),
            ],
          ),
          ValueListenableBuilder<bool>(
            valueListenable: _showBottomNav,
            builder: (context, show, child) {
              return Positioned(
                bottom: 10,
                left: MediaQuery.of(context).size.width * 0.15,
                right: MediaQuery.of(context).size.width * 0.15,
                child: SafeArea(
                  child: AnimatedOpacity(
                    opacity: show ? 1 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: bottomNavigationBar(context),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget bottomNavigationBar(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          width: 200,
          height: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).cardColor,
                Theme.of(context).cardColor,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).cardColor,
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: ColorFiltered(
            colorFilter: const ColorFilter.mode(
              Colors.transparent,
              BlendMode.srcOver,
            ),
            child: NavigationBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              animationDuration: const Duration(milliseconds: 200),
              labelBehavior:
                  NavigationDestinationLabelBehavior.onlyShowSelected,
              overlayColor: WidgetStateProperty.all(
                Theme.of(context).primaryColorLight.withOpacity(0.9),
              ),
              indicatorColor: Theme.of(
                context,
              ).primaryColorLight.withOpacity(0.7),
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onItemTapped,
              destinations: const [
                NavigationDestination(
                  icon: Icon(FluentIcons.home_12_regular),
                  label: "Home",
                  selectedIcon: Icon(FluentIcons.home_12_filled),
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_border_rounded),
                  label: "Wishlist",
                  selectedIcon: Icon(Icons.favorite_rounded),
                ),
                NavigationDestination(
                  icon: Icon(Icons.shopping_cart_outlined),
                  label: "Cart",
                  selectedIcon: Icon(Icons.shopping_cart_rounded),
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline_rounded),
                  label: "Profile",
                  selectedIcon: Icon(Icons.person),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
