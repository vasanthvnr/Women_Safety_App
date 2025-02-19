import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

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
            Image.asset(
              'assets/police_logo.png', // Add a police logo image to your "assets" folder.
              width: 150,
              height: 150,
            ),
            SizedBox(height: 20),
            Text(
              "Women Safety App",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.lightBlue,
              ),
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
    final status = await [
      Permission.location,
      Permission.camera,
      Permission.microphone,
      Permission.contacts,
    ].request();

    if (status.values.any((element) => element.isDenied)) {
      showMessage("Please grant all permissions to use the app.");
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void showLoginDialog({bool isEdit = false}) {
    TextEditingController fullNameController =
        TextEditingController(text: isEdit ? userName : "");
    TextEditingController mobileController =
        TextEditingController(text: isEdit ? mobileNumber : "");
    TextEditingController emailController =
        TextEditingController(text: isEdit ? email : "");

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? "Edit Profile" : "Complete Profile"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: fullNameController,
              decoration: InputDecoration(labelText: "Full Name"),
            ),
            TextField(
              controller: mobileController,
              decoration: InputDecoration(labelText: "Mobile Number"),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: "Email"),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                userName = fullNameController.text;
                mobileNumber = mobileController.text;
                email = emailController.text;
                isLoggedIn = true;
              });
              Navigator.pop(context);
              showMessage(isEdit ? "Profile updated!" : "Profile created!");
            },
            child: Text("Submit"),
          ),
        ],
      ),
    );
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
              showLoginDialog(isEdit: true);
            },
            child: Text("Edit"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
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
              onPressed: () => showLoginDialog(),
              child: Text(
                "Login",
                style: TextStyle(color: Colors.white),
              ),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Instructions:",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text("1.User Must complete the login credentials."),
                        Text(
                            "2. When you feel unsafe, press the volume up button 2 times to alert the police."),
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
          child: Text(
            "© 2025 Women Safety App",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
