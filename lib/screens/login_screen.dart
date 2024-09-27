import 'package:apiauth/provider/auth_provider.dart';
import 'package:apiauth/screens/signup_screen.dart';
import 'package:apiauth/widget/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'Login Screen',
                    style: TextStyle(fontSize: 30),
                  ),
                  const SizedBox(
                    height: 30,
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
                            _login();
                          },
                          child: const Text('Login')),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Signup here'),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignupScreen()));
                          },
                          child: Text('Signup'))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    final email = _emailController.text.trim().toString();
    final password = _passwordController.text.trim().toString();
    print('-------email-------${email}');
    print('-------password-------${password}');

    if (email.isNotEmpty && password.isNotEmpty) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.login(email, password);
      print('-------sucess------${success}');

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
          SnackBar(content: Text('Login failed. Please try again.')),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Email or Password is Empty')));
    }
  }
}
