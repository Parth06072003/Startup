import 'package:flutter/material.dart';

// Updated User model
class User {
  final String username;
  final String email;
  final String service;
  final String timeSlot;
  final String status;

  User({
    required this.username,
    required this.email,
    required this.service,
    required this.timeSlot,
    required this.status,
  });
}

// UserCard widget to display individual user information with buttons
class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  UserCard({
    required this.user,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListTile(
            title: Text(user.username,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(user.email),
          ),
          ListTile(
            title: Text(user.service),
            subtitle: Text(user.timeSlot),
          ),
          OverflowBar(
            alignment: MainAxisAlignment.end,
            children: <Widget>[
              ElevatedButton(
                onPressed: user.status == 'pending' ? onAccept : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.blue, // Background color of the button
                ),
                child: Text('Accept', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(width: 8), // Space between buttons
              ElevatedButton(
                onPressed: user.status == 'pending' ? onReject : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red, // Background color of the button
                ),
                child: Text('Reject', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
