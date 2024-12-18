import 'dart:math';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:voiceforher/ChatWithAuthority.dart';
import 'package:voiceforher/raisecomplaint.dart';

class ComplaintsScreen extends StatefulWidget {
  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> {
  // Firestore reference to the complaints collection
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String hashedEmail = " ";
  bool isAuthorized = false;
  bool isAuthorized_fireStore = false;
  String email_profile = " ";
  bool _isLoading = true;




  Future<void> getHashedDetails() async {
    final prefs = await SharedPreferences.getInstance();
    hashedEmail = prefs.getString('hashedEmail') ?? '';
    isAuthorized = prefs.getBool('authorized') ?? false;
  }


  Future<void> retriveData() async {
    await getHashedDetails();
    final prefs = await SharedPreferences.getInstance();
    email_profile = prefs.getString("email") ?? " ";
    print("isAuthorized value email profile $email_profile");

    final CollectionReference profiles = _firestore.collection('profiles');

    try {
      // Fetch all profiles from Firestore
      final snapshot = await profiles.get();
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        if (data['email'] == email_profile) {  // Match the email
          print("the email is ${data['email']}");
          setState(() {
            isAuthorized_fireStore = data["isAuthority"];
            

          });
          break;  // Stop once we find the match
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }


  @override
  void initState() {
    super.initState();
    // Perform async tasks after the first frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await retriveData();  // Make sure async call is awaited
      setState(() {
        // Update UI if needed after data retrieval
        _isLoading = false;
      });
    });
  }






  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Girl Safety Complaints'),
          backgroundColor: Colors.blue,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Girl Safety Complaints',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue, // Blue theme for AppBar
      ),
      body: Stack(
        children: [
          Container(
            color: Colors.blue.shade50, // Light blue background for the body
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                const Text(
                  'Current Complaints',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                // StreamBuilder for current complaints

                isAuthorized_fireStore ?
                 StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('complaints')
                      .where('status', isEqualTo: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Text(
                        'Error fetching complaints.',
                        style: TextStyle(color: Colors.red),
                      );
                    } else if (!snapshot.hasData) {  // Simplified condition
                      return const Text(
                        'No current complaints available.',
                        style: TextStyle(color: Colors.grey),
                      );
                    } else {
                      // Print data here
                      if(isAuthorized){

                      }
                      if (snapshot.data!.docs.isNotEmpty) {
                        for (var doc in snapshot.data!.docs) {
                          // print("Document: ${doc.data()}");


                        }
                      } else {
                        print("No data or docs are empty.");
                      }

                      //{date: hxjx, hashedEmail: hashedEmail, isano: true, subject: gxbx, name: dhdhxhc, description: jcjf, location: jcjf , category: jcj, timestamp: Timestamp(seconds=1734151939, nanoseconds=957463000), status: false}

                      return _buildComplaintList(snapshot.data!.docs);
                    }
                  },
                ) : StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('complaints')
                      .where('status', isEqualTo: false)
                      .where('hashedEmail', isEqualTo: hashedEmail)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {

                      return const Center(child: CircularProgressIndicator());

                    } else if (snapshot.hasError) {

                      return const Text(
                        'Error fetching complaints.',
                        style: TextStyle(color: Colors.red),
                      );
                    } else if (!snapshot.hasData) {  // Simplified condition
                      return const Text(
                        'No current complaints available.',
                        style: TextStyle(color: Colors.grey),
                      );
                    } else {
                      // Print data here
                      if(isAuthorized){

                      }
                      if (snapshot.data!.docs.isNotEmpty) {
                        for (var doc in snapshot.data!.docs) {
                          // print("Document: ${doc.data()}");


                        }
                      } else {
                        print("No data or docs are empty.");
                      }

                      //{date: hxjx, hashedEmail: hashedEmail, isano: true, subject: gxbx, name: dhdhxhc, description: jcjf, location: jcjf , category: jcj, timestamp: Timestamp(seconds=1734151939, nanoseconds=957463000), status: false}

                      return _buildComplaintList(snapshot.data!.docs);
                    }
                  },
                ),


                const SizedBox(height: 20),
                const Text(
                  'Past Complaints',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 10),
                // StreamBuilder for past complaints
                isAuthorized_fireStore ?
                StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('complaints')
                      .where('status', isEqualTo: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Text(
                        'Error fetching complaints.',
                        style: TextStyle(color: Colors.red),
                      );
                    } else
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text(
                        'No past complaints available.',
                        style: TextStyle(color: Colors.grey),
                      );
                    } else {
                      // getHashedDetails();
                      // if(isAuthorized){
                      //   return _buildComplaintList(snapshot.data!.docs);
                      // }else{
                      //   return _buildComplaintListForUser(snapshot.data!.docs);
                      // }
                      return _buildComplaintList(snapshot.data!.docs);
                    }
                  },
                ) : StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('complaints')
                      .where('status', isEqualTo: true)
                      .where('hashedEmail', isEqualTo: hashedEmail)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return const Text(
                        'Error fetching complaints.',
                        style: TextStyle(color: Colors.red),
                      );
                    } else
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Text(
                        'No past complaints available.',
                        style: TextStyle(color: Colors.grey),
                      );
                    } else {
                      // getHashedDetails();
                      // if(isAuthorized){
                      //   return _buildComplaintList(snapshot.data!.docs);
                      // }else{
                      //   return _buildComplaintListForUser(snapshot.data!.docs);
                      // }
                      return _buildComplaintList(snapshot.data!.docs);
                    }
                  },
                ),
              ],
            ),
          ),

          !isAuthorized_fireStore ?
          Positioned(
            bottom: 20,
            left: MediaQuery
                .of(context)
                .size
                .width * 0.5 - 90,
            child: SizedBox(
              width: 180,
              child: ElevatedButton(
                onPressed: _raiseComplaint,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Blue button color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Raise a Complaint',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ) : SizedBox.shrink()
        ],
      ),
    );
  }

  void _raiseComplaint() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Raisecomplaint(),
      ),
    );
  }

  // Function to build the list of complaints
  Widget _buildComplaintList(List<QueryDocumentSnapshot> complaints) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: complaints.length,
      itemBuilder: (context, index) {
        final complaint = complaints[index];
        String name = complaint['name'];
        String complaintTitle = complaint['subject'];
        String complaintDetails = complaint['description'];
        String complaintDate = complaint['date'];
        String complaintlocation = complaint['location'];
        String wasAnonymous = complaint['isano'].toString();
        String _hashedEmail = complaint['hashedEmail'];

        if(wasAnonymous == 'true'){
          name = 'Anonymous';
        }

        // getHashedDetails();
        // print("isAuthorized $isAuthorized");

        // Skip rendering the card if the emails do not match
        // if (!isAuthorized && _hashedEmail != hashedEmail) {
        //   return const SizedBox.shrink(); // Empty widget
        // }

        return Card(
          color: Colors.white, // White background for complaint cards
          margin: const EdgeInsets.symmetric(vertical: 5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ListTile(
            title: Text(
              complaintTitle,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            subtitle: Text(
              'Date: $complaintDate',
              style: TextStyle(color: Colors.grey.shade700),
            ),
            leading: Icon(
              Icons.report_problem,
              color: Colors.blue,
            ),
            onTap: () =>
                _showComplaintDetails(
                  context,
                  name,
                  complaintTitle,
                  complaintDetails,
                  complaintDate,
                  complaintlocation,
                  wasAnonymous,


                ),
          ),
        );
      },
    );
  }



  void _showComplaintDetails(
      BuildContext context,
      String name,
      String subject,
      String description,
      String issueOccurredOn,
      String issueOccurredAt,
      String wasAnonymous,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.blue.shade50,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Name and Edit Icon
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Name: $name',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  !isAuthorized_fireStore ? IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      // TODO: Implement edit functionality
                      Navigator.of(context).pop(); // Close dialog before navigation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Edit complaint clicked!')),
                      );
                    },
                  ) : SizedBox.shrink()
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Subject: $subject',
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Text(
                'Description: $description',
                style: const TextStyle(color: Colors.black87),
              ),
              const SizedBox(height: 10),
              Text(
                'Issue Occurred On: $issueOccurredOn',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 10),
              Text(
                'Issue Occurred At: $issueOccurredAt',
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 10),
              Text(
                'Was Anonymous: ${wasAnonymous == 'true' ? 'Yes' : 'No'}',
                style: const TextStyle(color: Colors.black87),
              ),
            ],
          ),
          actions: [
            // Chat with Officer Button
            TextButton.icon(
              onPressed: () {
                // TODO: Implement chat functionality
                // Navigator.of(context).pop(); // Close dialog before navigation
                // ScaffoldMessenger.of(context).showSnackBar(
                //   const SnackBar(content: Text('Chat with Officer clicked!')),
                // );
                getHashedDetails();
                String userid = "girl_user_id";
                String officerid = "officer_id";

                print("isAuthorized value $isAuthorized" );

                print("isAuthorized value $isAuthorized_fireStore" );
                if(isAuthorized_fireStore){
                  userid = "officer_id";
                }else{
                  officerid = "girl_user_id";
                }


                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatPage(userId: userid, officerId: officerid)));

              },
              icon: const Icon(Icons.chat, color: Colors.blue),
              label: const Text(
                'Chat',
                style: TextStyle(color: Colors.blue),
              ),
            ),
            // Close Button
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }

}
