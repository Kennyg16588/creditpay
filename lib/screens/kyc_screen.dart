import 'package:creditpay/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';

class KycScreen extends StatefulWidget {
  const KycScreen({super.key});

  @override
  State<KycScreen> createState() => _KycScreenState();
}

class _KycScreenState extends State<KycScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      debugPrint('📋 KYC Status: ${auth.kycCompleted}');

      if (auth.kycCompleted) {
        debugPrint('✅ KYC already completed, redirecting to homepage');
        Navigator.pushReplacementNamed(context, '/homepage');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 177.h),
            Center(
              child: Image.asset(
                'images/kycimage.png',
                width: 191.w,
                height: 191.h,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: 20.h),
            Container(
              height: 108.h,
              width: 352.w,
              decoration: BoxDecoration(
                color: const Color(0xff142B71),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/accountinfo');
                  },
                  child: Text(
                    'Complete your KYC',
                    style: Constants.kloginTextstyle,
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


