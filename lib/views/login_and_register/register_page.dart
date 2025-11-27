import 'package:bekia/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/ui/animations/fade_animation.dart';
import '../../core/ui/themes/app_color.dart';
import '../../cubit/auth_cubit/auth_bloc.dart';
import '../../cubit/auth_cubit/auth_event.dart';
import '../../cubit/auth_cubit/auth_states.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  bool secureText = true;

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(context);
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Form(
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
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    // USERNAME
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
                                        controller: usernameController,
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.person,
                                            color: Theme.of(
                                              context,
                                            ).primaryColorLight,
                                          ),
                                          hintText: "Username",
                                          border: InputBorder.none,
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Username is required";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),

                                    // EMAIL
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
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Email is required";
                                          } else if (!emailRegExp.hasMatch(
                                            value.trim(),
                                          )) {
                                            return "Enter a valid email";
                                          }
                                          return null;
                                        },
                                      ),
                                    ),

                                    // PASSWORD
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
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Password is required";
                                          } else if (value.length < 8) {
                                            return "Password must be at least 8 characters";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.lock,
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
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Theme.of(
                                                context,
                                              ).primaryColorLight,
                                            ),
                                          ),
                                          hintText: "Password",
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),

                                    // CONFIRM PASSWORD
                                    Container(
                                      padding: const EdgeInsets.only(
                                        top: 3,
                                        bottom: 3,
                                      ),
                                      child: TextFormField(
                                        controller: confirmPasswordController,
                                        obscureText: secureText,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Please confirm password";
                                          } else if (value !=
                                              passwordController.text) {
                                            return "Passwords do not match";
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.lock_outline,
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
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Theme.of(
                                                context,
                                              ).primaryColorLight,
                                            ),
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

                          // SIGN UP BUTTON
                          FadeAnimation(
                            delay: 0.9,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.width * 0.1,
                                vertical: 14.0,
                              ),
                              child: BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  final loading = state is AuthLoading;

                                  return ElevatedButton(
                                    onPressed: loading
                                        ? null
                                        : () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              context.read<AuthBloc>().add(
                                                RegisterRequested(
                                                  email: emailController.text
                                                      .trim(),
                                                  password:
                                                      passwordController.text,
                                                  username: usernameController
                                                      .text
                                                      .trim(),
                                                ),
                                              );
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).primaryColorLight,
                                      minimumSize: const Size(
                                        double.infinity,
                                        50,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    child: loading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : const Text(
                                            "Sign Up",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                  );
                                },
                              ),
                            ),
                          ),

                          const SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
