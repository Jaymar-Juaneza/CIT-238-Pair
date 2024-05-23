import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _reEnterPasswordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _sectionController = TextEditingController();
  String _userType = 'Faculty'; // Default user type is Faculty
  String _selectedDepartment = 'Computer Science'; // Default department for faculty

  final List<String> _departments = [
    'Computer Science',
    'Information Technology',
    'Mathematics',
    'Physics',
    'Chemistry',
    'Biology',
  ];

  Future<void> _register() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text;
    final String reEnteredPassword = _reEnterPasswordController.text;
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();


    if (email.isEmpty ||
        password.isEmpty ||
        reEnteredPassword.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty ||
        (_userType == 'Student' &&
            (_courseController.text.isEmpty ||
                _yearController.text.isEmpty ||
                _sectionController.text.isEmpty))) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Please fill all fields'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    if (!email.endsWith('@wvsu.edu.ph')) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Email Format'),
          content: const Text('Please use your WVSU Email.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }


    if (password != reEnteredPassword) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Passwords do not match'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Realtime DB 
      if (userCredential.user != null) {
        final Map<String, dynamic> userData = {
          'email': email,
          'firstName': firstName,
          'lastName': lastName,
          'userType': _userType,
        };

        if (_userType == 'Faculty') {
          userData['department'] = _selectedDepartment;
        } else {
          userData['course'] = _courseController.text.trim();
          userData['year'] = _yearController.text.trim();
          userData['section'] = _sectionController.text.trim();
        }

        await _database.child('users').child(userCredential.user!.uid).set(userData);
        // Show registration success dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Registration Successful'),
            content: const Text('You have successfully registered.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                  Navigator.pushReplacementNamed(context, '/land'); // Navigate to home page
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      // Handle registration errors
      print('Registration failed: $e');
      // Display error message to the user
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Registration failed: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        title: const Text('Register'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.lightBlue,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: 200,
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(labelText: 'First Name'),
                  ),
                  TextField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(labelText: 'Last Name'),
                  ),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  DropdownButtonFormField(
                    value: _userType,
                    onChanged: (value) {
                      setState(() {
                        _userType = value.toString();
                      });
                    },
                    items: ['Faculty', 'Student'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  if (_userType == 'Faculty')
                    DropdownButtonFormField(
                      value: _selectedDepartment,
                      onChanged: (value) {
                        setState(() {
                          _selectedDepartment = value.toString();
                        });
                      },
                      items: _departments.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  if (_userType == 'Student') ...[
                    TextField(
                      controller: _courseController,
                      decoration: const InputDecoration(labelText: 'Course'),
                    ),
                    TextField(
                      controller: _yearController,
                      decoration: const InputDecoration(labelText: 'Year'),
                    ),
                    TextField(
                      controller: _sectionController,
                      decoration: const InputDecoration(labelText: 'Section'),
                    ),
                  ],
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: _reEnterPasswordController,
                    decoration: const InputDecoration(labelText: 'Re-enter Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    child: const SizedBox(
                      width: 200,
                      child: Center(
                        child: Text(
                          'REGISTER',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
