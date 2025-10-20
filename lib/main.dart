
import 'package:creditpay/screens/home_screen.dart';
import 'package:creditpay/screens/onboarding_screen.dart';
import 'package:creditpay/screens/password_screen.dart';
import 'package:creditpay/screens/verify_code_screen.dart';
import 'package:flutter/material.dart';
import 'package:creditpay/screens/get_started_screen.dart';
import 'package:creditpay/screens/login_screen.dart';
import 'package:creditpay/screens/sign_up_screen.dart';
import 'package:creditpay/screens/sign_number_screen.dart';


void main() => runApp(Creditpay());

class Creditpay extends StatelessWidget {
  const Creditpay({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'montserrat', 
        
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => OnboardingScreen(),
        '/home': (context) => HomeScreen(),
        '/getstarted': (context) => GetStartedScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/verify': (context) => VerifyCodeScreen(),
        '/signnumber': (context) => SignNumberScreen(),
        '/password': (context)=> PasswordScreen(),
        
      },
      
    );
  }
}

