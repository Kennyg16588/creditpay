import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:creditpay/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';

class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({super.key});

  @override
  State<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  final List<Map<String, dynamic>> _actions = [
    {'image': 'images/airtime.jpg', 'label': 'Airtime', 'route': '/airtime'},
    {'image': 'images/data.png', 'label': 'Data', 'route': '/data'},
    {'image': 'images/betting.jpg', 'label': 'Betting', 'route': '/betting'},
    {
      'image': 'images/electricity.jpg',
      'label': 'Electricity',
      'route': '/elect',
    },
    {'image': 'images/shopping.png', 'label': 'Shopping', 'route': '/shop'},
    {'image': 'images/tv.png', 'label': 'TV', 'route': '/tv'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new, size: 18.sp),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: const Color(0xFF142B71),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40.h),
              Padding(
                padding: EdgeInsets.only(bottom: 20.h),
                child: Text('Bill Payment', style: Constants.kSignupTextstyle),
              ),
              // 🔹 Balance Card (responsive)
              Card(
                color: const Color(0xFF142B71),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total Balance',
                            style: Constants.kloginbuttonsytle2,
                          ),
                          Consumer<WalletProvider>(
                            builder: (context, walletProvider, _) {
                              return IconButton(
                                icon: Icon(
                                  walletProvider.showBalance
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: const Color(0xffA4BEFF),
                                  size: 24.sp,
                                ),
                                onPressed:
                                    () =>
                                        walletProvider
                                            .toggleBalanceVisibility(),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Consumer<WalletProvider>(
                        builder: (context, walletProvider, _) {
                          final balance = walletProvider.balance;
                          return Text(
                            walletProvider.showBalance
                                ? '₦${balance.toStringAsFixed(2)}'
                                : '••••••',
                            style: Constants.kloginTextstyle,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 60.h),

              // 🔹 Action Buttons (responsive grid)
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _actions.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _getCrossAxisCount(context),
                  mainAxisSpacing: 30.h,
                  crossAxisSpacing: 30.w,
                  childAspectRatio: 0.85,
                ),
                itemBuilder: (context, index) {
                  final action = _actions[index];
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap:
                            () => Navigator.pushNamed(context, action['route']),
                        borderRadius: BorderRadius.circular(50.r),
                        child: Container(
                          height: 74.9.h,
                          width: 74.9.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.r),
                            border: Border.all(
                              color: const Color(0xFF142B71),
                              width: 1.w,
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(14.w),
                            child: Image.asset(
                              action['image'],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        action['label'],
                        style: TextStyle(
                          color: const Color(0xFF142B71),
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                          height: 1.2.h,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method for responsive grid columns
  int _getCrossAxisCount(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth > 900) {
      return 6; // Large tablets/desktop
    } else if (screenWidth > 600) {
      return 4; // Tablets
    } else {
      return 3; // Mobile
    }
  }
}
