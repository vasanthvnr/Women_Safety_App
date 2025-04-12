import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  final String? existingName;
  final String? existingEmail;
  final String? existingMobile;

  RegistrationPage({this.existingName, this.existingEmail, this.existingMobile});

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isOtpSent = false;

  @override
  void initState() {
    super.initState();
    // Pre-fill fields if editing
    if (widget.existingName != null) {
      nameController.text = widget.existingName!;
      emailController.text = widget.existingEmail!;
      mobileController.text = widget.existingMobile!;
    }
  }

  // Simulate sending OTP
  void sendOtp() {
    setState(() {
      isOtpSent = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("OTP sent to ${mobileController.text}")),
    );
  }

  // Validate & Submit User Data
  void registerUser() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        'name': nameController.text,
        'mobile': mobileController.text,
        'email': emailController.text,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.existingName != null ? "Edit Profile" : "User Registration")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Full Name"),
                validator: (value) => value!.isEmpty ? "Enter name" : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty ? "Enter email" : null,
              ),
              TextFormField(
                controller: mobileController,
                decoration: InputDecoration(labelText: "Mobile Number"),
                keyboardType: TextInputType.phone,
                validator: (value) => value!.isEmpty ? "Enter mobile number" : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: otpController,
                      decoration: InputDecoration(labelText: "OTP"),
                      keyboardType: TextInputType.number,
                      validator: (value) => isOtpSent && value!.isEmpty ? "Enter OTP" : null,
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: sendOtp,
                    child: Text("Get OTP"),
                  ),
                ],
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (value) => value!.isEmpty ? "Enter password" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: registerUser,
                child: Text(widget.existingName != null ? "Update" : "Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
