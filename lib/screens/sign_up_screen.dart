import 'package:creditpay/widgets/sign_up_form.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(backgroundColor: Colors.blue[900],
        body: SignUpForm(),    
     ), );
  }
}