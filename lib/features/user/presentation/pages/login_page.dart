// presentation/pages/login_page.dart
import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_server_app/features/app/theme/style.dart';
import 'package:test_server_app/features/user/presentation/cubit/login/login_cubit.dart';
import 'package:test_server_app/features/user/presentation/pages/otp_page.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  String _phoneNumber = '';
 static Country _selectedFilteredDialogCountry = CountryPickerUtils.getCountryByPhoneCode("91");
 String _countryCode = _selectedFilteredDialogCountry.phoneCode;

  

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
 void _openFilteredCountryPickerDialog() {
    showDialog(
      context: context,
      builder: (_) => Theme(
        data: Theme.of(context).copyWith(primaryColor: tabColor),
        child: CountryPickerDialog(
          titlePadding: const EdgeInsets.all(8.0),
          searchCursorColor: tabColor,
          searchInputDecoration: const InputDecoration(hintText: "Search"),
          isSearchable: true,
          title: const Text("Select your phone code"),
          onValuePicked: (Country country) {
            setState(() {
              _selectedFilteredDialogCountry = country;
              _countryCode = country.phoneCode;
            });
          },
          itemBuilder: _buildDialogItem,
        ),
      ),
    );
  }
Widget _buildDialogItem(Country country) {
    return Container(
      height: 40,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: tabColor, width: 1.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          Text(" +${country.phoneCode}",style:const TextStyle(color: Colors.blue),),
          Expanded(
            child: Text(
              " ${country.name}",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:const TextStyle(color: Colors.blue)
            ),
          ),
          const Spacer(),
          const Icon(Icons.arrow_drop_down),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginOtpSent) {
          Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OtpPage(phoneNumber: _phoneNumber,)),
      );
        }
        if (state is LoginFailure) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        if (state is LoginLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return _bodyWidget();
      },
    );
  }

  _bodyWidget() {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      "Verify your phone number",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: tabColor,
                      ),
                    ),
                  ),
                  const Text(
                    "we will send you an SMS message to verify your phone number. Enter the country code and phone number.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15,color: Colors.blue),
                  ),
                  const SizedBox(height: 30),
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 2),
                    onTap: _openFilteredCountryPickerDialog,
                    title: _buildDialogItem(_selectedFilteredDialogCountry),
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(width: 1.50, color: tabColor),
                          ),
                        ),
                        width: 80,
                        height: 42,
                        alignment: Alignment.center,
                        child: Text(
                          _selectedFilteredDialogCountry.phoneCode,style: const TextStyle(color: Colors.blue),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Container(
                          height: 40,
                          margin: const EdgeInsets.only(top: 1.5),
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: tabColor, width: 1.5),
                            ),
                          ),
                          child: TextField(
                            controller: _phoneController,
                            style: const TextStyle(color: Colors.blue),
                            decoration: const InputDecoration(
                              hintText: "Phone Number",
                              border: InputBorder.none,
                              hintStyle: TextStyle(color: Colors.blue)
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          GestureDetector(
            onTap: () => _submitVerifyPhoneNumber(context),
            child:Container(
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
    )
    );
  }

  void _submitVerifyPhoneNumber(BuildContext context) {
    if (_phoneController.text.isNotEmpty) {
      _phoneNumber = "+$_countryCode${_phoneController.text}";
      context.read<LoginCubit>().sendOtp(_phoneNumber);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Enter your phone number")));
    }
  }
}
