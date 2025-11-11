

import 'package:flutter/material.dart';

import 'package:creditpay/screens/employer_info_screen.dart';
import 'package:creditpay/screens/home_page_screen.dart';
import 'package:creditpay/screens/onboarding_screen.dart';
import 'package:creditpay/screens/password_screen.dart';
import 'package:creditpay/screens/personal_information_screen.dart';
import 'package:creditpay/screens/upload_document_screen.dart';
import 'package:creditpay/screens/verify_code_screen.dart';
import 'package:creditpay/screens/get_started_screen.dart';
import 'package:creditpay/screens/login_screen.dart';
import 'package:creditpay/screens/sign_up_screen.dart';
import 'package:creditpay/screens/sign_number_screen.dart';
import 'package:creditpay/screens/kyc_screen.dart';
import 'package:creditpay/screens/account_information_screen.dart';
import 'package:creditpay/screens/next_of_kin_screen.dart';
import 'package:creditpay/screens/profile_screen.dart';
import 'package:creditpay/widgets/home.dart';
import 'package:creditpay/widgets/transaction.dart';
import 'package:creditpay/widgets/loan.dart';
import 'package:creditpay/screens/security_settings.dart';
import 'package:creditpay/screens/tier_screen.dart';
import 'package:creditpay/screens/transfer_screen.dart';
import 'package:creditpay/screens/confirm_pin_screen.dart';
import 'package:creditpay/screens/bill_payment_screen.dart';



void main() {
  runApp(Creditpay());
  
} 
 
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
        '/homepage': (context) => HomePageScreen(),
        '/getstarted': (context) => GetStartedScreen(),
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignUpScreen(),
        '/verify': (context) => VerifyCodeScreen(),
        '/signnumber': (context) => SignNumberScreen(),
        '/password': (context)=> PasswordScreen(),
        '/kyc': (context) => KycScreen(),
        '/accountinfo': (context) => AccountInformationScreen(),
        '/personal_info': (context) => PersonalInformationScreen(),
        '/next_of_kin': (context) => NextOfKinScreen(),
        '/employment_info': (context) => EmployerInfoScreen(),
        '/upload_doc': (context) => UploadDocument(),
        '/profile' : (context) => ProfileScreen(),
        '/home': (context) => Home(),
        '/transaction': (context) => Transaction(),
        '/loan': (context) => Loan(),
        '/security': (context) => SecuritySettings(),
        '/tier': (context) => TierScreen(),
        '/transfer': (context) => TransferScreen(),
        '/confirm_pin': (context) => ConfirmPinScreen(),
        '/bill_payment': (context) => BillPaymentScreen(),
      },
      
    );
  }
}

