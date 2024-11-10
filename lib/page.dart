import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserFormPage extends StatefulWidget {
  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _uidController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _profileUrlController = TextEditingController();

  Future<void> _saveUser() async {
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic> userData = {
        'username': _usernameController.text,
        'email': _emailController.text,
        'phoneNumber': _phoneNumberController.text,
        'uid': _uidController.text,
        'status': _statusController.text,
        'profileUrl': _profileUrlController.text,
      };

      final response = await http.post(
        Uri.parse('http://localhost:5001/api/users/users'), 
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: jsonEncode(userData),
      );

      if (response.statusCode == 201) {
        print('User saved successfully: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User saved successfully!')),
        );
      } else {
        print('Failed to save user: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save user!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _uidController,
                decoration: InputDecoration(labelText: 'UID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a UID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _statusController,
                decoration: InputDecoration(labelText: 'Status'),
              ),
              TextFormField(
                controller: _profileUrlController,
                decoration: InputDecoration(labelText: 'Profile URL'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveUser,
                child: Text('Save User'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _uidController.dispose();
    _statusController.dispose();
    _profileUrlController.dispose();
    super.dispose();
  }
}
