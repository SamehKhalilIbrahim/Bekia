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

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _emailController;

  @override
  void initState() {
    _nameController = TextEditingController(text: 'Sameh Khalil');
    _emailController = TextEditingController(text: "sameh.eldegwy@gmail.com");
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
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
                onPressed: () => Navigator.pop(context),
              ),
            ),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Profile Image
                  SizedBox(
                    width: 140,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const CirclerProfileImage(showBorder: false),
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
                                  strokeAlign: BorderSide.strokeAlignOutside,
                                  color: context.colors.scaffoldBackgroundColor,
                                  width: 1.5,
                                ),
                              ),
                              child: Icon(
                                FluentIcons.edit_28_regular,
                                size: 22,
                                color: context.colors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

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
                                  // 🔥 VALIDATE FORMS HERE
                                  if (_formKey.currentState!.validate()) {
                                    // Save changes logic
                                  } else {
                                    // Show error messages
                                  }
                                },
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
          ],
        ),
      ),
    );
  }
}
