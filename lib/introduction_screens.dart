import 'package:flutter/material.dart';
import 'package:voiceforher/homescreen.dart';
import 'package:voiceforher/login_page.dart';

class IntroScreen extends StatefulWidget {
  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // List of introduction pages
  final List<Map<String, String>> _introPages = [
    {
      "title": "Welcome to MyApp",
      "description": "Discover features and functionalities tailored for you.",
      "image": "assets/images/introduction_1.png", // Replace with actual image paths
    },
    {
      "title": "Stay Organized",
      "description": "Track and manage your tasks effortlessly.",
      "image": "assets/images/introduction_2.png",
    },
    {
      "title": "Achieve Your Goals",
      "description": "Set goals and track your progress easily.",
      "image": "assets/images/introduction_3.png",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // PageView for swiping through screens
          PageView.builder(
            controller: _pageController,
            itemCount: _introPages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final page = _introPages[index];
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.deepPurpleAccent, Colors.blueAccent],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                ),
                child: Stack(
                  children: [
                    // Responsive image scaling
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset(
                        page["image"]!,
                        height: MediaQuery.of(context).size.height * 0.5,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              page["title"]!,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                page["description"]!,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white70,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Page indicator and navigation
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Skip button
                if (_currentPage < _introPages.length - 1)
                  TextButton(
                    onPressed: () {
                      // Navigate directly to the last page
                      _pageController.animateToPage(
                        _introPages.length - 1,
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Skip"),
                  )
                else
                  SizedBox(width: 60), // To balance spacing

                // Page indicators
                Row(
                  children: List.generate(
                    _introPages.length,
                        (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 16 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.white
                            : Colors.white60,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),

                // Next or Get Started button
                if (_currentPage < _introPages.length - 1)
                  TextButton(
                    onPressed: () {
                      // Navigate to the next page
                      _pageController.nextPage(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
                    child: Text("Next"),
                  )
                else
                  GestureDetector(
                    onTap: () {
                      // Navigate to the main app/home screen
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (BuildContext context) => LoginScreen()),
                      );
                    },
                    // style: ElevatedButton.styleFrom(
                    //   backgroundColor: Colors.blue,
                    //   padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(30),
                    //   ),
                    // ),
                    child: Text("Get Started", style: TextStyle(fontSize: 18, color: Colors.white)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
