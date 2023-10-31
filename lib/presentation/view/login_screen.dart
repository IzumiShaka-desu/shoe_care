import 'dart:math';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shoe_care/app/utils/color_utils.dart';
import 'package:shoe_care/presentation/viewmodel/auth_viewmodel.dart';

enum LoginType {
  customer,
  mitra,
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.loginType,
  });
  final LoginType loginType;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // login screen with form to input email and password
    return Scaffold(
      appBar: AppBar(
        title: Text("Login ${widget.loginType.name}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset(
                "images/welcoming.png",
              ),
              Text(
                "Hello ${widget.loginType.name}!",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              const Text(
                "Please input your credential to continue",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Email tidak boleh kosong";
                    }
                    final regex = RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$");
                    if (!regex.hasMatch(value)) {
                      return "Email tidak valid";
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password tidak boleh kosong";
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ElevatedButton(
                        onPressed: () {
                          switch (widget.loginType) {
                            case LoginType.customer:
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthViewmodel>().login(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      loginType: widget.loginType,
                                      onSuccess: (result) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(result),
                                          ),
                                        );
                                        context
                                            .read<AuthViewmodel>()
                                            .fetchProfile();
                                        context.go("/customer");
                                      },
                                      onError: (error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(error),
                                          ),
                                        );
                                      },
                                    );
                              }
                              break;
                            case LoginType.mitra:
                              if (_formKey.currentState!.validate()) {
                                context.read<AuthViewmodel>().login(
                                      email: _emailController.text,
                                      password: _passwordController.text,
                                      loginType: widget.loginType,
                                      onSuccess: (result) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(result),
                                          ),
                                        );
                                        context.go("/mitra");
                                        context
                                            .read<AuthViewmodel>()
                                            .fetchProfile();
                                      },
                                      onError: (error) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(error),
                                          ),
                                        );
                                      },
                                    );
                              }
                              break;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: fromHex("#192633"),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // dont have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                    onPressed: () {
                      context.push("/register", extra: widget.loginType);
                    },
                    child: const Text("Register"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
