import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:voiceforher/services/FireStoreProfileServices.dart';
// import 'package:voiceforher/services/firestore_profile_service.dart'; // Replace with the actual file path



class ProfilesPage extends StatelessWidget {
  final FirestoreProfileService profileService = FirestoreProfileService();

  ProfilesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profiles'),
        centerTitle: true,
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
                elevation: 3,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.purple,
                    child: Text(
                      profileData['name'][0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(profileData['name'] ?? 'Unknown'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${profileData['email'] ?? 'Not provided'}'),
                      Text('Mobile: ${profileData['mobile'] ?? 'Not provided'}'),
                      Text('Education: ${profileData['education'] ?? 'Not specified'}'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      // TODO: Navigate to an Edit Profile page
                      _editProfile(context, profile.id, profileData);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _editProfile(BuildContext context, String docID, Map<String, dynamic> profileData) {
    // Navigate to an edit profile page or show a dialog for editing
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditProfilePage(
          docID: docID,
          profileData: profileData,
        ),
      ),
    );
  }
}

class EditProfilePage extends StatelessWidget {
  final String docID;
  final Map<String, dynamic> profileData;

  const EditProfilePage({Key? key, required this.docID, required this.profileData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Implement your edit form here
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: const Center(
        child: Text('Edit Profile Page'),
      ),
    );
  }
}
