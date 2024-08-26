import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_app/utils/routes.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  String _selectedOption = 'User';

  // Dropdown items
  String? _selectedService;
  String? _selectedTimeslot;

  Future<void> _signup() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    final email = _emailController.text;

    final Map<String, String> bodyFields = {
      'Username': username,
      'Password': password,
      'Email': email,
      'Role': _selectedOption,
    };

    // Only add dropdown values if the role is 'User'
    if (_selectedOption == 'User') {
      if (_selectedService != null) {
        bodyFields['service'] = _selectedService!;
      }
      if (_selectedTimeslot != null) {
        bodyFields['timeslot'] = _selectedTimeslot!;
      }
    }

    print('Sending register request for user: $username with email:$email role: $_selectedOption');

    final response = await http.post(
      Uri.parse('http://192.168.29.107:3000/user/register'),
      body: bodyFields,
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        Navigator.pushNamed(context, MyRoutes.loginRoute);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Account: ${response.reasonPhrase}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Signup failed: ${responseBody['message']}')),
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
        title: Text('Signup Page'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                child: Column(
                  children: [
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
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Enter Email",
                        labelText: "Email",
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                          return 'Please enter a valid email';
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
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters long';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      obscureText: true,
                      controller: _confirmpasswordController,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        labelText: "Confirm Password",
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 60.0),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Radio<String>(
                          value: 'Barber',
                          groupValue: _selectedOption,
                          onChanged: (String? value) {
                            setState(() {
                              _selectedOption = value!;
                              // Reset the dropdowns when "Barber" is selected
                              _selectedService = null;
                              _selectedTimeslot = null;
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
              ),
              if (_selectedOption == 'User')
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  child: Column(
                    children: [
                      DropdownButtonFormField<String>(
                        value: _selectedService,
                        decoration: InputDecoration(
                          labelText: "Select Service",
                        ),
                        items: <String>['HairCutting', 'HairWashing', 'Shaving', 'Grooming']
                            .map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedService = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a service';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _selectedTimeslot,
                        decoration: InputDecoration(
                          labelText: "Select Timeslot",
                        ),
                        items: <String>[
                          "9:00", "9:30", "10:00", "10:30", "11:00",
                          "11:30", "12:00", "12:30", "13:00", "13:30",
                          "14:00", "14:30", "15:00", "15:30", "16:00",
                          "16:30", "17:00", "17:30", "18:00", "18:30",
                          "19:00", "19:30", "20:00",
                        ].map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedTimeslot = newValue;
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a timeslot';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 45.0),
                child: InkWell(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      _signup();
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
                        'Signup',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, MyRoutes.loginRoute);
                },
                child: Text.rich(
                  TextSpan(
                    text: "Already Have An Account? ",
                    style: TextStyle(fontSize: 16),
                    children: [
                      TextSpan(
                        text: "Login",
                        style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmpasswordController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }
}
