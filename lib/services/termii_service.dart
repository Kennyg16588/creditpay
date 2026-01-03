import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class TermiiService {
  // 🔑 IMPORTANT: Replace with your actual Termii API Key from https://termii.com
  static const String _apiKey =
      'TLeglNGurcGHcLfUWBzmonjLBKmagOGSlMlJbgKDuGmIesxkkYKwWOiNhpuBjp';
  static const String _baseUrl = 'https://api.ng.termii.com/api';

  // Store OTPs temporarily (in production, use a proper backend)
  static final Map<String, String> _otpStore = {};

  // 🔧 DEVELOPMENT MODE: Set to true to use mock OTP (1234) for testing
  static const bool _useMockOTP = true;
  static const String _mockOTP = '12345';

  /// Generate a random 5-digit OTP
  String _generateOTP() {
    if (_useMockOTP) {
      return _mockOTP; // Use fixed OTP for testing
    }
    final random = Random();
    return (10000 + random.nextInt(90000)).toString();
  }

  /// Send OTP to phone number
  /// In mock mode, just returns success without actually sending SMS
  Future<String?> sendOTP(String phoneNumber) async {
    try {
      // Generate OTP
      final otp = _generateOTP();

      // Use phone number as pinId
      final pinId = phoneNumber;

      // Store OTP temporarily
      _otpStore[pinId] = otp;

      if (_useMockOTP) {
        // MOCK MODE: Don't actually send SMS, just simulate success
        debugPrint('🧪 MOCK MODE: OTP is $otp');
        debugPrint('✅ Mock OTP stored for $phoneNumber');

        // Auto-expire OTP after 5 minutes
        Future.delayed(const Duration(minutes: 5), () {
          _otpStore.remove(pinId);
          debugPrint('⏰ OTP expired for $pinId');
        });

        return pinId;
      }

      // REAL MODE: Try to send via Termii
      final url = Uri.parse('$_baseUrl/sms/send');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'to': phoneNumber,
          'from': 'CreditPay',
          'sms':
              'Your CreditPay verification code is $otp. Valid for 5 minutes.',
          'type': 'plain',
          'channel': 'dnd',
          'api_key': _apiKey,
        }),
      );

      debugPrint('📤 Termii Send SMS Response: ${response.statusCode}');
      debugPrint('📤 Termii Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['message_id'] != null ||
            data['message'] == 'Successfully Sent') {
          debugPrint('✅ SMS sent successfully. OTP: $otp');

          // Auto-expire OTP after 5 minutes
          Future.delayed(const Duration(minutes: 5), () {
            _otpStore.remove(pinId);
            debugPrint('⏰ OTP expired for $pinId');
          });

          return pinId;
        } else {
          debugPrint('❌ Failed to send SMS: ${response.body}');
          return null;
        }
      } else {
        debugPrint('❌ Failed to send SMS: ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('❌ Termii Send SMS Error: $e');
      return null;
    }
  }

  /// Verify OTP
  /// Returns true if the OTP is correct
  Future<bool> verifyOTP(String pinId, String pin) async {
    try {
      debugPrint('🔍 Verifying OTP: $pin for pinId: $pinId');

      final storedOTP = _otpStore[pinId];

      if (storedOTP == null) {
        debugPrint('❌ OTP expired or not found');
        return false;
      }

      if (storedOTP == pin) {
        debugPrint('✅ OTP verified successfully');
        _otpStore.remove(pinId); // Remove OTP after successful verification
        return true;
      } else {
        debugPrint('❌ Invalid OTP. Expected: $storedOTP, Got: $pin');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Termii Verify OTP Error: $e');
      return false;
    }
  }
}
