import 'dart:io';

import 'package:qr_earth/handlers/handle_login.dart';
import 'package:qr_earth/network/api_client.dart';
import 'package:qr_earth/utils/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  final String? username;
  final String? message;
  const LoginPage({super.key, this.username, this.message});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _loginFormKey = GlobalKey<FormState>();
  bool _showPassowrd = false;
  bool _isLoading = false;
  bool _userNotFound = false;
  bool _wrongPassword = false;

  @override
  void initState() {
    super.initState();
    _usernameController.text = widget.username ?? "";
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSnackBar();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Stack(
          children: [
            Form(
              key: _loginFormKey,
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Welcome Back 👋",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Hello there, login to continue",
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
                        labelText: "Username or Email",
                        hintText: "Enter your username or email",
                        prefixIcon: Icon(Icons.alternate_email_rounded),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "username or email is required";
                        }
                        if (_userNotFound) {
                          return "User not found";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: !_showPassowrd,
                      decoration: InputDecoration(
                        labelText: "Password",
                        hintText: "Enter your Password",
                        prefixIcon: const Icon(
                          Icons.numbers,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassowrd
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _showPassowrd = !_showPassowrd;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password is required";
                        }
                        if (_wrongPassword) {
                          return "Wrong Passoword";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.replaceNamed(
                              "signup",
                              queryParameters:
                                  _usernameController.text.isValidEmail
                                      ? {
                                          "email": _usernameController.text,
                                        }
                                      : {
                                          "username": _usernameController.text,
                                        },
                            );
                          },
                          child: const Text("Don't have an account?"),
                        ),
                        FilledButton(
                          onPressed: _login,
                          child: const Text("Log In"),
                        ),
                      ],
                    ),
                  ],
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

  void _login() async {
    FocusManager.instance.primaryFocus?.unfocus();

    _wrongPassword = false;
    _userNotFound = false;

    // trim
    _usernameController.text = _usernameController.text.trim().toLowerCase();
    _passwordController.text = _passwordController.text.trim();

    if (_loginFormKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      bool isEmail = _usernameController.text.isValidEmail;

      // final response = await http.post(
      //   Uri.parse("${AppConfig.serverBaseUrl}${ApiRoutes.login}"),
      //   headers: {
      //     "Content-Type": "application/json",
      //     "Accept": "application/json",
      //   },
      //   body: jsonEncode({
      //     "username": !isEmail ? _usernameController.text : "",
      //     "email": isEmail ? _usernameController.text : "",
      //     "phone_number": "",
      //     "password": _passwordController.text,
      //   }),
      // );

      final response = await ApiClient.login(
        username: !isEmail ? _usernameController.text : "",
        email: isEmail ? _usernameController.text : "",
        phoneNumber: "",
        password: _passwordController.text,
      );

      switch (response.statusCode) {
        case HttpStatus.ok:
          {
            return handleLogin(response.data);
          }
        case HttpStatus.notFound:
          {
            // User not found
            setState(() {
              _userNotFound = true;
              _isLoading = false;
            });
          }
          break;
        case HttpStatus.unauthorized:
          {
            // Wrong password
            setState(() {
              _wrongPassword = true;
              _isLoading = false;
            });
          }
          break;
        default:
          {
            // Something went wrong
            setState(() {
              _isLoading = false;
            });
          }
      }

      _loginFormKey.currentState!.validate();
    }
  }

  void showSnackBar() {
    if (widget.message != null && widget.message!.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.message!),
        ),
      );
    }
  }

  // void _loginSuccess(String body) async {
  //   Global.user.setFromJson(jsonDecode(body));

  //   var sharedpref = await SharedPreferences.getInstance();
  //   await sharedpref.setBool(SharedPrefKeys.isLoggedIn, true);
  //   await sharedpref.setString(SharedPrefKeys.userData, body);

  //   context.goNamed("home");
  // }
}
