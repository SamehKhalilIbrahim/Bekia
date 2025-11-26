import 'package:bekia/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/ui/animations/fade_animation.dart';
import '../../core/ui/animations/screen_transactions_animation.dart';
import '../../cubit/auth_cubit/auth_bloc.dart';
import '../../cubit/auth_cubit/auth_event.dart';
import '../../cubit/auth_cubit/auth_states.dart';
import '../home_screen/navigation.dart';
import 'register_page.dart';
import 'reset_password.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool secureText = true;
  bool rememberMe = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formkey = GlobalKey<FormState>();

  RegExp alphaNumeric = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacement(
              context,
              FadePageRoute(page: NavigationScreen()),
            );
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
          key: formkey,
          child: Container(
            width: context.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                colors: [
                  Theme.of(context).primaryColorLight,
                  Theme.of(context).scaffoldBackgroundColor,
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
                          "Login",
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                      ),
                      const SizedBox(height: 5),
                      FadeAnimation(
                        delay: 1.1,
                        child: Text(
                          "Welcome Back!",
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
                          const SizedBox(height: 50),
                          FadeAnimation(
                            delay: 0.7,
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).cardColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                        top: 5,
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
                                        cursorColor: Theme.of(
                                          context,
                                        ).primaryColorLight,
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
                                            return 'Please enter your email';
                                          } else if (!alphaNumeric.hasMatch(
                                            value,
                                          )) {
                                            if (!value.contains("@gmail.com")) {
                                              return "Your mail must has '@gmail.com'";
                                            } else {
                                              return 'Enter a valid mail';
                                            }
                                          }
                                          return null;
                                        },
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                        top: 3,
                                        bottom: 5,
                                      ),
                                      child: TextFormField(
                                        cursorColor: Theme.of(
                                          context,
                                        ).primaryColorLight,
                                        controller: passwordController,
                                        obscureText: secureText,
                                        enableSuggestions: false,
                                        autocorrect: false,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return 'Please enter password';
                                          } else {
                                            if (alphaNumeric.hasMatch(value) ||
                                                value.length <= 8) {
                                              return 'Enter a valid password';
                                            }
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
                                                  : Icons
                                                        .visibility_off_rounded,
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
                                  ],
                                ),
                              ),
                            ),
                          ),
                          FadeAnimation(
                            delay: 0.8,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  SmoothSlideRoute(
                                    page: PasswordRecoveryPage(),
                                  ),
                                );
                              },
                              child: const Text("Forget Password?"),
                            ),
                          ),
                          FadeAnimation(
                            delay: 0.8,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: context.width * 0.1,
                                vertical: 14.0,
                              ),
                              child: BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  final isLoading = state is AuthLoading;

                                  return ElevatedButton(
                                    onPressed: isLoading
                                        ? null
                                        : () {
                                            if (formkey.currentState!
                                                .validate()) {
                                              context.read<AuthBloc>().add(
                                                LoginRequested(
                                                  email: emailController.text
                                                      .trim(),
                                                  password:
                                                      passwordController.text,
                                                  rememberMe: rememberMe,
                                                ),
                                              );
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(
                                        context,
                                      ).primaryColorLight,
                                      minimumSize: Size(
                                        context.width * 0.5,
                                        50,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                    child: isLoading
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
                                            'Login',
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
                          FadeAnimation(
                            delay: 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/icons/gmail.png",
                                  height: context.height / 17,
                                ),
                                const SizedBox(width: 20),
                                Image.asset(
                                  "assets/images/icons/facebook.png",
                                  height: context.height / 17,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          FadeAnimation(
                            delay: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account?  ",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                      SmoothSlideRoute(page: RegisterPage()),
                                    );
                                  },
                                  child: Text(
                                    "Sign up",
                                    style: TextStyle(
                                      color: Theme.of(
                                        context,
                                      ).primaryColorLight,
                                    ),
                                  ),
                                ),
                              ],
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
      ),
    );
  }
}
