import 'package:bekia/main.dart';
import 'package:flutter/material.dart';

import '../../core/ui/animations/fade_animation.dart';
import '../../core/ui/themes/app_color.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  bool secureText = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Container(
          width: context.width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              colors: [
                Theme.of(context).primaryColorLight,
                AppColor.bodySecondaryColor,
                AppColor.bodyPrimaryColor,
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeAnimation(
                      delay: 0.6,
                      child: Text(
                        "Sign Up",
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ),
                    const SizedBox(height: 5),
                    FadeAnimation(
                      delay: 0.7,
                      child: Text(
                        "Create your account",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60),
                    ),
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        FadeAnimation(
                          delay: 0.8,
                          child: Padding(
                            padding: const EdgeInsets.all(20),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).secondaryHeaderColor,
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Color.fromARGB(142, 245, 102, 59),
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 3,
                                      bottom: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey[200]!,
                                        ),
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: nameController,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Theme.of(
                                            context,
                                          ).primaryColorLight,
                                        ),
                                        hintText: "Name",
                                        border: InputBorder.none,
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter your name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 3,
                                      bottom: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey[200]!,
                                        ),
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: emailController,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.email,
                                          color: Theme.of(
                                            context,
                                          ).primaryColorLight,
                                        ),
                                        hintText: "Email",
                                        border: InputBorder.none,
                                      ),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter your email';
                                        } else if (!emailRegExp.hasMatch(
                                          value,
                                        )) {
                                          if (!value.contains("@gmail.com")) {
                                            return "Your email must have '@gmail.com'";
                                          } else {
                                            return 'Enter a valid email';
                                          }
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 3,
                                      bottom: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      border: Border(
                                        bottom: BorderSide(
                                          color: Colors.grey[200]!,
                                        ),
                                      ),
                                    ),
                                    child: TextFormField(
                                      controller: passwordController,
                                      obscureText: secureText,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please enter password';
                                        } else if (value.length < 8) {
                                          return 'Password must be at least 8 characters long';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.key_rounded,
                                          color: Theme.of(
                                            context,
                                          ).primaryColorLight,
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              secureText = !secureText;
                                            });
                                          },
                                          icon: Icon(
                                            secureText
                                                ? Icons.visibility_rounded
                                                : Icons.visibility_off_rounded,
                                            color: Theme.of(
                                              context,
                                            ).primaryColorLight,
                                          ),
                                          tooltip: 'Toggle Obscure Text',
                                        ),
                                        hintText: "Password",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.only(
                                      top: 3,
                                      bottom: 3,
                                    ),
                                    child: TextFormField(
                                      controller: confirmPasswordController,
                                      obscureText: secureText,
                                      enableSuggestions: false,
                                      autocorrect: false,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Please confirm your password';
                                        } else if (value !=
                                            passwordController.text) {
                                          return 'Passwords do not match';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.key_rounded,
                                          color: Theme.of(
                                            context,
                                          ).primaryColorLight,
                                        ),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              secureText = !secureText;
                                            });
                                          },
                                          icon: Icon(
                                            secureText
                                                ? Icons.visibility_rounded
                                                : Icons.visibility_off_rounded,
                                            color: Theme.of(
                                              context,
                                            ).primaryColorLight,
                                          ),
                                          tooltip: 'Toggle Obscure Text',
                                        ),
                                        hintText: "Confirm Password",
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        FadeAnimation(
                          delay: 0.9,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: context.width * 0.1,
                              vertical: 14.0,
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Placeholder(),
                                    ),
                                  );
                                } else {
                                  // print("Not Valid");
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(
                                  context,
                                ).primaryColorLight,
                                minimumSize: Size(context.width * 0.5, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              child: const Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
