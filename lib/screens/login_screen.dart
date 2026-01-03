import 'package:creditpay/widgets/login_form.dart';
import 'package:flutter/material.dart';



class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(backgroundColor: Color(0XFF142B71),
        body: LoginForm(),    
     ), );
  }
}
