import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../custom_widgets/dot_slide.dart';
import '../login_and_register/login_page.dart';
import 'on_boarding_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int currentIndex = 0;

  final List<OnboardingModel> onboardingData = [
    OnboardingModel(
      title: "Welcome to Bekia",
      description: "Your one-stop shop for all your needs.",
      imagePath: "assets/images/onboarding/welcome.svg",
    ),
    OnboardingModel(
      title: "Discover Amazing Products",
      description:
          "Browse through a wide range of products at unbeatable prices.",
      imagePath: "assets/images/onboarding/shopping.svg",
    ),
    OnboardingModel(
      title: "Fast and Secure Checkout",
      description: "Experience a seamless and secure checkout process.",
      imagePath: "assets/images/onboarding/pay.svg",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: onboardingData.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingScreen(
                title: onboardingData[index].title,
                description: onboardingData[index].description,
                imagePath: onboardingData[index].imagePath,
              );
            },
          ),
          Positioned(
            bottom: 30,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DotSlide(data: onboardingData, currentIndex: currentIndex),
                _customCupertinoButton(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _customCupertinoButton(BuildContext context) {
    double progress = (currentIndex + 1) / onboardingData.length;
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {
        if (currentIndex == onboardingData.length - 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        } else {
          _controller.nextPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              value: progress,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColorLight,
              ),
              backgroundColor: Colors.grey[300],
            ),
          ),
          CircleAvatar(
            radius: 25,
            backgroundColor: Theme.of(context).primaryColorLight,
            child: Icon(
              currentIndex == onboardingData.length - 1
                  ? Icons.check
                  : Icons.arrow_forward,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingModel {
  final String title;
  final String description;
  final String imagePath;

  OnboardingModel({
    required this.title,
    required this.description,
    required this.imagePath,
  });
}
