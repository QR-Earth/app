import 'dart:io';

import 'package:qr_earth/network/api_client.dart';
import 'package:qr_earth/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpPage extends StatefulWidget {
  final String? username;
  final String? email;

  const SignUpPage({super.key, this.username, this.email});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confrimPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();

  final _signUpFormKey = GlobalKey<FormState>();

  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _isLoading = false;

  // reponse status
  bool _usernameAlreadyRegistered = false;
  bool _emailAlreadyRegistered = false;
  bool _phoneAlreadyRegistered = false;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.username ?? '';
    _emailController.text = widget.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Center(
        child: Stack(
          children: [
            Form(
              key: _signUpFormKey,
              child: SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Hello 👋",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Hello there, sign up to continue",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Username",
                          hintText: "Enter your username (no spaces)",
                          prefixIcon: Icon(Icons.alternate_email_rounded),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Username';
                          }
                          if (value.length < 4) {
                            return 'Username must be at least 4 characters long';
                          }
                          if (!value.isValidUsername) {
                            return 'Please Enter Valid Username';
                          }
                          if (_usernameAlreadyRegistered) {
                            _usernameAlreadyRegistered = false;
                            return 'Username already registered';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _fullNameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Full Name",
                          hintText: "Enter your full name",
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Full Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          hintText: 'Enter your email',
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty && _phoneController.text.isEmpty) {
                            return 'Both Email and Phone cannot be empty';
                          }
                          if (!value.isValidEmail) {
                            return 'Please Enter Valid Email';
                          }

                          if (_emailAlreadyRegistered) {
                            _emailAlreadyRegistered = false;
                            return 'Email already registered';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      const Center(
                          child: Text(
                        "Or",
                        textAlign: TextAlign.center,
                      )),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: 'Enter your phone number',
                          labelText: 'Phone',
                          prefixIcon: Icon(
                            Icons.phone,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty && _emailController.text.isEmpty) {
                            return 'Both Email and Phone cannot be empty';
                          }
                          if (value.length != 10) {
                            return 'Phone Number must be 10 characters long';
                          }
                          if (!value.isValidPhone) {
                            return 'Please Enter Valid Phone Number';
                          }
                          if (_phoneAlreadyRegistered) {
                            _phoneAlreadyRegistered = false;
                            return 'Phone Number already registered';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: !_showPassword,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: 'Enter your password',
                          labelText: 'Password',
                          prefixIcon: const Icon(
                            Icons.password,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please Enter Your Password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters long';
                          }
                          if (!value.isValidPassword) {
                            return """
Password must contain at least:
  - one upper case letter
  - one lower case letter
  - one number
  - one special character""";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _confrimPasswordController,
                        obscureText: !_showConfirmPassword,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          hintText: 'Re-enter your password',
                          labelText: 'Confirm Password',
                          prefixIcon: const Icon(
                            Icons.password,
                          ),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _showConfirmPassword = !_showConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _showConfirmPassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty &&
                              _passwordController.text.isNotEmpty) {
                            return 'Please Confirm Your Password';
                          }
                          if (value != _passwordController.text) {
                            return "Passwords don't match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              context.replaceNamed(
                                "login",
                                queryParameters: {
                                  'username':
                                      _usernameController.text.isNotEmpty
                                          ? _usernameController.text
                                          : _emailController.text,
                                },
                              );
                            },
                            child: const Text("Already have an account?"),
                          ),
                          FilledButton(
                            onPressed: _signUp,
                            child: const Text("Sign Up"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _signUp() async {
    FocusManager.instance.primaryFocus?.unfocus();

    // trim
    _usernameController.text = _usernameController.text.trim().toLowerCase();
    _fullNameController.text = _fullNameController.text.trim().toUpperCase();

    _emailController.text = _emailController.text.trim().toLowerCase();
    _phoneController.text = _phoneController.text.trim();

    _passwordController.text = _passwordController.text.trim();
    _confrimPasswordController.text = _confrimPasswordController.text.trim();

    if (_signUpFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final response = await ApiClient.signup(
        username: _usernameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        password: _passwordController.text,
        fullName: _fullNameController.text,
      );

      switch (response.statusCode) {
        case HttpStatus.created:
          {
            return _signUpSuccess();
          }
        case HttpStatus.conflict:
          {
            final error = response.data;
            if (error.contains('Username')) {
              _usernameAlreadyRegistered = true;
            }
            if (error.contains('Email')) {
              _emailAlreadyRegistered = true;
            }
            if (error.contains('Phone')) {
              _phoneAlreadyRegistered = true;
            }
            break;
          }
        default:
          {
            ScaffoldMessenger.of(context).clearSnackBars();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    "Unhandled Exception: ${response.statusCode} - ${response.data}"),
              ),
            );
          }
      }

      setState(() {
        _isLoading = false;
      });
      _signUpFormKey.currentState!.validate();
    }
  }

  void _signUpSuccess() async {
    // save user data
    context.pushNamed(
      "login",
      queryParameters: {
        "username": _usernameController.text,
        "messege": "Sign Up Successful, Please Login"
      },
    );
  }
}
