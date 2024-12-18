import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class CallPage extends StatelessWidget {
  const CallPage({Key? key, required this.callID, required this.user_name, required this.user_id}) : super(key: key);
  final String callID;
  final String user_name;
  final String user_id;

  @override
  Widget build(BuildContext context) {
    return ZegoUIKitPrebuiltCall(
      appID: 1020905435, // Fill in the appID that you get from ZEGOCLOUD Admin Console.
      appSign: "fca7cde7e5b6bf19ee9ab4725be997b0e816f1cc23c8dd0279ea9badf96ca6b2", // Fill in the appSign that you get from ZEGOCLOUD Admin Console.
      userID: user_id,
      userName: user_name,
      callID: callID,
      // You can also use groupVideo/groupVoice/oneOnOneVoice to make more types of calls.
      config: ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall(),
    );
  }
}


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
        _makeCall(); // Make the call when timer expires
      } else {
        setState(() {
          countdown--;
        });
      }
    });
  }

  // Function to check internet connection and make call
  // Function to check internet connection and make a call
  Future<void> _makeCall() async {
    const number = '7989372523'; // Replace with the actual emergency number


    // Get the connectivity status
    ConnectivityResult connectivity = (await Connectivity().checkConnectivity())[0];

    if (connectivity != ConnectivityResult.none) {
      // If internet is available, initiate WhatsApp video call
      final prefs = await SharedPreferences.getInstance();
      final email = prefs.getString("email") ?? " ";
      final user_id = prefs.getString("hashedEmail") ?? " ";
      CallPage(callID: '123', user_name: email, user_id: user_id);
    } else {
      // If no internet, make a regular phone call
      bool? result = await FlutterPhoneDirectCaller.callNumber(number);
      if (!result!) {
        debugPrint('Call could not be initiated.');
      }
    }
  }


  // Function to launch WhatsApp for a video call

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
