import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:creditpay/constants/constants.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController firstCtrl = TextEditingController();
  final TextEditingController lastCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController mobileCtrl = TextEditingController();

  @override
  void dispose() {
    firstCtrl.dispose();
    lastCtrl.dispose();
    emailCtrl.dispose();
    mobileCtrl.dispose();
    super.dispose();
  }

  void _proceedToPassword() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.pushNamed(
      context,
      '/signnumber', // Continue signup process
      arguments: {
        'firstName': firstCtrl.text.trim(),
        'lastName': lastCtrl.text.trim(),
        'email': emailCtrl.text.trim(),
        'mobile': mobileCtrl.text.trim(),
      },
    );
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
              SizedBox(height: MediaQuery.of(context).size.height * 0.1),
              Text('CreditPay', style: Constants.kloginbuttonsytle),
              SizedBox(height: 20.h),
            ],
          ),
        ),

        SizedBox(height: MediaQuery.of(context).size.height * 0.08),

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
                    SizedBox(height: 40.h),

                    Text('Create Account', style: Constants.kSignupTextstyle),
                    SizedBox(height: 30.h),

                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: firstCtrl,
                            decoration: InputDecoration(
                              labelText: 'First Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            validator:
                                (v) =>
                                    v == null || v.trim().isEmpty
                                        ? 'First name required'
                                        : null,
                          ),
                          SizedBox(height: 16.h),

                          TextFormField(
                            controller: lastCtrl,
                            decoration: InputDecoration(
                              labelText: 'Last Name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            validator:
                                (v) =>
                                    v == null || v.trim().isEmpty
                                        ? 'Last name required'
                                        : null,
                          ),
                          SizedBox(height: 16.h),

                          TextFormField(
                            controller: emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email Address',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Email required';
                              }
                              final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                              if (!regex.hasMatch(v)) {
                                return 'Enter valid email';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.h),

                          TextFormField(
                            controller: mobileCtrl,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Mobile Number',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                            validator:
                                (v) =>
                                    v == null || v.trim().isEmpty
                                        ? 'Mobile number required'
                                        : null,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 30.h),

                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0XFF142B71),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: TextButton(
                        onPressed: _proceedToPassword,
                        child: Text(
                          'Create Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 16.h),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?',
                          style: TextStyle(fontSize: 13.sp),
                        ),
                        TextButton(
                          onPressed:
                              () => Navigator.pushNamed(context, '/login'),
                          child: Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0XFF142B71),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20.h),
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
