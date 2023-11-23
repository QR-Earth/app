import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:the_eco_club/utils/constants.dart';

extension ExtString on String {
  bool get isValidEmail {
    final emailRegExp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
    return emailRegExp.hasMatch(this);
  }

  bool get isValidUsername {
    final usernameRegExp = RegExp(r"^[a-zA-Z0-9]{4,}$");
    return usernameRegExp.hasMatch(this);
  }

  bool get isValidName {
    final nameRegExp =
        RegExp(r"^\s*([A-Za-z]{1,}([\.,] |[-']| ))+[A-Za-z]+\.?\s*$");
    return nameRegExp.hasMatch(this);
  }

  bool get isValidPassword {
    final passwordRegExp = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\><*~]).{8,}/pre>');
    return passwordRegExp.hasMatch(this);
  }

  bool get isValidPhone {
    final phoneRegExp = RegExp(r"^\+?[0-9]{10}$");
    return phoneRegExp.hasMatch(this);
  }
}

class SignUpPage extends StatefulWidget {
  final String? email;
  final String? phone;
  final String? username;

  const SignUpPage({super.key, this.email, this.phone, this.username});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confrimPasswordController =
      TextEditingController();
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
    _phoneController.text = widget.phone ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Form(
                key: _signUpFormKey,
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.account_circle,
                          size: 100, color: Colors.lightGreen),
                      const Text(
                        'Sign up',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Username',
                          prefixIcon: Icon(
                            Icons.account_box,
                          ),
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
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Email (Optional)',
                          prefixIcon: Icon(
                            Icons.email,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            if (_phoneController.text.isEmpty) {
                              return 'Both Email and Phone cannot be empty';
                            }
                          } else {
                            if (!value.isValidEmail) {
                              return 'Please Enter Valid Email';
                            }
                          }
                          if (_emailAlreadyRegistered) {
                            _emailAlreadyRegistered = false;
                            return 'Email already registered';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone (Optional)',
                          prefixIcon: Icon(
                            Icons.phone,
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            if (_emailController.text.isEmpty) {
                              return 'Both Email and Phone cannot be empty';
                            }
                          } else {
                            if (value.length != 10) {
                              return 'Phone Number must be 10 characters long';
                            }
                            if (!value.isValidPhone) {
                              return 'Please Enter Valid Phone Number';
                            }
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
                          border: const OutlineInputBorder(),
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
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _confrimPasswordController,
                        obscureText: !_showConfirmPassword,
                        keyboardType: TextInputType.visiblePassword,
                        decoration: InputDecoration(
                          border: const OutlineInputBorder(),
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
                          if (value!.isEmpty) {
                            if (_passwordController.text.isNotEmpty) {
                              return 'Please Confirm Your Password';
                            }
                          }
                          if (value != _passwordController.text) {
                            return "Passwords don't match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: () => context.go('/login/username'),
                            child: const Text('Log in'),
                          ),
                          FilledButton(
                            onPressed: _signup,
                            child: const Text('Sign up'),
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

  void _signup() async {
    if (_signUpFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final response = await http.post(
        Uri.parse('$BASEURL/create_user'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(
          {
            'username': _usernameController.text,
            if (_phoneController.text.isNotEmpty)
              'phone_number': _phoneController.text,
            if (_emailController.text.isNotEmpty)
              'email': _emailController.text,
            'hashed_password': _passwordController.text,
          },
        ),
      );

      if (response.statusCode == 201) {
        if (context.mounted) context.go('/login/username');
      } else {
        if (response.statusCode == 400) {
          final error = response.body;
          if (error.contains('Username')) {
            _usernameAlreadyRegistered = true;
          }
          if (error.contains('Email')) {
            _emailAlreadyRegistered = true;
          }
          if (error.contains('Phone')) {
            _phoneAlreadyRegistered = true;
          }
        }
      }
      setState(() {
        _isLoading = false;
      });
      _signUpFormKey.currentState!.validate();
    }
  }
}
