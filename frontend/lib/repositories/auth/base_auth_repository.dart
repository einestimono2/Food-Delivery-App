import 'package:http/http.dart';

abstract class BaseAuthRepository {
  Future<Response> verifyToken(String token);

  Future<Response> signIn({
    required String email,
    required String password,
  });

  Future<Response> signOut();

  Future<Response> signUp({
    required String name,
    required String email,
    required String password,
  });

  Future<Response> activateEmail({
    required String token,
    required String otp,
  });

  Future<Response> forgotPassword({required String email});

  Future<Response> resetPassword({
    required String token,
    required String newPassword,
    required String otp,
    });
}
