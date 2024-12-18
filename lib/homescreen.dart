import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:voiceforher/ChatBotScreen.dart';
import 'package:voiceforher/addtocontacts.dart';
import 'package:voiceforher/requesting_help.dart';

import 'awareness.dart';
import 'counselling.dart';
import 'profilebar.dart';
import 'complaintScreen.dart';

class Homescreen extends StatefulWidget {
  @override
  _HomescreenState createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int _currentIndex = 0;

  final String url =
      "https://www.google.com/maps/@16.7871972,80.8486436,15.38z?entry=ttu&g_ep=EgoyMDI0MTIxMS4wIKXMDSoASAFQAw%3D%3D";

  final List<Widget> _pages = [
    HomePage(),
    MapScreen(),

    ChatScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.deepPurpleAccent, // Adjusted for consistency
      //   title: Row(
      //     children: [
      //       Icon(Icons.location_on, color: Colors.white),
      //       SizedBox(width: 8),
      //       Expanded(
      //         child: Text(
      //           'Manipal Hospital Road...',
      //           overflow: TextOverflow.ellipsis,
      //           style: TextStyle(fontWeight: FontWeight.bold),
      //         ),
      //       ),
      //     ],
      //   ),
      //   actions: [
      //     Icon(Icons.notifications, color: Colors.white),
      //   ],
      // ),
      body: Center(
        child: Container(
          color: Colors.white,
          child: _pages[_currentIndex], // Display the page based on selected index
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 5,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.deepPurpleAccent, // Consistent with theme
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),

        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.deepPurple.shade50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [

                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_)=> EmergencyHelpScreen()),
                        );
                      },
                      child: Icon(
                        Icons.warning_rounded,
                        size: 80,
                        color: Colors.white,
                      ),
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.all(30),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Emergency Needed?',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Not Sure What to do?',
                      style: TextStyle(fontSize: 18, color: Colors.deepPurpleAccent),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCircularButton(context, Icons.location_on, 'Safe Zone', MapScreen()),
                          _buildCircularButton(context, Icons.group, 'She Mate', MapScreen()),
                          _buildCircularButton(context, Icons.map, 'Safe Pathways', MapScreen()),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildCircularButton(context, Icons.location_on,
                              'Awareness', AwarenessPage()),
                          _buildCircularButton(context, Icons.group,
                              'Counselling', CounsellingHomePage()),

                        ],
                      ),
                    ),

                    SizedBox(height: 16),
                    _buildRectangularButton(context, Icons.report, 'Complaint Box', ComplaintsScreen()),
                    _buildRectangularButton(context, Icons.contacts, 'Emergency Contacts', EmergencyContactsPage()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton(BuildContext context, IconData icon, String label, Widget page) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.deepPurpleAccent, // Consistent color
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.deepPurpleAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildRectangularButton(BuildContext context, IconData icon, String label, Widget page) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurpleAccent, // Adjusted for consistency
          padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 30),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class MapScreen extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text(
//         'Map Screen',
//         style: TextStyle(fontSize: 24, color: Colors.deepPurpleAccent),
//       ),
//     );
//   }
// }

// Placeholder pages for each grid item navigation
class SafeZonePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Safe Zone', style: TextStyle(color: Colors.white)), backgroundColor: Colors.deepPurpleAccent),
      body: Center(child: Text('Safe Zone Page', style: TextStyle(color: Colors.deepPurpleAccent))),
    );
  }
}

class SheMatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('She Mate', style: TextStyle(color: Colors.white)), backgroundColor: Colors.deepPurpleAccent),
      body: Center(child: Text('She Mate Page', style: TextStyle(color: Colors.deepPurpleAccent))),
    );
  }
}

class SafePathwaysPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Safe Pathways', style: TextStyle(color: Colors.white)), backgroundColor: Colors.deepPurpleAccent),
      body: Center(child: Text('Safe Pathways Page', style: TextStyle(color: Colors.deepPurpleAccent))),
    );
  }
}

class AddContactsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Contacts', style: TextStyle(color: Colors.white)), backgroundColor: Colors.deepPurpleAccent),
      body: Center(child: Text('Add Contacts Page', style: TextStyle(color: Colors.deepPurpleAccent))),
    );
  }
}


// Placeholder screens
class MapScreen extends StatelessWidget {
  final String googleMapsUrl = "https://www.google.com/maps/@16.7871972,80.8486436,15.38z?entry=ttu&g_ep=EgoyMDI0MTIxMS4wIKXMDSoASAFQAw%3D%3D"; // San Francisco coordinates

  @override
  Widget build(BuildContext context) {
    _redirectToGoogleMaps();

    return Scaffold(
      appBar: AppBar(
        title: Text("Redirecting to Google Maps..."),
      ),
      body: Center(
        child: CircularProgressIndicator(), // Show a loading indicator while redirecting
      ),
    );
  }

  void _redirectToGoogleMaps() async {
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
    } else {
      print("Could not launch Google Maps.");
    }
  }
}
