import 'package:flutter/material.dart';
import 'package:construction/Screens/Components/Attendence_Cal.dart';
import 'package:construction/Screens/Components/Attendence_History.dart';
import 'package:construction/Screens/Components/FaceCaptureScreen.dart';
import 'package:construction/Screens/Authentication/Login.dart';
import 'package:construction/Screens/Authentication/Navbar.dart';
import 'package:construction/Screens/Components/Payment_History.dart';
import 'dart:io';



// ✅ Logout popup function
void showLogoutPopup(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFFFE990),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.logout, size: 40, color: Colors.black),
              ),
              const SizedBox(height: 20),
              const Text(
                'Are you sure you want to log out of your account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Source Sans 3',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFD9D9D9),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        fontFamily: 'Source Sans 3',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFFE85426),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 12,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        fontFamily: 'Source Sans 3',
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class HomeScreen extends StatefulWidget {
  final String selectedLanguageCode;
  final Function(String) onLanguageChanged;

  const HomeScreen({
    super.key,
    required this.selectedLanguageCode,
    required this.onLanguageChanged,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isPunchedIn = false;
  bool _isPunchedOut = false;

  // Language display names and their corresponding codes
  final Map<String, String> languageMap = {
    'English': 'en',
    'Marathi': 'mr',
    'Hindi': 'hi',
  };

  final List<String> languages = ['English', 'Marathi', 'Hindi'];

  String getLanguageFromCode(String code) {
    // Find the display name for the corresponding code
    for (var entry in languageMap.entries) {
      if (entry.value == code) {
        return entry.key;
      }
    }
    return 'English'; // Default fallback
  }

  Future<bool> _onWillPop() async {
    exit(0);
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Home',
            style: TextStyle(fontFamily: 'Source Sans 3'),
          ),
          centerTitle: true,
          automaticallyImplyLeading: false,
          leading: Builder(
            builder:
                (BuildContext context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
          ),
        ),
        bottomNavigationBar: const Navbar(),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const DrawerHeader(
                decoration: BoxDecoration(color: Colors.orange),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontFamily: 'Source Sans 3',
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text(
                  'Attendance Calendar >',
                  style: TextStyle(fontFamily: 'Source Sans 3'),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AttendenceCal(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text(
                  'Your Payment History >',
                  style: TextStyle(fontFamily: 'Source Sans 3'),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PaymentHistory(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.edit_calendar),
                title: const Text(
                  'Attendance History   >',
                  style: TextStyle(fontFamily: 'Source Sans 3'),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Attendence_History(),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text(
                  'Select Language',
                  style: TextStyle(fontFamily: 'Source Sans 3'),
                ),
                trailing: DropdownButton<String>(
                  value: getLanguageFromCode(widget.selectedLanguageCode),
                  items:
                      languages.map((lang) {
                        return DropdownMenuItem<String>(
                          value: lang,
                          child: Text(lang),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      String languageCode = languageMap[value] ?? 'en';
                      widget.onLanguageChanged(languageCode);
                    }
                  },
                ),
              ),
              const SizedBox(height: 430),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text(
                  'Settings   >',
                  style: TextStyle(fontFamily: 'Source Sans 3'),
                ),
                onTap: () {
                  showLogoutPopup(context);
                },
              ),
              const SizedBox(height: 5),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text(
                  'Log Out   >',
                  style: TextStyle(fontFamily: 'Source Sans 3'),
                ),
                onTap: () {
                  showLogoutPopup(context);
                },
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 12, right: 12),
            child: Column(
              children: List.generate(10, (index) {
                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/Elevation1.png',
                            width: 100,
                            height: 130,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Residential Tower - Masonry Work",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFE85426),
                                    fontFamily: 'Source Sans 3',
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  "12, 6th floor, Asha building, Tidake colony,",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontFamily: 'Source Sans 3',
                                  ),
                                ),
                                const Text(
                                  "near Real Durvankar lawns, Nashik,",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontFamily: 'Source Sans 3',
                                  ),
                                ),
                                const Text(
                                  "Maharashtra - 422009",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                    fontFamily: 'Source Sans 3',
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed:
                                          _isPunchedIn
                                              ? null
                                              : () {
                                                setState(() {
                                                  _isPunchedIn = true;
                                                  _isPunchedOut = false;
                                                });

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder:
                                                        (
                                                          context,
                                                        ) => FaceCaptureScreen(
                                                          punchInTime:
                                                              DateTime.now(),
                                                        ),
                                                  ),
                                                );
                                              },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            _isPunchedIn
                                                ? Colors.grey
                                                : const Color(0xFFE85426),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        "Punch in",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Source Sans 3',
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    ElevatedButton(
                                      onPressed:
                                          _isPunchedIn && !_isPunchedOut
                                              ? () {
                                                setState(() {
                                                  _isPunchedOut = true;
                                                  _isPunchedIn = false;
                                                });
                                              }
                                              : null,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            _isPunchedOut
                                                ? Colors.grey
                                                : const Color(0xFFE85426),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        "Punch out",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: 'Source Sans 3',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
