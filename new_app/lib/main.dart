import 'package:flutter/material.dart';
import 'package:new_app/pages/applications.dart';
import 'package:new_app/pages/home_page.dart';
import 'package:new_app/pages/login_page.dart';
import 'package:new_app/pages/signup_page.dart';
import 'package:new_app/pages/timeslots.dart';
import 'package:new_app/utils/routes.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: LoginPage(),
    routes: {
      MyRoutes.homeRoute: (context) => HomePage(),
      MyRoutes.loginRoute: (context) => LoginPage(),
      MyRoutes.signupRoute: (context) => SignupPage(),
      MyRoutes.applicationRoute: (context) => Applications(),
      MyRoutes.timeSlotRoute:(context) => TimeSlotsPage()

      // Add other routes here
    },
  ));
}
