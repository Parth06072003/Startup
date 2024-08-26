import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:new_app/utils/routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _selectedOption = 'User';
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    print(
        'Sending login request for user: $username with role: $_selectedOption');
    final response = await http.post(
      Uri.parse('http://192.168.29.107:3000/user/login'),
      body: {
        'Username': username,
        'Password': password,
        'Role': _selectedOption,
      },
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        if (_selectedOption == "Barber") {
          Navigator.pushReplacementNamed(
            context,
            MyRoutes.applicationRoute,
            arguments: {
              'username': username,
            },
          );
        } else {
          Navigator.pushReplacementNamed(
            context,
            MyRoutes.homeRoute,
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${responseBody['message']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.reasonPhrase}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Page"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 40),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    hintText: "Enter Username",
                    labelText: "Username",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: "Enter Password",
                    labelText: "Password",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Side by Side Radio Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Barber',
                          groupValue: _selectedOption,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedOption = value!;
                            });
                          },
                        ),
                        const Text('Barber'),
                      ],
                    ),
                    SizedBox(width: 20),
                    Row(
                      children: [
                        Radio<String>(
                          value: 'User',
                          groupValue: _selectedOption,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedOption = value!;
                            });
                          },
                        ),
                        const Text('User'),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _login();
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, MyRoutes.signupRoute);
                  },
                  child: Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(fontSize: 16),
                      children: [
                        TextSpan(
                          text: "Signup",
                          style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ],
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

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
