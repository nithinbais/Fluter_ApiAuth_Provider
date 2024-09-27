import 'package:apiauth/provider/auth_provider.dart';
import 'package:apiauth/screens/home_screen.dart';
import 'package:apiauth/screens/login_screen.dart';
import 'package:apiauth/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AuthProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
                builder: (context) =>
                    Consumer<AuthProvider>(builder: (context, authProvider, _) {
                      return authProvider.isLoggedIn
                          ? HomeScreen()
                          : LoginScreen();
                    }));
          case '/login':
            return MaterialPageRoute(builder: (context) => LoginScreen());
          case '/signup':
            return MaterialPageRoute(builder: (context) => SignupScreen());
          default:
            return MaterialPageRoute(builder: (context) => HomeScreen());
        }
      },
    );
  }
}
