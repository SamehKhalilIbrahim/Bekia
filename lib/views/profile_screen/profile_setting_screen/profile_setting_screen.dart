import 'dart:io';
import 'dart:ui';
import 'package:bekia/main.dart';
import 'package:bekia/views/profile_screen/widgets/circler_profile_image.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/ui/themes/app_color.dart';
import '../../../core/ui/themes/font.dart';
import '../../../core/utils/custom_snack_bar.dart';
import '../../../cubit/auth_cubit/auth_bloc.dart';
import '../../../cubit/auth_cubit/auth_event.dart';
import '../../../cubit/auth_cubit/auth_states.dart';
import '../widgets/custom_profile_text_field.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  late AnimationController _animationController;
  late Animation<double> _headerAnimation;

  File? _selectedImage;
  String? _currentImageUrl;
  String? _currentEmail;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();

    _emailController = TextEditingController();

    // Create animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _headerAnimation = Tween<double>(begin: 150, end: 50).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.ease),
    );

    // Start animation and load user data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
      _loadUserData();
    });
  }

  void _loadUserData() {
    final state = context.read<AuthBloc>().state;
    if (state is AuthAuthenticated) {
      setState(() {
        _usernameController.text = state.user.username;

        _emailController.text = state.user.email;
        _currentEmail = state.user.email;
        _currentImageUrl = state.user.profileImageUrl;
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Check if email changed
      final emailChanged = _emailController.text.trim() != _currentEmail;

      if (emailChanged) {
        // Show dialog to get current password for email change
        _showPasswordDialog();
      } else {
        // Just update profile
        context.read<AuthBloc>().add(
          EditProfileRequested(
            username: _usernameController.text.trim(),

            imageFile: _selectedImage,
          ),
        );
      }
    }
  }

  void _showPasswordDialog() {
    final passwordController = TextEditingController();
    bool isPasswordVisible = false;

    showDialog(
      useSafeArea: true,
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          title: Text(
            'Confirm Password',
            style: TextStyle(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[800]
                  : AppColor.textColorDark,
              fontFamily: Font.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Please enter your current password to update your email.',
                style: TextStyle(
                  fontSize: 14,
                  color: Theme.of(context).hintColor,
                  fontFamily: Font.regular,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: !isPasswordVisible,
                style: TextStyle(
                  color: Theme.of(context).brightness == Brightness.light
                      ? Colors.grey[700]
                      : AppColor.textColorDark,
                ),
                decoration: InputDecoration(
                  labelText: 'Current Password',
                  labelStyle: TextStyle(color: Theme.of(context).hintColor),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey[400]!
                          : AppColor.dividerColorDark,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).brightness == Brightness.light
                          ? Colors.grey[400]!
                          : AppColor.dividerColorDark,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColorLight,
                      width: 2,
                    ),
                  ),
                  prefixIcon: Icon(
                    FluentIcons.lock_closed_20_regular,
                    color: Theme.of(context).hintColor,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? FluentIcons.eye_24_regular
                          : FluentIcons.eye_off_24_regular,
                      color: Theme.of(context).hintColor,
                    ),
                    onPressed: () {
                      setDialogState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).hintColor,
              ),
              child: Text(
                'Cancel',
                style: TextStyle(fontFamily: Font.semiBold),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                // Update email first, then profile
                context.read<AuthBloc>().add(
                  UpdateEmailRequested(
                    newEmail: _emailController.text.trim(),
                    currentPassword: passwordController.text,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColorLight,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Confirm',
                style: TextStyle(fontFamily: Font.semiBold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            showCustomSnackBar(
              context: context,
              backgroundColor: Colors.green,
              message: state.message,
            );
            // Update local state with new data
            setState(() {
              _currentEmail = state.user.email;
              _currentImageUrl = state.user.profileImageUrl;
              _selectedImage = null;
            });
            BlocProvider.of<AuthBloc>(context).add(LoadCurrentUser());
          } else if (state is AuthError) {
            showCustomSnackBar(
              context: context,
              backgroundColor: context.colors.primaryColorLight,
              message: state.message,
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Stack(
            children: [
              // Background
              Positioned.fill(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    _selectedImage != null
                        ? Image.file(
                            _selectedImage!,
                            fit: BoxFit.fitWidth,
                            height: context.height * 0.4,
                            width: context.width,
                          )
                        : CachedNetworkImage(
                            imageUrl: _currentImageUrl ?? '',
                            fit: BoxFit.fitWidth,
                            height: context.height * 0.4,
                            width: context.width,
                            errorWidget: (context, url, error) => Icon(
                              FluentIcons.person_48_regular,
                              size: 80,
                              color: context
                                  .colors
                                  .textTheme
                                  .headlineLarge!
                                  .color!,
                            ),
                          ),
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
                slivers: [
                  // App Bar
                  SliverAppBar(
                    backgroundColor: Colors.transparent,
                    leading: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      onPressed: () =>
                          isLoading ? null : Navigator.pop(context),
                    ),
                  ),

                  // Animated Header Space
                  SliverToBoxAdapter(
                    child: AnimatedBuilder(
                      animation: _headerAnimation,
                      builder: (context, child) {
                        return SizedBox(height: _headerAnimation.value);
                      },
                    ),
                  ),

                  // Main Content
                  SliverFillRemaining(
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
                          // Profile Image
                          Transform.translate(
                            offset: const Offset(0, -55),
                            child: SizedBox(
                              width: 140,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Display selected image or current image
                                  _selectedImage != null
                                      ? Container(
                                          width: 124,
                                          height: 124,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              strokeAlign:
                                                  BorderSide.strokeAlignOutside,
                                              color: context
                                                  .colors
                                                  .scaffoldBackgroundColor,
                                              width: 5,
                                            ),
                                            image: DecorationImage(
                                              image: FileImage(_selectedImage!),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        )
                                      : CirclerProfileImage(
                                          image: _currentImageUrl,
                                        ),
                                  // Edit button
                                  Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: InkWell(
                                      onTap: _pickImage,
                                      child: Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              context.colors.primaryColorLight,
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

                          // Name and Email Display
                          Transform.translate(
                            offset: const Offset(0, -25),
                            child: Column(
                              children: [
                                Text(
                                  _usernameController.text,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _emailController.text,
                                  style: const TextStyle(
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
                                  // Username
                                  CustomProfileFormField(
                                    controller: _usernameController,
                                    hintText: "Username",
                                    prefixIcon: FluentIcons.person_24_regular,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Username cannot be empty";
                                      }
                                      return null;
                                    },
                                  ),

                                  // Email
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

                                  // Save Button
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 54,
                                      child: ElevatedButton(
                                        onPressed: isLoading
                                            ? null
                                            : _saveChanges,
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
                                        child: isLoading
                                            ? SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: CircularProgressIndicator(
                                                  strokeWidth: 2,
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                        Color
                                                      >(
                                                        context
                                                            .colors
                                                            .primaryColorLight,
                                                      ),
                                                ),
                                              )
                                            : const Text(
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
