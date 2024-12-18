import 'package:flutter/material.dart';

class EmergencyContactsPage extends StatefulWidget {
  @override
  _EmergencyContactsPageState createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  List<Map<String, String>> contacts = [];

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Function to add a new contact to the list
  void _addContact() {
    if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
      setState(() {
        contacts.add({
          'name': _nameController.text,
          'phone': _phoneController.text,
        });
      });

      // Clear the text fields after adding
      _nameController.clear();
      _phoneController.clear();
    }
  }

  // Function to update the contacts list
  void _updateContacts() {
    // Here you can handle the update logic, such as saving the contacts to a database or sending them to an API.
    // For now, let's just show a confirmation dialog.
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Contacts Updated'),
          content: const Text('Your emergency contacts have been updated successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Contacts',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,  // Deep Blue background for AppBar
      ),
      body: ColoredBox(
        color: Colors.blue.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Input fields for name and phone number
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              // Add Another Contact Button
              ElevatedButton(
                onPressed: _addContact,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,  // Deep Blue for the button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text('Add Another Contact',style: TextStyle(color: Colors.white),),
              ),
              const SizedBox(height: 20),
              // List of contacts
              Expanded(
                child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    return Card(
                      color: Colors.blue,  // Light Blue for the card background
                      margin: EdgeInsets.symmetric(vertical: 5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(
                          contact['name']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,  // Darker Blue for text
                          ),
                        ),
                        subtitle: Text(
                          contact['phone']!,
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Update button
              ElevatedButton(
                onPressed: _updateContacts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,  // Deep Blue for the update button
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text('Update Contacts',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
