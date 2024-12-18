import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voiceforher/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'homescreen.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference profiles = _firestore.collection('profiles');




class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  void _login() async {
    final CollectionReference profiles = _firestore.collection('profiles');
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnackbar("Please fill in all fields.");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Sign in with Firebase
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      _showSnackbar("Login successful!");

      // Fetch all profiles from Firestore
      final snapshot = await profiles.get();  // Fetch profiles collection

      // Loop through the profiles and check if the email matches
      bool isAno = false;
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['email'] == email) {  // Match the email
          print("the email is  ${data['email']}");

          isAno = data['isAuthority'] ?? false;  // Store isAno value
          print("the email is  ${data['isAuthority']} and the $isAno");
          break;  // Stop once we find the match
        }
      }

      // Save the 'isAno' value to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIN', true);
      await prefs.setBool('authorized', isAno);  // Save the 'isAno' value
      await prefs.setString("email", email);
      String hashEmail(String email) {
        // Convert the email string to a list of bytes
        var bytes = utf8.encode(email);

        // Use SHA-256 to hash the email
        var digest = sha256.convert(bytes);

        // Return the hash as a hexadecimal string
        return digest.toString();
      }
      String HashedEmail = hashEmail(email);
      await prefs.setString("hashedEmail", HashedEmail);

      // Navigate to the next screen
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => Homescreen()));
    } on FirebaseAuthException catch (e) {
      _showSnackbar(_handleFirebaseAuthError(e.code));
    } catch (e) {
      _showSnackbar("An unexpected error occurred. Please try again.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  String _handleFirebaseAuthError(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return "No user found for that email.";
      case 'wrong-password':
        return "Incorrect password. Please try again.";
      case 'invalid-email':
        return "Invalid email address.";
      case 'user-disabled':
        return "This user has been disabled.";
      default:
        return "An unknown error occurred.";
    }
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              Center(
                child: Image.asset(
                  'assets/images/login_logo.png', // Replace with your logo path
                  height: 100,
                  width: 100,
                ),
              ),
              const SizedBox(height: 30),
              // Email Input
              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Password Input
              TextField(
                controller: _passwordController,
                keyboardType: TextInputType.text,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Login Button
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  backgroundColor: Colors.deepPurpleAccent.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                  "Log In",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
              // Divider
              const Divider(thickness: 1),
              const SizedBox(height: 20),
              // Sign in with Google Button
              OutlinedButton.icon(
                onPressed: () {
                  // Handle Google sign-in logic
                  _showSnackbar("Google Sign-In is under development.");
                },
                icon: Image.asset(
                  'assets/images/google_login.png', // Replace with your Google logo path
                  height: 24,
                  width: 24,
                ),
                label: const Text(
                  "Continue with Google",
                  style: TextStyle(fontSize: 16),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  side: const BorderSide(color: Colors.black),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Sign-up Text
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don’t have an account?"),
                  TextButton(
                    onPressed: () {
                      // Navigate to registration screen
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (BuildContext context) =>  RegistrationPage()),
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(color: Colors.deepPurpleAccent),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
