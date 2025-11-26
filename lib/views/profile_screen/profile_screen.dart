import 'dart:ui';
import 'package:bekia/cubit/auth_cubit/auth_event.dart';
import 'package:bekia/main.dart';
import 'package:bekia/views/login_and_register/login_page.dart';
import 'package:bekia/views/profile_screen/profile_setting_screen/profile_setting_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/ui/animations/screen_transactions_animation.dart';
import '../../core/ui/themes/theme_model.dart';
import '../../cubit/auth_cubit/auth_bloc.dart';
import '../../cubit/auth_cubit/auth_states.dart';
import 'change_pass_screen/change_password_screen.dart';
import 'widgets/circler_profile_image.dart';
import 'widgets/profile_tile.dart';

class ProfileScreen extends StatefulWidget {
  final ScrollController scrollController;

  const ProfileScreen({super.key, required this.scrollController});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _headerAnimation;

  String _username = '';
  String _email = '';
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();

    // Create animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    // Create tween animation
    _headerAnimation = Tween<double>(begin: 55, end: 230).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    // Start animation after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      _loadUserData();
    });
  }

  void _loadUserData() {
    final state = context.read<AuthBloc>().state;
    if (state is AuthAuthenticated) {
      setState(() {
        _username = state.user.username;
        _email = state.user.email;
        _profileImageUrl = state.user.profileImageUrl;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        // Update user data when profile is updated
        if (state is ProfileUpdated) {
          setState(() {
            _username = state.user.username;
            _email = state.user.email;
            _profileImageUrl = state.user.profileImageUrl;
          });
        } else if (state is AuthAuthenticated) {
          setState(() {
            _username = state.user.username;
            _email = state.user.email;
            _profileImageUrl = state.user.profileImageUrl;
          });
        }
      },
      child: Stack(
        children: [
          // 🌫️ Background (Image + Blur + Gradient)
          Positioned.fill(
            child: Stack(
              children: [
                // Background image
                CachedNetworkImage(
                  imageUrl: _profileImageUrl ?? '',
                  fit: BoxFit.fitWidth,
                  height: context.height * 0.4,
                  width: context.width,
                  errorWidget: (context, url, error) => Icon(
                    FluentIcons.person_48_regular,
                    size: 80,
                    color: context.colors.textTheme.headlineLarge!.color!,
                  ),
                ), // Blur layer
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                  child: Container(
                    height: context.height * 0.5,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.25),
                          Colors.black.withOpacity(0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          CustomScrollView(
            controller: widget.scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: AnimatedBuilder(
                  animation: _headerAnimation,
                  builder: (context, child) {
                    return SizedBox(height: _headerAnimation.value);
                  },
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    color: context.colors.scaffoldBackgroundColor,
                  ),
                  child: Column(
                    children: [
                      // Profile Avatar
                      Transform.translate(
                        offset: const Offset(0, -55),
                        child: CirclerProfileImage(image: _profileImageUrl),
                      ),
                      // User Info
                      Transform.translate(
                        offset: const Offset(0, -25),
                        child: Column(
                          children: [
                            Text(
                              _username.isEmpty ? "" : _username,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _email.isEmpty ? "" : _email,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Menu Tiles
                      ProfileTile(
                        icon: const Icon(
                          FluentIcons.person_edit_24_regular,
                          size: 22,
                        ),
                        title: "Profile Settings",
                        onTap: () {
                          Navigator.push(
                            context,
                            ScalePageRoute(page: const ProfileSettingScreen()),
                          );
                        },
                      ),
                      ProfileTile(
                        icon: const Icon(
                          FluentIcons.lock_closed_key_16_regular,
                          size: 22,
                        ),
                        title: "Change Password",
                        onTap: () {
                          Navigator.push(
                            context,
                            SmoothSlideRoute(
                              page: const ChangePasswordScreen(),
                            ),
                          );
                        },
                      ),
                      BlocBuilder<ThemeCubit, ThemeState>(
                        builder: (context, state) {
                          return ProfileTile(
                            icon: Icon(
                              state.isDark
                                  ? FluentIcons.weather_sunny_20_regular
                                  : FluentIcons.weather_moon_20_regular,
                              size: 22,
                            ),
                            title: "Dark Mode",
                            onTap: () {
                              // Optional: toggle on tile tap
                              context.read<ThemeCubit>().toggleTheme();
                            },
                            virticalPadding: 8,
                            suffixWidget: SizedBox(
                              height: 42,
                              child: FittedBox(
                                fit: BoxFit.fitHeight,
                                child: Switch(
                                  value: state.isDark,
                                  onChanged: (value) {
                                    context.read<ThemeCubit>().setTheme(value);
                                  },
                                  activeThumbColor:
                                      context.colors.primaryColorLight,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      Divider(
                        color: context.colors.textTheme.bodyMedium?.color
                            ?.withValues(alpha: 0.75),
                        indent: 26,
                        endIndent: 26,
                        thickness: 1,
                      ),
                      ProfileTile(
                        icon: const Icon(
                          FluentIcons.chat_help_20_regular,
                          size: 22,
                        ),
                        title: "Support",
                        onTap: () {},
                      ),
                      ProfileTile(
                        title: "Logout",
                        onTap: () {
                          context.read<AuthBloc>().add(LogoutRequested());

                          Navigator.pushAndRemoveUntil(
                            context,
                            SmoothSlideRoute(page: const LoginPage()),
                            (route) => false,
                          );
                        },
                        suffixWidget: Icon(
                          FluentIcons.door_arrow_right_16_regular,
                          color: context.colors.primaryColorLight,
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
