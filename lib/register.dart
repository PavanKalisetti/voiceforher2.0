import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voiceforher/login_page.dart';
import 'package:voiceforher/services/FireStoreProfileServices.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';


class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for text fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _educationController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();


  final FirestoreProfileService firestoreProfileService = FirestoreProfileService();

  // Selected registration type
  String _registrationType = 'User';

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Registration method using Firebase
  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Show a loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(child: CircularProgressIndicator()),
        );

        // Register user with email and password
        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        String hashEmail(String email) {
          // Convert the email string to a list of bytes
          var bytes = utf8.encode(email);

          // Use SHA-256 to hash the email
          var digest = sha256.convert(bytes);

          // Return the hash as a hexadecimal string
          return digest.toString();
        }

        final prefs = await SharedPreferences.getInstance();

        String hashedEmail = hashEmail(_emailController.text);
        await prefs.setString('hashedEmail', hashedEmail);
        print('Registration type changed to: $_registrationType');
        if(_registrationType == 'User'){

          await prefs.setBool('authorized', false);
          print("i am in the user block");

          firestoreProfileService.addProfile(_nameController.text, _emailController.text, hashedEmail, _passwordController.text, _educationController.text, _mobileController.text, _roleController.text, _addressController.text,false);
        }
        else{
          await prefs.setBool('authorized', true);
          print("i am in the authority block");
          firestoreProfileService.addProfile(_nameController.text, _emailController.text,hashedEmail, _passwordController.text, _educationController.text, _mobileController.text, _roleController.text, _addressController.text,true);
        }


        // User successfully registered
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration Successful!')),

        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));

        // Additional fields can be saved in Firestore if required
        print('Registration Type: $_registrationType');
        print('Name: ${_nameController.text}');
        print('Email: ${_emailController.text}');
        if (_registrationType == 'User') {
          print('Education: ${_educationController.text}');
          print('Mobile: ${_mobileController.text}');
        } else {
          print('Role: ${_roleController.text}');
          print('Address: ${_addressController.text}');
        }
      } on FirebaseAuthException catch (e) {
        Navigator.of(context).pop(); // Close loading dialog

        // Display error message
        String message;
        if (e.code == 'email-already-in-use') {
          message = 'This email is already registered.';
        } else if (e.code == 'weak-password') {
          message = 'The password is too weak.';
        } else {
          message = 'An error occurred: ${e.message}';
        }
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration Page'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _registrationType = 'User';
                        });
                      },
                      child: Text('User',
                        style: TextStyle(
                        color: _registrationType == 'User' ? Colors.white70: Colors.black ,
                      ),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _registrationType == 'User' ? Colors.blue : Colors.white70,
                      ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _registrationType = 'Authority';
                        });
                      },
                      child: Text('Authority',style: TextStyle(
                        color: _registrationType == 'User' ? Colors.black :Colors.white70,
                      ),),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _registrationType == 'Authority' ? Colors.blue : Colors.white70,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^\S+@\S+\.\S+$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    } else if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                if (_registrationType == 'User') ...[
                  TextFormField(
                    controller: _educationController,
                    decoration: InputDecoration(
                      labelText: 'Education',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.school),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your education';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _mobileController,
                    decoration: InputDecoration(
                      labelText: 'Mobile Number',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your mobile number';
                      } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                        return 'Please enter a valid 10-digit mobile number';
                      }
                      return null;
                    },
                  ),
                ] else if (_registrationType == 'Authority') ...[
                  TextFormField(
                    controller: _roleController,
                    decoration: InputDecoration(
                      labelText: 'Role',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.work),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your role';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                ],
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(

                    onPressed: _registerUser,
                    child: Text('Register', style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      textStyle: TextStyle(fontSize: 18),
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
}
