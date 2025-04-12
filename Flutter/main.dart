import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'registration_page.dart';

void main() {
  runApp(WomenSafetyApp());
}

class WomenSafetyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/police_logo.png', width: 150, height: 150),
            SizedBox(height: 20),
            Text(
              "Women Safety App",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.lightBlue),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  String? mobileNumber;
  String? email;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
      Permission.microphone,
      Permission.contacts,
    ].request();

    if (statuses.values.any((status) => status.isDenied)) {
      showMessage("Some permissions are denied. Please grant them in settings.");
    } else if (statuses.values.any((status) => status.isPermanentlyDenied)) {
      showMessage("Some permissions are permanently denied. Please enable them in settings.");
      openAppSettings();
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void navigateToRegistration({bool isEdit = false}) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegistrationPage(
          existingName: isEdit ? userName : null,
          existingEmail: isEdit ? email : null,
          existingMobile: isEdit ? mobileNumber : null,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        userName = result['name'];
        mobileNumber = result['mobile'];
        email = result['email'];
        isLoggedIn = true;
      });
    }
  }

  void showProfileDetails() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Profile Details"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Name: $userName"),
            Text("Mobile: $mobileNumber"),
            Text("Email: $email"),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              navigateToRegistration(isEdit: true);
            },
            child: Text("Edit"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Women Safety"),
        backgroundColor: Colors.lightBlue,
        actions: [
          if (isLoggedIn)
            GestureDetector(
              onTap: showProfileDetails,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CircleAvatar(
                  child: Text(userName![0].toUpperCase()),
                ),
              ),
            )
          else
            TextButton(
              onPressed: navigateToRegistration,
              child: Text("Login", style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade100, Colors.lightBlue.shade50],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Instructions:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text("1. Open the app and complete the login."),
                        Text("2. When you feel unsafe, press the volume up button 2 times to alert the police."),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.lightBlue,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("© 2025 Women Safety App", textAlign: TextAlign.center, style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
