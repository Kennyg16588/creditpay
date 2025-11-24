import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:creditpay/providers/app_providers.dart';
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
import 'package:creditpay/screens/enter_amount_screen.dart';
import 'package:creditpay/screens/loan_personal_info_screen.dart';
import 'package:creditpay/screens/loan_bank_verify_screen.dart';
import 'package:creditpay/screens/loan_application_screen.dart';
import 'package:creditpay/screens/loan_repay_screen.dart';
import 'package:creditpay/screens/set_pin_screen.dart';



void main() {
  runApp(const Creditpay());
}

class Creditpay extends StatelessWidget {
  const Creditpay({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => KycProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
        ChangeNotifierProvider(create: (_) => UploadProvider()),
        ChangeNotifierProvider(create: (_) => LoanProvider()),
        ChangeNotifierProvider(create: (_) => LoanRepaymentProvider()),
        ChangeNotifierProvider(create: (_) => PinProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: MaterialApp(
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
          '/password': (context) => PasswordScreen(),
          '/kyc': (context) => KycScreen(),
          '/accountinfo': (context) => AccountInformationScreen(),
          '/personal_info': (context) => PersonalInformationScreen(),
          '/next_of_kin': (context) => NextOfKinScreen(),
          '/employment_info': (context) => EmployerInfoScreen(),
          '/upload_doc': (context) => UploadDocument(),
          '/profile': (context) => ProfileScreen(),
          '/home': (context) => Home(),
          '/transaction': (context) => Transaction(),
          '/loan': (context) => Loan(),
          '/security': (context) => SecuritySettings(),
          '/tier': (context) => TierScreen(),
          '/transfer': (context) => TransferScreen(),
          '/confirm_pin': (context) => ConfirmPinScreen(),
          '/bill_payment': (context) => BillPaymentScreen(),
          '/enter_amount': (context) => EnterAmount(),
          '/loan_pinfo': (context) => LoanPersonalInfo(),
          '/loan_bverify': (context) => LoanBankVerify(),
          '/loan_application': (context) => LoanApplicationPage(),
          '/loan_repay': (context) => LoanRepaymentPage(),
          '/set_pin': (context) => SetPinScreen(),
        },
      ),
    );
  }
}

