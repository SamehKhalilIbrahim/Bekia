import 'dart:ui';
import 'package:bekia/main.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  final ScrollController scrollController;

  const ProfileScreen({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 🌫️ Background (Image + Blur + Gradient)
        Positioned.fill(
          child: Stack(
            children: [
              // Background image
              Image.asset("assets/images/profile.jpg", fit: BoxFit.cover),

              // Blur layer
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                child: Container(
                  color: Colors.black.withOpacity(
                    0.15,
                  ), // optional soft overlay
                  height: context.height * 0.5,
                ),
              ),

              // Fade gradient
              Container(
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
            ],
          ),
        ),

        CustomScrollView(
          controller: scrollController,
          slivers: [
            SliverToBoxAdapter(child: const SizedBox(height: 230)),

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
                      offset: const Offset(0, -50),
                      child: Container(
                        width: 110,
                        height: 110,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: context.colors.scaffoldBackgroundColor,
                            width: 5,
                          ),
                          image: const DecorationImage(
                            image: AssetImage("assets/images/profile.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),

                    // User Info
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
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    // Menu Tiles
                    _buildTile(
                      icon: Icons.person_outline,
                      title: "Profile Settings",
                      onTap: () {},
                    ),
                    _buildTile(
                      icon: Icons.lock_outline,
                      title: "Change Password",
                      onTap: () {},
                    ),
                    _buildDarkModeTile(),
                    _buildTile(
                      icon: Icons.support_agent_outlined,
                      title: "Support",
                      onTap: () {},
                    ),

                    const SizedBox(height: 20),

                    // Logout Button
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2D6C4),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Logout",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.logout_outlined),
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
      ],
    );
  }

  // 🔹 Menu Tile Widget
  static Widget _buildTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: const Color(0xFFECECE1),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: Colors.black87),
            const SizedBox(width: 20),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // 🔸 Dark Mode Tile
  static Widget _buildDarkModeTile() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFECECE1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.dark_mode_outlined, size: 22),
          const SizedBox(width: 20),
          const Expanded(
            child: Text("Dark Mode", style: TextStyle(fontSize: 16)),
          ),
          Switch(
            value: false,
            onChanged: (v) {},
            activeColor: Colors.redAccent,
          ),
        ],
      ),
    );
  }
}
