import 'package:bekia/main.dart';
import 'package:bekia/views/profile_screen/widgets/circler_profile_image.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({super.key});

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreenState();
}

class _ProfileSettingScreenState extends State<ProfileSettingScreen> {
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
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  // Profile Image with Edit Button
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
                            onTap: () {
                              // Edit profile image logic
                            },
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
                  const SizedBox(height: 12),

                  // Name
                  Text(
                    'Sameh Khalil',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: context.colors.textTheme.bodyMedium!.color!,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Email
                  Text(
                    'sameh.eldeqwy@gmail.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: context.colors.textTheme.bodyMedium!.color!,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Form Fields
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      children: [
                        // User Name Field
                        Container(
                          decoration: BoxDecoration(
                            color: context.colors.cardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              hintText: 'User Name',
                              hintStyle: TextStyle(
                                color:
                                    context.colors.textTheme.bodyMedium!.color!,
                              ),
                              prefixIcon: Icon(
                                FluentIcons.person_24_regular,
                                color:
                                    context.colors.textTheme.bodyMedium!.color!,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Email Field
                        Container(
                          decoration: BoxDecoration(
                            color: context.colors.cardColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              hintText: 'email',
                              hintStyle: TextStyle(
                                color:
                                    context.colors.textTheme.bodyMedium!.color!,
                              ),
                              prefixIcon: Icon(
                                FluentIcons.mail_48_regular,
                                color:
                                    context.colors.textTheme.bodyMedium!.color!,
                              ),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Save Changes Button
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () {
                              // Save changes logic
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: context.colors.primaryColorLight,
                              foregroundColor: context.colors.primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Save Changes',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
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
