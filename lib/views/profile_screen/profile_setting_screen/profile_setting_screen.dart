import 'dart:ui';
import 'package:bekia/main.dart';
import 'package:bekia/views/profile_screen/widgets/circler_profile_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_profile_text_field.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;

  late AnimationController _animationController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Sameh Khalil');
    _emailController = TextEditingController(text: "sameh.eldegwy@gmail.com");

    // Create animation controller (INVERSE of profile screen)
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Reversed animation: starts at 230, ends at 55
    _headerAnimation = Tween<double>(begin: 180, end: 55).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.ease),
    );

    // Start animation after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 🌫️ Background (Image + Blur + Gradient) - Same as profile screen
          Positioned.fill(
            child: Stack(
              children: [
                // Background image
                Image.asset("assets/images/profile.jpg", fit: BoxFit.cover),
                // Blur layer
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

          SafeArea(
            child: CustomScrollView(
              slivers: [
                // App Bar
                SliverAppBar(
                  backgroundColor: Colors.transparent,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

                // Animated Header Space (INVERSE animation)
                SliverToBoxAdapter(
                  child: AnimatedBuilder(
                    animation: _headerAnimation,
                    builder: (context, child) {
                      return SizedBox(height: _headerAnimation.value);
                    },
                  ),
                ),

                // Main Content Container
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
                        // Profile Image (elevated above container)
                        Transform.translate(
                          offset: const Offset(0, -55),
                          child: SizedBox(
                            width: 140,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                const CirclerProfileImage(showBorder: true),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {},
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: context.colors.primaryColorLight,
                                        border: Border.all(
                                          strokeAlign:
                                              BorderSide.strokeAlignOutside,
                                          color: context
                                              .colors
                                              .scaffoldBackgroundColor,
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Icon(
                                        FluentIcons.edit_28_regular,
                                        size: 22,
                                        color: context
                                            .colors
                                            .textTheme
                                            .headlineLarge!
                                            .color!,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        Transform.translate(
                          offset: const Offset(0, -25),
                          child: Column(
                            children: const [
                              Text(
                                "Sameh Khalil",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                "sameh.eldegwy@gmail.com",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 8),

                        // Form Fields
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              spacing: 16,
                              children: [
                                CustomProfileFormField(
                                  controller: _nameController,
                                  hintText: "User Name",
                                  prefixIcon: FluentIcons.person_24_regular,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Name cannot be empty";
                                    }
                                    return null;
                                  },
                                ),

                                CustomProfileFormField(
                                  controller: _emailController,
                                  hintText: "Email",
                                  prefixIcon: FluentIcons.mail_48_regular,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Email cannot be empty";
                                    }
                                    if (!value.contains("@")) {
                                      return "Enter a valid email";
                                    }
                                    return null;
                                  },
                                ),

                                // SAVE BUTTON
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 54,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          // Save changes logic
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Changes saved successfully!',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            context.colors.primaryColorLight,
                                        foregroundColor: context
                                            .colors
                                            .textTheme
                                            .headlineLarge!
                                            .color!,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Save Changes',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 80),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
