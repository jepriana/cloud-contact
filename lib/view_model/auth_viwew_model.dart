import 'dart:async';
import 'dart:convert';

import 'package:cloud_contact/constants.dart';
import 'package:cloud_contact/models/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import '../models/http_exception.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel with ChangeNotifier {
  String? _token;
  String? _refreshToken;
  DateTime? _expiryDate;
  String? _userId;
  String? _userEmail;
  String? _password;
  Timer? _authTimer;

  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://identitytoolkit.googleapis.com/v1',
      connectTimeout: 5000,
      receiveTimeout: 3000,
    ),
  );

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  String? get userId {
    return _userId;
  }

  Future<void> _authenticate(
    String email,
    String password,
    String urlSegment,
  ) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=$apiKey');

    try {
      final response = await Dio().postUri(
        url,
        data: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = response.data;
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      } else {
        _userEmail = email;
        _userId = responseData['localId'];
        _token = responseData['idToken'];
        _refreshToken = responseData['refreshToken'];
        _password = password;
        _expiryDate = DateTime.now().add(
          Duration(
            seconds: int.parse(
              responseData['expiresIn'],
            ),
          ),
        );
      }

      final prefs = await SharedPreferences.getInstance();

      final userData = jsonEncode(
        {
          'token': _token,
          'refreshToken': _refreshToken,
          'userId': _userId,
          'email': _userEmail,
          'password': _password,
          'expiryDate': _expiryDate!.toIso8601String()
        },
      );
      if (prefs.containsKey('userData')) {
        await prefs.remove('userData');
      }
      await prefs.setString(
        'userData',
        userData,
      );

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(
    String email,
    String password,
    String firstName,
    String lastName,
    String phone,
  ) async {
    await _authenticate(email, password, 'signUp');
    var userData = User(
      id: _userId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phone,
    );
    if (_userId != null) await addUserData(userData);
  }

  Future<void> addUserData(User userData) async {
    final url = Uri.parse('$apiUrl/users.json?auth=$_token');
    try {
      await Dio().postUri(
        url,
        data: userData.toJson(),
      );
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email, password, 'signInWithPassword');
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return;
    }

    final extractedUserData =
        jsonDecode(prefs.getString('userData').toString());
    //as Map<String, Object>;
    final expiryDate =
        DateTime.parse(extractedUserData['expiryDate'].toString());
    final email = extractedUserData['email'].toString();
    final password = extractedUserData['password'].toString();
    if (expiryDate.isBefore(DateTime.now())) {
      await signIn(email, password);
    } else {
      _token = extractedUserData['token'].toString();
      _userId = extractedUserData['userId'].toString();
      _userEmail = extractedUserData['email'].toString();
      _expiryDate = expiryDate;
      notifyListeners();
    }
  }

  Future<void> logOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_authTimer != null) {
      _authTimer!.cancel();
      _authTimer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userData');
    prefs.clear();
  }
}
