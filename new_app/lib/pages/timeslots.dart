import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TimeSlotsPage extends StatefulWidget {
  const TimeSlotsPage({Key? key}) : super(key: key);

  @override
  _TimeSlotsPageState createState() => _TimeSlotsPageState();
}

class _TimeSlotsPageState extends State<TimeSlotsPage> {
  Map<String, bool> timeSlots = {};
  String? username;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      username = args['username'];
      _fetchTimeSlots(username!);
    }
  }

  Future<void> _fetchTimeSlots(String username) async {
    try {
      final response = await http
          .post(Uri.parse('http://192.168.29.107:3000/user/findBarber'), body: {
        'Username': username,
      });

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody['success']) {
          final Map<String, dynamic> slots =
              Map<String, dynamic>.from(responseBody['data']);

          // Convert slot values from String to Bool
          final convertedSlots = slots.map((key, value) {
            return MapEntry(key, value.toString() == 'true');
          });

          setState(() {
            timeSlots = convertedSlots;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(
                    'Problem fetching time slots: ${responseBody['message']}')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Time Slots'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        padding: EdgeInsets.all(16),
        itemCount: timeSlots.length,
        itemBuilder: (context, index) {
          final timeSlot = timeSlots.keys.elementAt(index);
          final isBooked = timeSlots[timeSlot]!;
          return Container(
            color: isBooked ? Colors.blue[300] : Colors.blue[900],
            child: Center(
              child: Text(
                '$timeSlot\n${isBooked ? 'Booked' : 'Available'}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isBooked ? Colors.black : Colors.white,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
