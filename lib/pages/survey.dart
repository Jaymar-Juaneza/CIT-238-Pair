import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class Survey extends StatefulWidget {
  const Survey({Key? key}) : super(key: key);

  @override
  State<Survey> createState() => _SurveyState();
}

class _SurveyState extends State<Survey> {
  final DatabaseReference _database = FirebaseDatabase.instance.reference();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  String _role = 'Student'; // Default role
  String _purpose = 'Enrollment'; // Default purpose

  Future<void> _submitSurvey() async {
    final String firstName = _firstNameController.text.trim();
    final String lastName = _lastNameController.text.trim();
    final String address = _addressController.text.trim();
    final String age = _ageController.text.trim();

    // Check if any field is empty
    if (firstName.isEmpty || lastName.isEmpty || address.isEmpty || age.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Please fill all fields'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    // Save survey data to Realtime Database
    try {
      await _database.child('visitors').push().set({
        'firstName': firstName,
        'lastName': lastName,
        'address': address,
        'age': age,
        'role': _role,
        'purpose': _purpose,
      });

      // Navigate to home page after successful submission
      Navigator.pushReplacementNamed(context, '/land');
    } catch (e) {
      // Handle errors
      print('Failed to submit survey: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0,
        title: Text('VISITOR'),
      ),
      body: Container(
         decoration: const BoxDecoration(
          color: Colors.lightBlue,
        ),        
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/unav.png',
                    width: 200,
                    height: 200,
                  ),
                  TextField(
                    controller: _firstNameController,
                    decoration: InputDecoration(labelText: 'First Name'),
                  ),
                  TextField(
                    controller: _lastNameController,
                    decoration: InputDecoration(labelText: 'Last Name'),
                  ),
                  TextField(
                    controller: _addressController,
                    decoration: InputDecoration(labelText: 'Address'),
                  ),
                  TextField(
                    controller: _ageController,
                    decoration: InputDecoration(labelText: 'Age'),
                  ),
                  DropdownButtonFormField(
                    value: _role,
                    onChanged: (value) {
                      setState(() {
                        _role = value.toString();
                      });
                    },
                    items: ['Student', 'Teacher', 'Parent', 'Others'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  DropdownButtonFormField(
                    value: _purpose,
                    onChanged: (value) {
                      setState(() {
                        _purpose = value.toString();
                      });
                    },
                    items: ['Enrollment', 'Visit', 'Meeting'].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 100),
                  ElevatedButton(
                    onPressed: _submitSurvey,
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
                          'SUBMIT',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 52),
                ],
              ),
            ),
          ),
      ),
    );
  }
}
