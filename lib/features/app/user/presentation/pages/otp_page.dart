import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

import 'package:test_server_app/features/app/const/agora_config_const.dart';
import 'package:test_server_app/features/app/const/app_const.dart';
import 'package:test_server_app/features/app/theme/style.dart';
import 'package:test_server_app/features/app/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:test_server_app/features/app/user/presentation/pages/inital_profile_submit_page.dart';

class OtpPage extends StatefulWidget {
  final String phoneNumber;
  const OtpPage({super.key, required this.phoneNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
  bool isOtpResent = false;
  int _resendOtpCooldown = 30; // Cooldown duration in seconds
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendOtpTimer(); // Start the timer on page load
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer when the widget is disposed
    super.dispose();
  }

  void _startResendOtpTimer() {
    setState(() {
      _resendOtpCooldown = 30; // Reset the cooldown timer to 30 seconds
      isOtpResent = true; // Disable the button initially
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendOtpCooldown > 0) {
        setState(() {
          _resendOtpCooldown--;
        });
      } else {
        timer.cancel();
        setState(() {
          isOtpResent = false; // Enable the button once cooldown is over
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 40),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      "Verify your OTP",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: tabColor,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Enter your OTP for the WhatsApp Clone Verification.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15),
                  ),
                  const SizedBox(height: 30),
                  _pinCodeWidget(),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: isOtpResent ? null : _resendOtp,
                    child: Text(
                      isOtpResent ? "Resend OTP in $_resendOtpCooldown s" : "Resend OTP",
                      style: const TextStyle(color: tabColor),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            GestureDetector(
              onTap: _submitSmsCode,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                width: 120,
                height: 40,
                decoration: BoxDecoration(
                  color: tabColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                  child: Text(
                    "Next",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pinCodeWidget() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          PinCodeFields(
            controller: _otpController,
            length: 6,
            activeBorderColor: tabColor,
            onComplete: (String pinCode) {},
          ),
          const Text("Enter your 6 digit code"),
        ],
      ),
    );
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    print("Sending OTP verification request: phone=$phoneNumber, otp=$otp");
    final response = await http.post(
      Uri.parse('${Config.BaseUrl}/api/users/login_with_otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': phoneNumber, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['message'] == 'Login successful') {
        print('Login successful');
        // Navigate to InitialProfileSubmitPage after successful verification
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => InitialProfileSubmitPage(phoneNumber: widget.phoneNumber,)),
        );
      } else {
        throw Exception(result['error']);
      }
    } else {
      print("Error in login response: ${response.body}");
      throw Exception('Failed to verify OTP');
    }
  }

  void _submitSmsCode() async {
    print("OTP Code: ${_otpController.text}");
    if (_otpController.text.isNotEmpty) {
      try {
        await verifyOtp(widget.phoneNumber, _otpController.text);
        BlocProvider.of<CredentialCubit>(context).submitSmsCode(smsCode: _otpController.text);
      } catch (e) {
        print("Failed to verify OTP: $e");
        toast("Incorrect OTP. Please try again.");
        _otpController.clear();
      }
    }
  }

  void _resendOtp() async {
    _startResendOtpTimer(); 
    final response = await http.post(
      Uri.parse('http://10.0.2.2:5001/api/users/resend_otp'), // Replace with your backend URL
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': widget.phoneNumber}),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['message'] == 'OTP sent successfully') {
        toast("OTP has been resent.");
        print('OTP sent successfully');
      } else {
        throw Exception('Failed to send OTP');
      }
    } else {
      throw Exception('Failed to send OTP');
    }
  }
}
