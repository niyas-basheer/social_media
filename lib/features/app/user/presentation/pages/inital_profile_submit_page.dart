import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:test_server_app/features/app/const/app_const.dart';
import 'package:test_server_app/features/app/global/widgets/profile_widget.dart';
import 'package:test_server_app/features/app/theme/style.dart';

class InitialProfileSubmitPage extends StatefulWidget {
  final String phoneNumber;

  const InitialProfileSubmitPage({super.key, required this.phoneNumber});

  @override
  State<InitialProfileSubmitPage> createState() => _InitialProfileSubmitPageState();
}

class _InitialProfileSubmitPageState extends State<InitialProfileSubmitPage> {
  final TextEditingController _usernameController = TextEditingController();
  File? _image;

  // Select image from gallery
  Future<void> selectImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print("No image has been selected");
        }
      });
    } catch (e) {
      toast("Some error occurred: $e");
    }
  }

  // Function to handle profile submission with image
  Future<void> submitProfileInfoWithImage() async {
    if (_usernameController.text.isNotEmpty) {
      try {
        // Prepare the request URL
        final Uri url = Uri.parse("https://your-backend-api-url.com/submitProfile");

        // Create multipart request
        var request = http.MultipartRequest('POST', url);

        // Add fields to the request
        request.fields['username'] = _usernameController.text;
        request.fields['phoneNumber'] = widget.phoneNumber;
        request.fields['status'] = "Hey There! I'm using WhatsApp Clone";

        // Add image to the request if available
        if (_image != null) {
          request.files.add(await http.MultipartFile.fromPath(
            'profileImage', _image!.path,
            contentType: MediaType('image', 'jpeg'),  // Adjust mime type if needed
          ));
        }

        // Send the request
        var response = await request.send();

        // Handle the response
        if (response.statusCode == 200) {
          toast("Profile updated successfully!");
        } else {
          toast("Profile update failed.");
        }
      } catch (e) {
        toast("Error: $e");
      }
    } else {
      toast("Please enter a username.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Center(
              child: Text(
                "Profile Info",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: tabColor),
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Please provide your name and an optional profile photo",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 30),

            // Profile Image Selection
            GestureDetector(
              onTap: selectImage,
              child: SizedBox(
                width: 50,
                height: 50,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(25),
                  child: profileWidget(image: _image),
                ),
              ),
            ),
            const SizedBox(height: 10),

            // Username input field
            Container(
              height: 40,
              margin: const EdgeInsets.only(top: 1.5),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: tabColor, width: 1.5)),
              ),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: "Username",
                  border: InputBorder.none,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Next Button (to submit the profile)
            GestureDetector(
              onTap: submitProfileInfoWithImage, // Submit the profile info
              child: Container(
                width: 150,
                height: 40,
                decoration: BoxDecoration(
                  color: tabColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Text(
                    "Next",
                    style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
