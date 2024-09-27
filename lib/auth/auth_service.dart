import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

class AuthService {
  final String _baseUrl = 'url';

  Future<bool> signUp(String email, String password, String firstName,
      String lastName, String DOB, String idImage, String phone) async {
    final map = <String, dynamic>{};
    map['email'] = email;
    map['password'] = password;
    map['firstName'] = firstName;
    map['lastName'] = lastName;
    map['DOB'] = DOB;
    map['idImage'] = idImage;
    map['phone'] = phone;
    try {
      final Uri uri = Uri.parse(_baseUrl);

      final response = await http.post(
        uri,
        headers: {
          'Accept': 'application/json',
        },
        body: map,
      );

      // final response = await http.post(
      //   Uri.parse(
      //       'url'),
      //   headers: {
      //     'Accept': 'application/json',
      //     'Content-Type': 'multipart/form-data',
      //   },
      //   body: json.encode({
      //     'email': email,
      //     'password': password,
      //     'firstName': firstName,
      //     'lastName': lastName,
      //     'DOB': DOB,
      //     'idImage': idImage,
      //     'phone': phone,
      //   }),
      // );

      print('-------response-------${jsonDecode(response.body)}');

      if (response.statusCode == 200) {
        final token = json.decode(response.body)['accessToken'];
        await _saveToken(token);
        return true;
      }
      return false;
    } catch (e) {
      print('Sign up error: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('https://dummyjson.com/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
            {'username': email, 'password': password, 'expiresInMins': 30}),
      );

      if (response.statusCode == 200) {
        final token = json.decode(response.body)['accessToken'];
        await _saveToken(token);
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
}
