import 'package:creditpay/widgets/login_form.dart';
import 'package:flutter/material.dart';


class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(backgroundColor: Colors.blue[900],
        body: LoginForm(),    
     ), );
  }
}