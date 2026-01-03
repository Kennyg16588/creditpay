import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:creditpay/constants/constants.dart';
import 'package:verification_code_field/verification_code_field.dart';
import 'package:creditpay/services/termii_service.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  late String firstName;
  late String lastName;
  late String email;
  late String mobile;
  late String pinId; // Termii pinId

  String _verificationCode = '';
  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    firstName = data['firstName'];
    lastName = data['lastName'];
    email = data['email'];
    mobile = data['mobile'];
    pinId = data['pinId'] ?? ''; // Get Termii pinId

    if (data != null) {
      firstName = data['firstName'] ?? '';
      lastName = data['lastName'] ?? '';
      email = data['email'] ?? '';
      mobile = data['mobile'] ?? '';
      pinId = data['pinId'] ?? '';
      debugPrint(
        '✅ VerifyCode ARGS RECEIVED: email=$email, mobile=$mobile, pinId=$pinId',
      );
    } else {
      debugPrint('❌ NO ARGS RECEIVED in VerifyCode');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill signup form first')),
        );
        Navigator.pop(context);
      });
    }
  }

  void _proceedToPassword() async {
    if (_verificationCode.isEmpty || _verificationCode.length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 5-digit verification code'),
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final termiiService = TermiiService();
      final isVerified = await termiiService.verifyOTP(
        pinId,
        _verificationCode,
      );

      if (!mounted) return;

      if (isVerified) {
        setState(() => _loading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Phone number verified successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Pass all data to PasswordScreen
        Navigator.pushNamed(
          context,
          '/password',
          arguments: {
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'mobile': mobile,
          },
        );
      } else {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid verification code. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _resendCode() async {
    setState(() => _loading = true);

    try {
      final phoneNumber = '+234$mobile';
      final termiiService = TermiiService();
      final newPinId = await termiiService.sendOTP(phoneNumber);

      if (!mounted) return;

      if (newPinId != null) {
        setState(() {
          pinId = newPinId; // Update with new pinId
          _loading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('New verification code sent!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to resend code. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0XFF142B71),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(30.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 29.h),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40.r,
                    child: Icon(
                      Icons.person,
                      size: 50.sp,
                      color: const Color(0XFF142B71),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 100.h),
            Expanded(
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 31.h),
                        Text('Verify Code', style: Constants.kSignupTextstyle),
                        SizedBox(height: 10.h),
                        Container(
                          height: 126.h,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.r),
                            color: const Color(0XFF142B71),
                          ),
                          alignment: Alignment.center,
                          child: VerificationCodeField(
                            codeDigit: CodeDigit.five,
                            filled: true,
                            fillColor: Colors.white,
                            textStyle: TextStyle(
                              fontSize: 24.sp,
                              color: const Color(0XFF142B71),
                              fontWeight: FontWeight.bold,
                            ),
                            onSubmit: (String value) {
                              _verificationCode = value;
                              debugPrint('✅ Code entered: $value');
                            },
                            onChanged: (value) {
                              _verificationCode = value;
                            },
                          ),
                        ),
                        SizedBox(height: 20.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Didn\'t receive the code?',
                              style: TextStyle(
                                color: const Color(0XFF142B71),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                            TextButton(
                              onPressed: _loading ? null : _resendCode,
                              child: Text(
                                'Resend',
                                style: TextStyle(
                                  color: const Color(0XFF142B71),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 150.h),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0XFF142B71),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: TextButton(
                            onPressed: _loading ? null : _proceedToPassword,
                            child:
                                _loading
                                    ? SizedBox(
                                      height: 20.h,
                                      width: 20.w,
                                      child: const CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Text(
                                      'Verify',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.sp,
                                      ),
                                    ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
