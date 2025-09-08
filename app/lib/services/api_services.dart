import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl =
      'https://43985c7c5131.ngrok-free.app/api/server';
  static const storage = FlutterSecureStorage(); // secure storage instance

  // Send OTP
  static Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    var url = Uri.parse("$baseUrl/auth/get-OTP");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phoneNumber}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "success": false,
          "message": "Failed to send OTP: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {"success": false, "message": "Error sending OTP: $e"};
    }
  }

  // Verify OTP
  static Future<Map<String, dynamic>> verifyOtp({
    required String otp,
    required String name,
    required String lastName,
    required String phoneNumber,
    required String gender,
    required String firebaseToken,
    String role = "CITIZEN",
  }) async {
    final url = Uri.parse('$baseUrl/auth/verify-and-signin');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "otp": otp,
          "name": name,
          "last_name": lastName,
          "phone": phoneNumber,
          "gender": gender,
          "firebaseToken": firebaseToken,
          "role": role,
        },
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');
      print('Headers: ${response.headers}');

      if (response.statusCode == 200) {
        // Extract token from set-cookie
        String? rawCookie = response.headers['set-cookie'];
        if (rawCookie != null) {
          int index = rawCookie.indexOf(';');
          String token =
              (index == -1) ? rawCookie : rawCookie.substring(0, index);
          token = token.replaceFirst("token=", "");

          print("Extracted Token: $token");

          // Save token securely
          await storage.write(key: 'auth_token', value: token);
        } else {
          print("No Set-Cookie header found");
        }

        return jsonDecode(response.body);
      } else {
        return {
          "success": false,
          "message": "OTP verification failed: ${response.body}",
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Error during OTP verification: $e",
      };
    }
  }

  // Get saved token
  static Future<String?> getToken() async {
    return await storage.read(key: 'auth_token');
  }
}
