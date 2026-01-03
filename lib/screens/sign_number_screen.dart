import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:creditpay/constants/constants.dart';
import 'package:creditpay/services/termii_service.dart';

class SignNumberScreen extends StatefulWidget {
  const SignNumberScreen({super.key});

  @override
  State<SignNumberScreen> createState() => _SignNumberScreenState();
}

class _SignNumberScreenState extends State<SignNumberScreen> {
  final TextEditingController mobileCtrl = TextEditingController();
  bool _loading = false;

  late String firstName;
  late String lastName;
  late String email;
  late String mobile;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final data =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    firstName = data['firstName'];
    lastName = data['lastName'];
    email = data['email'];
    mobile = data['mobile'];

    // Preload the mobile number into the text field
    mobileCtrl.text = mobile;
  }

  @override
  void dispose() {
    mobileCtrl.dispose();
    super.dispose();
  }

  void _proceedToVerification() async {
    final phoneNumber = '+234${mobileCtrl.text.trim()}';

    // Validate phone number
    if (mobileCtrl.text.trim().isEmpty || mobileCtrl.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid phone number'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final termiiService = TermiiService();
      final pinId = await termiiService.sendOTP(phoneNumber);

      if (!mounted) return;

      if (pinId != null) {
        setState(() => _loading = false);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification code sent to your phone!'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushNamed(
          context,
          '/verify',
          arguments: {
            'firstName': firstName,
            'lastName': lastName,
            'email': email,
            'mobile': mobileCtrl.text.trim(),
            'pinId': pinId, // Termii pinId instead of Firebase verificationId
          },
        );
      } else {
        setState(() => _loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Failed to send verification code. Please try again.',
            ),
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
              padding: EdgeInsets.all(30.r),
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
            SizedBox(height: 120.h),
            Expanded(
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0.r),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 20.0.h),
                        Text(
                          'Please verify your \nmobile number',
                          style: Constants.kSignupTextstyle,
                        ),
                        SizedBox(height: 37.0.h),
                        Text(
                          'Mobile Number',
                          style: TextStyle(
                            color: const Color(0XFF142B71),
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0.sp,
                          ),
                        ),
                        SizedBox(height: 10.0.h),
                        TextFormField(
                          controller: mobileCtrl,
                          decoration: const InputDecoration(
                            prefixText: '+234  ',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.phone,
                        ),
                        SizedBox(height: 120.h),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color(0XFF142B71),
                            borderRadius: BorderRadius.circular(10.0.r),
                          ),
                          child: TextButton(
                            onPressed: _loading ? null : _proceedToVerification,
                            child:
                                _loading
                                    ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                    : Text(
                                      'Send Code',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0.sp,
                                      ),
                                    ),
                          ),
                        ),
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
