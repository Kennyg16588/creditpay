import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';

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
import 'package:creditpay/screens/airtime_screen.dart';
import 'package:creditpay/screens/data_screen.dart';
import 'package:creditpay/screens/support_feedback_screen.dart';
import 'package:creditpay/screens/change_password_screen.dart';
import 'package:creditpay/screens/security_question_screen.dart';
import 'package:creditpay/screens/fund_wallet_screen.dart';
import 'package:creditpay/screens/forgot_password_screen.dart';

import 'package:creditpay/services/push_notification_service.dart';
import 'package:creditpay/services/remote_config_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize Services
  await RemoteConfigService().initialize();
  await PushNotificationService.initialize();

  FlutterNativeSplash.preserve(widgetsBinding: WidgetsBinding.instance);

  final prefs = await SharedPreferences.getInstance();
  final bool seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
  final bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final user = firebase_auth.FirebaseAuth.instance.currentUser;

  String initialRoute;

  // 🛡️ Ensure user is correctly routed if they were previously logged in
  if (user != null || isLoggedIn) {
    initialRoute = '/homepage';
  } else if (seenOnboarding) {
    initialRoute = '/login';
  } else {
    initialRoute = '/onboarding';
  }

  debugPrint(
    '🚀 App Launch: Seen Onboarding: $seenOnboarding, User: ${user?.uid}, Route: $initialRoute',
  );

  // optional small delay for splash
  await Future.delayed(const Duration(milliseconds: 700));
  FlutterNativeSplash.remove();
  runApp(Creditpay(initialRoute: initialRoute));
}

class Creditpay extends StatefulWidget {
  final String initialRoute;
  const Creditpay({super.key, required this.initialRoute});

  @override
  State<Creditpay> createState() => _CreditpayState();
}

class _CreditpayState extends State<Creditpay> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(393, 852), //   adjust to your design specs
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => TransactionProvider()),
            ChangeNotifierProvider(create: (_) => LoanProvider()),
            ChangeNotifierProvider(create: (_) => LoanRepaymentProvider()),
            ChangeNotifierProvider(create: (_) => PinProvider()),
            ChangeNotifierProvider(create: (_) => AirtimeProvider()),
            ChangeNotifierProvider(create: (_) => TransactionFlowProvider()),
            ChangeNotifierProvider(create: (_) => WalletProvider()),
            ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ],
          child: MaterialApp(
            builder: (context, widget) {
              // ensures ScreenUtil has the correct context for sizing
              return widget ?? const SizedBox();
            },
            theme: ThemeData(
              primarySwatch: Colors.blueGrey,
              primaryColor: Colors.white,
              scaffoldBackgroundColor: Colors.white,
              fontFamily: 'montserrat',
            ),
            initialRoute: widget.initialRoute,
            routes: {
              '/onboarding': (context) => OnboardingScreen(),
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
              '/airtime': (context) => AirtimeScreen(),
              '/data': (context) => DataScreen(),
              '/support_feedback': (context) => SupportFeedbackScreen(),
              '/change_password': (context) => ChangePasswordScreen(),
              '/security_questions': (context) => SecurityQuestionsScreen(),
              '/fund_wallet': (context) => const FundWalletScreen(),
              '/forgot_password': (context) => const ForgotPasswordScreen(),
            },
          ),
        );
      },
    );
  }
}
