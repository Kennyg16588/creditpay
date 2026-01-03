import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:creditpay/constants/constants.dart';
import 'package:creditpay/providers/app_providers.dart' as app_providers;

class PasswordScreen extends StatefulWidget {
  const PasswordScreen({super.key});

  @override
  State<PasswordScreen> createState() => _PasswordScreenState();
}

class _PasswordScreenState extends State<PasswordScreen> {
  late String firstName;
  late String lastName;
  late String email;
  late String mobile;

  final TextEditingController _passwordCtrl = TextEditingController();
  final TextEditingController _confirmPasswordCtrl = TextEditingController();
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  bool _agreedToTerms = false;
  bool _loading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    final data = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (data != null) {
      firstName = data['firstName'] ?? '';
      lastName = data['lastName'] ?? '';
      email = data['email'] ?? '';
      mobile = data['mobile'] ?? '';
      debugPrint('✅ ARGS RECEIVED: firstName=$firstName, email=$email');
    } else {
      debugPrint('❌ NO ARGS RECEIVED');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please complete previous steps first')),
        );
        Navigator.pop(context);
      });
    }
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  Future<void> _registerUser() async {
    // Validate fields
    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || mobile.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Missing user information. Please restart signup.')),
      );
      return;
    }

    if (_passwordCtrl.text.isEmpty || _confirmPasswordCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all password fields')),
      );
      return;
    }

    if (_passwordCtrl.text != _confirmPasswordCtrl.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (_passwordCtrl.text.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 6 characters')),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to Terms of Service & Privacy Policy')),
      );
      return;
    }

    setState(() => _loading = true);
    final auth = Provider.of<app_providers.AuthProvider>(context, listen: false);

    debugPrint('📝 Starting registration with email: $email, firstName: $firstName');

    try {
      // Register with Firebase Auth
      final result = await auth.registerWithEmail(
        email: email,
        password: _passwordCtrl.text,
        firstName: firstName,
        lastName: lastName,
        mobile: mobile,
      );

      debugPrint('✅ Firebase registration successful: ${result.user?.uid}');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      if (!mounted) return;
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account created successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to login
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      
      debugPrint('❌ Firebase error code: ${e.code}');
      debugPrint('❌ Firebase error message: ${e.message}');
      
      String message = 'Registration failed';
      if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'Email is already registered';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email format';
      } else if (e.code == 'network-request-failed') {
        message = 'Network error. Check your internet connection';
      } else {
        message = e.message ?? 'Registration failed';
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      if (!mounted) return;
      
      debugPrint('❌ General error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
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
                  SizedBox(height: 31.h),
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
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 70.h),
                        Text(
                          'Create your password',
                          style: Constants.kSignupTextstyle,
                        ),
                        SizedBox(height: 20.h),
                        // Password Field
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: !_showPassword,
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              color: Color(0XFF142B71),
                            ),
                            filled: true,
                            fillColor: const Color(0xffA4BEFF),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 18.h,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color(0XFF142B71),
                                size: 20.sp,
                              ),
                              onPressed: () {
                                setState(
                                    () => _showPassword = !_showPassword);
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
                        // Confirm Password Field
                        TextFormField(
                          controller: _confirmPasswordCtrl,
                          obscureText: !_showConfirmPassword,
                          decoration: InputDecoration(
                            labelText: 'Confirm password',
                            labelStyle: const TextStyle(
                              color: Color(0XFF142B71),
                            ),
                            filled: true,
                            fillColor: const Color(0xffA4BEFF),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 18.h,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.r),
                              borderSide: BorderSide.none,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showConfirmPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: const Color(0XFF142B71),
                                size: 20.sp,
                              ),
                              onPressed: () {
                                setState(() =>
                                    _showConfirmPassword =
                                        !_showConfirmPassword);
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),
                        // Checkbox Agreement
                        GestureDetector(
                          onTap: () {
                            setState(
                                () => _agreedToTerms = !_agreedToTerms);
                          },
                          child: Row(
                            children: [
                              Checkbox(
                                value: _agreedToTerms,
                                onChanged: (bool? value) {
                                  setState(
                                      () => _agreedToTerms = value ?? false);
                                },
                                activeColor: const Color(0XFF142B71),
                                side: const BorderSide(
                                  color: Color(0XFF142B71),
                                  width: 2,
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Expanded(
                                child: Text(
                                  'I agree to the Terms of Service & Privacy Policy',
                                  style: TextStyle(
                                    color: const Color(0XFF142B71),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40.h),
                        // Sign Up Button
                        Container(
                          decoration: BoxDecoration(
                            color: _agreedToTerms
                                ? const Color(0XFF142B71)
                                : Colors.grey[400],
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: TextButton(
                            onPressed:
                                (_agreedToTerms && !_loading)
                                    ? _registerUser
                                    : null,
                            child: _loading
                                ? SizedBox(
                                    height: 20.h,
                                    width: 20.w,
                                    child: const CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Sign Up',
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

