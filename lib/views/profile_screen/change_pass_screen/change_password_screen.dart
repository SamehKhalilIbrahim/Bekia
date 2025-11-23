import 'package:bekia/main.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

import '../widgets/custom_profile_text_field.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _changePassword() {
    if (_formKey.currentState!.validate()) {
      // Save password logic here
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Password changed successfully'),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 22),

                      // Icon
                      Center(
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: context.colors.primaryColorLight.withOpacity(
                              0.2,
                            ),
                          ),
                          child: Icon(
                            FluentIcons.lock_closed_key_20_regular,
                            size: 48,
                            color: context.colors.primaryColor,
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Title
                      Text(
                        'Create New Password',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: context.colors.textTheme.bodyMedium!.color!,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Description
                      Text(
                        'Your new password must be different from previously used passwords.',
                        style: TextStyle(
                          fontSize: 14,
                          color: context.colors.textTheme.bodyMedium!.color!
                              .withOpacity(0.6),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Form Fields
                      Column(
                        spacing: 16,
                        children: [
                          // New Password Field
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              CustomProfileFormField(
                                controller: _newPasswordController,
                                hintText: "New Password",
                                prefixIcon: FluentIcons.lock_closed_20_regular,
                                obscureText: !_isNewPasswordVisible,
                                validator: _validateNewPassword,
                                onChanged: (value) {
                                  // Trigger confirm password validation when new password changes
                                  if (_confirmPasswordController
                                      .text
                                      .isNotEmpty) {
                                    _formKey.currentState!.validate();
                                  }
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: IconButton(
                                  icon: Icon(
                                    _isNewPasswordVisible
                                        ? FluentIcons.eye_24_regular
                                        : FluentIcons.eye_off_24_regular,
                                    size: 20,
                                    color: context
                                        .colors
                                        .textTheme
                                        .bodyMedium!
                                        .color!,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isNewPasswordVisible =
                                          !_isNewPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          // Confirm Password Field
                          Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              CustomProfileFormField(
                                controller: _confirmPasswordController,
                                hintText: "Confirm Password",
                                prefixIcon: FluentIcons.lock_closed_20_regular,
                                obscureText: !_isConfirmPasswordVisible,
                                validator: _validateConfirmPassword,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: IconButton(
                                  icon: Icon(
                                    _isConfirmPasswordVisible
                                        ? FluentIcons.eye_24_regular
                                        : FluentIcons.eye_off_24_regular,
                                    size: 20,
                                    color: context
                                        .colors
                                        .textTheme
                                        .bodyMedium!
                                        .color!,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isConfirmPasswordVisible =
                                          !_isConfirmPasswordVisible;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Change Password Button
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: _changePassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    context.colors.primaryColorLight,
                                foregroundColor: context.colors.primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                              child: const Text(
                                'Change Password',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
