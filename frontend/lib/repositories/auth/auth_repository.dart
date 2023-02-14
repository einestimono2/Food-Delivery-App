import 'dart:convert';

import 'package:http/http.dart';

import '../../constants/constants.dart';
import '../repositories.dart';

class AuthRepository extends BaseAuthRepository {
  @override
  Future<Response> signIn(
      {required String email, required String password}) async {
    Response res = await post(
      Uri.parse('$url/auth/signin'),
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> signOut() async {
    Response res = await get(
      Uri.parse('$url/auth/signout'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    Response res = await post(
      Uri.parse('$url/auth/signup'),
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> activateEmail({
    required String token,
    required String otp,
  }) async {
    Response res = await post(
      Uri.parse('$url/auth/activation/$token'),
      body: jsonEncode({'otp': otp}),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> forgotPassword({required String email}) async {
    Response res = await post(
      Uri.parse('$url/auth/forgot'),
      body: jsonEncode({'email': email}),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> resetPassword({
    required String token,
    required String newPassword,
    required String otp,
  }) async {
    Response res = await post(
      Uri.parse('$url/auth/reset/$token'),
      body: jsonEncode({'newPassword': newPassword, 'otp': otp}),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }

  @override
  Future<Response> verifyToken(String token) async {
    Response res = await post(
      Uri.parse('$url/auth/verify/$token'),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    return res;
  }
}
