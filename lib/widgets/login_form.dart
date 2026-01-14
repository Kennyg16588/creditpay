import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:creditpay/constants/constants.dart';
import 'package:creditpay/providers/app_providers.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailCtrl = TextEditingController();
  final TextEditingController _passwordCtrl = TextEditingController();
  bool _showPassword = false;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadSavedCredentials();
  }

  Future<void> _loadSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _emailCtrl.text = prefs.getString('saved_email') ?? '';
      _passwordCtrl.text = prefs.getString('saved_password') ?? '';
    });
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    final email = _emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    setState(() => _loading = true);

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      // 1️⃣ SIGN IN USER
      await authProvider.signInWithEmail(email: email, password: password);

      if (!mounted) return;

      // 2️⃣ SAVE CREDENTIALS FOR NEXT LOGIN
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('saved_email', email);
      await prefs.setString('saved_password', password);

      // 3️⃣ NAVIGATE TO HOME
      Navigator.pushReplacementNamed(context, '/homepage');
    } on firebase_auth.FirebaseAuthException catch (e) {
      String msg = 'Login failed';

      switch (e.code) {
        case 'user-not-found':
          msg = 'No user found for that email';
          break;
        case 'wrong-password':
          msg = 'Incorrect password';
          break;
        case 'invalid-email':
          msg = 'Invalid email format';
          break;
        default:
          msg = e.message ?? 'Login error';
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unexpected error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 0.1.sh),
              Text('CreditPay', style: Constants.kloginbuttonsytle),
              SizedBox(height: 20.h),
              Text('Welcome Back!', style: Constants.kloginTextstyle),
              Text(
                'Enter your email address and password to login',
                style: Constants.kloginTextstyle2,
              ),
            ],
          ),
        ),
        SizedBox(height: 0.05.sh),
        Expanded(
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0.r),
            ),
            child: SingleChildScrollView(
              // physics: const NeverScrollableScrollPhysics(), // Removed to allow scrolling on small screens
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: 40.h),

                    // EMAIL FIELD
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email Address / Mobile Number',
                        border: OutlineInputBorder(),
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // PASSWORD FIELD
                    TextFormField(
                      controller: _passwordCtrl,
                      obscureText: !_showPassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _showPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            size: 20.sp,
                          ),
                          onPressed:
                              () => setState(
                                () => _showPassword = !_showPassword,
                              ),
                        ),
                      ),
                    ),

                    SizedBox(height: 30.h),

                    // LOGIN BUTTON
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0XFF142B71),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: TextButton(
                        onPressed: _loading ? null : _login,
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
                                  'Login',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp,
                                  ),
                                ),
                      ),
                    ),

                    SizedBox(height: 10.h),

                    // FORGOT PASSWORD
                    TextButton(
                      onPressed:
                          () =>
                              Navigator.pushNamed(context, '/forgot_password'),
                      child: Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: const Color(0XFFFFD602),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ),

                    // SIGN UP LINK
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(
                            color: const Color(0XFF142B71),
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                        TextButton(
                          onPressed:
                              () => Navigator.pushNamed(context, '/signup'),
                          child: Text(
                            'Create Account',
                            style: TextStyle(
                              color: const Color(0XFFFFD602),
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
