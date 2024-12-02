import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:test_server_app/features/app/const/app_const.dart';
import 'package:test_server_app/features/app/theme/style.dart';
import 'package:test_server_app/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:test_server_app/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:test_server_app/features/user/presentation/cubit/credential/credential_state.dart';
import 'package:test_server_app/features/user/presentation/pages/inital_profile_submit_page.dart';


class OtpPage extends StatefulWidget {
  final String phoneNumber;
  const OtpPage({super.key, required this.phoneNumber});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final TextEditingController _otpController = TextEditingController();
  bool isOtpResent = false;
  int _resendOtpCooldown = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendOtpTimer();
  }

  

  void _startResendOtpTimer() {
    setState(() {
      _resendOtpCooldown = 30;
      isOtpResent = true;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendOtpCooldown > 0) {
        setState(() => _resendOtpCooldown--);
      } else {
        timer.cancel();
        setState(() => isOtpResent = false);
      }
    });
  }

  void _submitOtp() {
    if (_otpController.text.isNotEmpty) {
      context.read<CredentialCubit>().verifyOtp(widget.phoneNumber, _otpController.text);
    }
  }

  void _resendOtp() {
    _startResendOtpTimer();
    context.read<CredentialCubit>().resendOtp(widget.phoneNumber);
  }


  @override
  Widget build(BuildContext context) {
     return BlocConsumer<CredentialCubit, CredentialState>(
      listener: (context, credentialListenerState) {
        if(credentialListenerState is CredentialSuccess) {
          BlocProvider.of<AuthCubit>(context).loggedIn();
        }
        if(credentialListenerState is CredentialFailure) {
          toast("Something went wrong");
        }
      },
      builder: (context, credentialBuilderState) {
        if(credentialBuilderState is CredentialLoading) {
          return const Center(child: CircularProgressIndicator(color: tabColor,),);
        }
        if(credentialBuilderState is CredentialSuccess) {
          return InitialProfileSubmitPage(phoneNumber: widget.phoneNumber);
        }
        return _bodyWidget();
      },
    );
  }
     
     _bodyWidget(){
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
                      "Enter your OTP for the Verification.",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15,color: Colors.blue),
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
                onTap: _submitOtp,
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
      child: PinCodeFields(
        controller: _otpController,
        length: 6,
        textStyle: const TextStyle(color: Colors.blue),
        activeBorderColor: Colors.blue,
        onComplete: (String pinCode) {},
      ),
    );
  }
}

