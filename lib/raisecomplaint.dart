import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voiceforher/services/firestore.dart';

class Raisecomplaint extends StatefulWidget {
  const Raisecomplaint({super.key});

  @override
  State<Raisecomplaint> createState() => _RaisecomplaintState();
}

class _RaisecomplaintState extends State<Raisecomplaint> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _issueOccurredOnController = TextEditingController();
  final TextEditingController _issueOccurredAtController = TextEditingController();
  bool _wantAnonymous = false;
  final FirestoreService firestoreService = FirestoreService();
  late final hashedEmail;

  Future<void> submitFields() async {
    final prefs = await SharedPreferences.getInstance();
    hashedEmail = prefs.getString('hashedEmail') ?? " ";
    // firestoreService.addComplaint(_nameController.text,hashedEmail!, _issueOccurredOnController.text,_subjectController.text, _descriptionController.text, _categoryController.text, _issueOccurredAtController.text, _wantAnonymous, false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    submitFields();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Raise a Complaint',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue.shade700,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ColoredBox(
        color: Colors.blue.shade50,
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Fill out the details below:',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildStyledTextField(
                    controller: _nameController,
                    label: 'Name',
                    hint: 'Enter your full name',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildStyledTextField(
                    controller: _subjectController,
                    label: 'Subject',
                    hint: 'Enter the subject',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the subject';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildStyledTextField(
                    controller: _descriptionController,
                    label: 'Description',
                    hint: 'Describe the incident',
                    maxLines: 5,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter a description';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildStyledTextField(
                    controller: _categoryController,
                    label: 'Category',
                    hint: 'Enter the category (e.g., harassment, stalking)',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the category';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildStyledTextField(
                    controller: _issueOccurredOnController,
                    label: 'Issue Occurred On',
                    hint: 'Enter the date (e.g., YYYY-MM-DD)',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the date of the incident';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  _buildStyledTextField(
                    controller: _issueOccurredAtController,
                    label: 'Issue Occurred At',
                    hint: 'Enter the location of the incident',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the location of the incident';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  SwitchListTile(
                    title: const Text(
                      'Want to remain anonymous?',
                      style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                    ),
                    value: _wantAnonymous,
                    onChanged: (value) {
                      setState(() {
                        _wantAnonymous = value;
                      });
                    },
                    activeColor: Colors.blue,
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle form submission

                          try{
                            // submitFields();
                            firestoreService.addComplaint(_nameController.text,hashedEmail, _issueOccurredOnController.text,_subjectController.text, _descriptionController.text, _categoryController.text, _issueOccurredAtController.text, _wantAnonymous, false);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Complaint Registered Successfully')),

                            );
                            Navigator.pop(context);
                          }
                          catch(e){
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Can\'t submit your Complaint!')),
                            );
                          }





                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Submit Complaint',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStyledTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(color: Colors.blueAccent, fontSize: 16),
        hintStyle: const TextStyle(color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue.shade200, width: 1),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 1),
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: validator,
    );
  }
}
