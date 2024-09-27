import 'package:apiauth/provider/auth_provider.dart';
import 'package:apiauth/screens/login_screen.dart';
import 'package:apiauth/widget/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';

import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? DOB;
  String globalPhoneNumber = '';
  String? b64Image;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.white10,
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Signup Screen',
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  CustomTextField(
                      controller: _firstnameController,
                      labelText: 'First Name'),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextField(
                      controller: _lastNameController, labelText: 'Last Name'),
                  const SizedBox(
                    height: 25,
                  ),
                  GestureDetector(
                    onTap: () => _pickDate(context),
                    child: Material(
                      elevation: 1.0,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 9,
                        height: MediaQuery.of(context).size.height * 0.05,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              DOB != null ? DOB.toString() : 'Select date'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  GestureDetector(
                    onTap: () => pickImage(),
                    child: Material(
                      elevation: 1.0,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 9,
                        height: MediaQuery.of(context).size.height * 0.05,
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(4.0),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(b64Image != null
                              ? 'Image Caputred'
                              : ' Select Image'),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Container(
                    color: Colors.white,
                    child: IntlPhoneField(
                      decoration: const InputDecoration(
                        fillColor: const Color.fromARGB(255, 110, 76, 76),
                        labelText: 'Enter your Number',
                        border: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(4.0))),
                      ),
                      languageCode: "en",
                      onChanged: (phone) {
                        globalPhoneNumber = phone.completeNumber;
                        print('------Phone numbe-----' + phone.completeNumber);
                      },
                      onCountryChanged: (country) {
                        print('-------Country changed to:----' + country.name);
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextField(
                      controller: _emailController, labelText: 'Email'),
                  const SizedBox(
                    height: 25,
                  ),
                  CustomTextField(
                      controller: _passwordController, labelText: 'Password'),
                  const SizedBox(
                    height: 25,
                  ),
                  _isLoading
                      ? CircularProgressIndicator()
                      : OutlinedButton(
                          onPressed: () {
                            _signUp();
                          },
                          child: const Text('Login')),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Login here'),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Text('Lohin'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ));
  }

//pick date and time
  Future<void> _pickDate(BuildContext context) async {
    DateTime? pickDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (pickDate != null) {
      setState(() {
        DOB = "${pickDate.day}-${pickDate.month}-${pickDate.year}";
      });
    }
  }

// pick image
  Future<void> pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File imageFile = File(image.path);
      String base64Image = await convertToBase64(imageFile);
      setState(() {
        b64Image = base64Image;
      });
    }
  }

  Future<String> convertToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    String base64Image = base64Encode(imageBytes);
    return base64Image;
  }

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });
    final email = _emailController.text.trim().toString();
    final password = _passwordController.text.trim().toString();
    final firstName = _firstnameController.text.trim().toString();
    final lastName = _lastNameController.text.trim().toString();
    final dob = DOB.toString();
    final b64I = b64Image.toString();
    final PhoneNum = globalPhoneNumber.toString();

    print('-------email------${email}');
    print('-------password------${password}');
    print('-------firstName------${firstName}');
    print('-------lastName------${lastName}');
    print('-------dob------${dob}');
    print('-------b64I------${b64I}');
    print('-------PhoneNum------${PhoneNum}');

    if (email.isNotEmpty && password.isNotEmpty) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.signUp(
        email,
        password,
        firstName,
        lastName,
        dob,
        b64I,
        PhoneNum,
      );
      if (success) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up failed. Please try again.')),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fields are Empty')),
      );
    }
  }
}
