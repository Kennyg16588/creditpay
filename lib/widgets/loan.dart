import 'package:creditpay/screens/loan_personal_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:creditpay/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';

class Loan extends StatefulWidget {
  const Loan({super.key});

  @override
  State<Loan> createState() => _LoanState();
}

class _LoanState extends State<Loan> {
  final List<String> amounts = [
    '₦10,000',
    '₦20,000',
    '₦30,000',
    '₦50,000',
    '₦100,000',
    'Enter\nAmount', // handled differently below
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pushNamed(context, '/homepage'),
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
              SizedBox(height: 30.h),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Text('Loan Request', style: Constants.kSignupTextstyle),
              ),

              Text('Select a loan offer', style: Constants.kHomeTextstyle),
              SizedBox(height: 60.h),

              // 🔹 Action Buttons
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: amounts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 20.h,
                  crossAxisSpacing: 20.w,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
                          context.read<LoanProvider>().setSelectedAmount(
                            amounts[index],
                          );
                          if ((index) == 5) {
                            Navigator.pushNamed(context, '/enter_amount');
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LoanPersonalInfo(),
                              ),
                            );
                          }
                          ;
                        },
                        borderRadius: BorderRadius.circular(50.r),
                        child: Container(
                          alignment: Alignment.center,
                          height: 70.h,
                          width: 95.w,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                              color: Color(0xFF142B71),
                              width: 1.w,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              amounts[index],
                              style: TextStyle(
                                color: Color(0xFF142B71),
                                fontWeight: FontWeight.w600,
                                fontSize: 15.sp,
                                height: 1.2,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                    ],
                  );
                },
              ),
              SizedBox(height: 60.h),
              Text('Select a Repayment Plan', style: Constants.kHomeTextstyle),
              SizedBox(height: 20.h),
              GestureDetector(
                child: Container(
                  alignment: Alignment.center,
                  height: 45.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Color(0xFF142B71), width: 1.w),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Loan Repayment',
                          style: TextStyle(
                            color: Color(0xFF142B71),
                            fontSize: 15.sp,
                            height: 1.2.h,
                          ),
                        ),
                        SizedBox(width: 20.w),
                        Icon(Icons.arrow_drop_down_outlined),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pushNamed(context, '/loan_repay');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
