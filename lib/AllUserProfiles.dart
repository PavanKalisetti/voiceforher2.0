import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voiceforher/services/FireStoreProfileServices.dart';

class ProfilesPage extends StatelessWidget {
  final FirestoreProfileService profileService = FirestoreProfileService();

  ProfilesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profiles'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: profileService.getProfileStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No profiles found.'));
          }

          final profiles = snapshot.data!.docs;

          return ListView.builder(
            itemCount: profiles.length,
            itemBuilder: (context, index) {
              final profile = profiles[index];
              final profileData = profile.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 5,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  onTap: () => _showProfileDetails(context, profileData),
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepPurpleAccent,
                    child: Text(
                      profileData['name'][0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(
                    profileData['name'] ?? 'Unknown',
                    style: const TextStyle(fontSize: 18),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${profileData['email'] ?? 'Not provided'}',
                          style: const TextStyle(color: Colors.grey, fontSize: 14)),
                      Text('Mobile: ${profileData['mobile'] ?? 'Not provided'}',
                          style: const TextStyle(color: Colors.grey, fontSize: 14)),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showProfileDetails(BuildContext context, Map<String, dynamic> profileData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text(
            profileData['name'] ?? 'User Details',

          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailRow('Name', profileData['name'] ?? 'Not provided'),
                _buildDetailRow('Email', profileData['email'] ?? 'Not provided'),
                _buildDetailRow('Hashed Email', profileData['hashedEmail'] ?? 'Not provided'),
                _buildDetailRow('Education', profileData['education'] ?? 'Not provided'),
                _buildDetailRow('Mobile', profileData['mobile'] ?? 'Not provided'),
                _buildDetailRow('Role', profileData['role'] ?? 'Not specified'),
                _buildDetailRow('Is Authority', profileData['isAuthority']?.toString() ?? 'No'),
                _buildDetailRow('Address', profileData['address'] ?? 'Not provided'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close', style: TextStyle(color: Colors.teal)),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
