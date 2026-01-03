// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:creditpay/constants/constants.dart';

class AccountInformationScreen extends StatelessWidget {
  const AccountInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'Personal Information',
        'subtitle': 'Name, DOB, Address',
        'route': '/personal_info',
      },
      {
        'title': 'Next of Kin Information',
        'subtitle': 'Contact & relation',
        'route': '/next_of_kin',
      },
      {
        'title': 'Employment Information',
        'subtitle': 'Employer details',
        'route': '/employment_info',
      },
      {
        'title': 'Upload Documents',
        'subtitle': 'ID, Payslip, KYC',
        'route': '/upload_doc',
      },
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
            icon: Icon(Icons.arrow_back, size: 24.sp),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: const Color(0xFF142B71),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.only(left: 20.w),
              child: Text(
                'Account Information',
                style: Constants.kSignupTextstyle,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => SizedBox(height: 20.h),
                  itemBuilder: (context, index) {
                    final it = items[index];
                    return _InfoCard(
                      title: it['title'] as String,
                      subtitle: it['subtitle'] as String,
                      color: Colors.white,
                      onTap: () =>
                          Navigator.pushNamed(context, it['route'] as String),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _InfoCard({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70.h,
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: const Color(0xff142B71).withOpacity(0.3),
          ),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: Offset(0, 3.h),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF142B71),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.black38, size: 24.sp),
          ],
        ),
      ),
    );
  }
}


