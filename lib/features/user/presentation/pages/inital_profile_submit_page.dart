import 'dart:convert';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:test_server_app/features/app/const/agora_config_const.dart';
import 'package:test_server_app/features/app/home/home_page.dart';
import 'package:test_server_app/features/app/theme/style.dart';
import 'package:test_server_app/features/user/data/models/user_model.dart';
import 'package:test_server_app/features/user/domain/entities/user_entity.dart';
import 'package:test_server_app/features/user/presentation/cubit/credential/credential_cubit.dart';

class InitialProfileSubmitPage extends StatefulWidget {
  final String phoneNumber;
  
  const InitialProfileSubmitPage({super.key, required this.phoneNumber});

  @override
  State<InitialProfileSubmitPage> createState() => _InitialProfileSubmitPageState();
}

class _InitialProfileSubmitPageState extends State<InitialProfileSubmitPage> {
  final TextEditingController _usernameController = TextEditingController();
  XFile? _image;
  File? _file;
  bool _isLoading = false;
 Future<void> selectImage() async {
  try {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _file = File(pickedFile.path);
        _image = pickedFile;
      } else {
        print("No image selected");
      }
    });
  } catch (e) {
    toast("Some error occurred: $e");
  }
}
Future<String> uploadImage() async {
  if (_image == null) {
    toast('no image');
    throw 'No image selected';
  }

  try {

    print('Image path: ${_image!.path}');
    print('Image name: ${_image!.name}');

   
    final ref = FirebaseStorage.instance.ref('User/Images/Profile').child(_image!.name);


    await ref.putFile(_file!);

  
    final url = await ref.getDownloadURL();
    
    return url;
  } catch (e) {
    // Provide detailed error information
    print('Error during upload: $e');
    throw 'Something went wrong: ${e.toString()}';
  }
}




  Future<void> submitProfileInfoWithImage() async {
    if (_usernameController.text.isEmpty) {
      toast("Please enter a username.");
      return;
    }

    setState(() {
      _isLoading = true; 
    });

    try {
    
      String? imageUrl = await uploadImage();
      BlocProvider.of<CredentialCubit>(context).submitProfileInfo(
          user: UserModel(
            username: _usernameController.text,
            phoneNumber: widget.phoneNumber,
            status: "Hey There! I'm using WhatsApp Clone",
            isOnline: false,
            profileUrl: imageUrl,
          )
      );
      
    } catch (e) {
      print(e.toString());
      toast("Error: $e");
    } finally {
      setState(() {
        _isLoading = false; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      appBar: AppBar(automaticallyImplyLeading: false,
        title: const Text("Profile Info")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
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

            GestureDetector(
              onTap: selectImage,
              child: SizedBox(
                width: 100,
                height: 100,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: _image != null
                      ? Image.file(_file!, fit: BoxFit.cover)
                      : const Icon(Icons.camera_alt, size: 50, color: tabColor),
                ),
              ),
            ),
            const SizedBox(height: 10),

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

            
            GestureDetector(
              onTap: _isLoading ? null : submitProfileInfoWithImage, 
              child: Container(
                width: 150,
                height: 40,
                decoration: BoxDecoration(
                  color: tabColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator(color: Colors.white))
                    : const Center(
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
  void toast(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }
}
