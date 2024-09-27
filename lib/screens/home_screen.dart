import 'package:apiauth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: OutlinedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                  title: const Text('Logout!'),
                  content: const Text('Are you sure you want to Logout'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.pop(context, 'Cancel'),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () async {
                        final authProvider =
                            Provider.of<AuthProvider>(context, listen: false);
                        await authProvider.logout();
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: Text('Logout')),
      )),
    );
  }
}
