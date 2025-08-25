import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://dpg-m7odk.ondigitalocean.app/api/server';
  
  // -------------------------------
  // Send OTP
  // -------------------------------
  static Future<Map<String, dynamic>> sendOtp(String phoneNumber) async {
    var url = Uri.parse("$baseUrl/auth/get-OTP");

    try {
      final response = await http.post(
        url, 
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"phone": phoneNumber}),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body); // ✅ Return parsed JSON map
      } else {
        return {
          "success": false,
          "message": "Failed to send OTP: ${response.statusCode}"
        };
      }
    } catch (e) {
      return {
        "success": false,
        "message": "Error sending OTP: $e"
      };
    }
  }

  // -------------------------------
  // Verify OTP
  // -------------------------------
  static Future<Map<String, dynamic>> verifyOtp({
    required String otp,
    required String name,
    required String lastName,
    required String phoneNumber,
    required String gender,
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
        },
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      // ✅ Return parsed JSON if success
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {
          "success": false,
          "message": "OTP verification failed: ${response.body}",
        };
      }
    } catch (e) {
      // ✅ Return map on error instead of void
      return {
        "success": false,
        "message": "Error during OTP verification: $e",
      };
    }
  }
}
