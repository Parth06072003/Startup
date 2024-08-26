import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_app/utils/routes.dart';
import 'cards.dart'; // Import your UserCard widget file

class Applications extends StatefulWidget {
  const Applications({super.key});

  @override
  _ApplicationsState createState() => _ApplicationsState();
}

class _ApplicationsState extends State<Applications> {
  List<User> users = [];
  String? loggedInUsername;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      loggedInUsername = args['username'];
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchApplications();
  }

  Future<void> _fetchApplications() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.29.107:3000/user/getallUser'),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody['success']) {
          final List<dynamic> userList = responseBody['data'];
          setState(() {
            users = userList.map((user) {
              return User(
                username: user['Username'],
                email: user['Email'],
                service: user['Service'],
                timeSlot: user['TimeSlot'],
                status: user['status'],
              );
            }).toList();
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Problem in fetching Data: ${responseBody['message']}')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _updateTimeSlot(
      String username, String timeSlot) async {
    final response = await http.post(
      Uri.parse('http://192.168.29.107:3000/user/updatetimeslot'),
      headers: {
        'Content-Type': 'application/json', // Set the content type to JSON
      },
      body: jsonEncode({
        'username': loggedInUsername,
        'timeSlot': timeSlot,
      }),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Time allotted: ${responseBody['message']}')),
        );
        _updateApplication(username, "accepted");
        _fetchApplications();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Time already allotted: ${responseBody['message']}')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${response.reasonPhrase}')),
      );
    }
  }

  Future<void> _updateApplication(String username, String status) async {
    print('Sending request for rejecting the application for: $username');

    final response = await http.post(
      Uri.parse('http://192.168.29.107:3000/user/updateStatus'),
      headers: {
        'Content-Type': 'application/json', // Set the content type to JSON
      },
      body: jsonEncode({
        'Username': username,
        'status': status,
      }),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      if (responseBody['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Application ${status}: ${responseBody['message']}')),
        );
        _fetchApplications(); // Refresh the list after rejecting the application
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Problem in rejecting the application: ${responseBody['message']}')),
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
        title: Text("Applications"),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];

          return UserCard(
            user: user,
            onAccept: () {
              _updateTimeSlot(user.username, user.timeSlot);
            },
            onReject: () {
              _updateApplication(user.username, "rejected");
            },
          );
        },
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Welcome, ${loggedInUsername ?? "User"}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('TimeSlots'),
              onTap: ()
                {Navigator.pushNamed(context, MyRoutes.timeSlotRoute,        arguments: {
          'username': loggedInUsername,
        },);}
               ,
            ),
          ],
        ),
      ),
    );
  }
}
