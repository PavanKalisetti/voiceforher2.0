import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     theme: ThemeData.light(),
//     home: EmergencyHelpScreen(),
//   ));
// }

class EmergencyHelpScreen extends StatefulWidget {
  const EmergencyHelpScreen({super.key});

  @override
  State<EmergencyHelpScreen> createState() => _EmergencyHelpScreenState();
}

class _EmergencyHelpScreenState extends State<EmergencyHelpScreen> {
  int countdown = 5; // Start countdown from 5 seconds
  bool timerExpired = false;

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (countdown == 0) {
        setState(() {
          timerExpired = true;
        });
        timer.cancel();
        _callNumber(); // Make the call when timer expires
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }

  Future<void> _callNumber() async {
    const number = '7989372523'; // Replace with the actual emergency number
    bool? result = await FlutterPhoneDirectCaller.callNumber(number);
    if (!result!) {
      debugPrint('Call could not be initiated.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: timerExpired ? Colors.red : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Emergency Help',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Timer Circle with Countdown
            Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                color: timerExpired ? Colors.red[100] : Colors.purple[100],
                shape: BoxShape.circle,
                border: Border.all(
                  color: timerExpired ? Colors.red : Colors.purple,
                  width: 4,
                ),
              ),
              child: Center(
                child: Text(
                  '$countdown',
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: timerExpired ? Colors.red : Colors.purple,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Sharing Your Location Text
            Text(
              'Sharing Your Location',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: timerExpired ? Colors.white : Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Notifying the police and your emergency contacts',
              style: TextStyle(
                fontSize: 14,
                color: timerExpired ? Colors.white70 : Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 50),
            // Cancel and Go Ahead Buttons
            ElevatedButton(
              onPressed: () {
                setState(() {
                  countdown = 5;
                  timerExpired = false;
                  startCountdown();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              ),
              child: const Text('Cancel Request'),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                debugPrint('Go Ahead Pressed');
              },
              child: Text(
                'Go Ahead',
                style: TextStyle(
                  color: timerExpired ? Colors.white : Colors.purple,
                  fontSize: 16,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}