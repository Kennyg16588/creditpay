import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// Transfer success (existing)
class TransferSuccessScreen extends StatelessWidget {
  const TransferSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _baseSuccessScaffold(
      context,
      title: 'Transferred\nSuccessfully',
      message: 'Your amount has been transferred\nsuccessfully.',
      primaryButtonLabel: 'View Details',
      onPrimary: () {},
    );
  }
}

/// Bill payment success (new)
class BillPaymentSuccessScreen extends StatelessWidget {
  const BillPaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _baseSuccessScaffold(
      context,
      title: 'Transaction\nCompleted',
      message: '',
      primaryButtonLabel: 'View Receipt',
      onPrimary: () {},
    );
  }
}

/// Withdrawal success (simple)
class WithdrawalSuccessScreen extends StatelessWidget {
  const WithdrawalSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _baseSuccessScaffold(
      context,
      title: 'Withdrawal\nSuccessful',
      message: 'You have withdrawn your funds successfully.',
      primaryButtonLabel: 'Done',
      onPrimary: () {},
    );
  }
}

/// Loan repayment success
class LoanRepaymentSuccessScreen extends StatelessWidget {
  const LoanRepaymentSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _baseSuccessScaffold(
      context,
      title: 'Repayment\nSuccessful',
      message: 'Your loan repayment was successful.',
      primaryButtonLabel: 'View Loan',
      onPrimary: () {},
    );
  }
}

/// Airtime purchase success
class AirtimeSuccessScreen extends StatelessWidget {
  const AirtimeSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _baseSuccessScaffold(
      context,
      title: 'Airtime\nPurchased',
      message: 'Airtime purchase successful.',
      primaryButtonLabel: 'Done',
      onPrimary: () {},
    );
  }
}

/// Generic success fallback
class GenericSuccessScreen extends StatelessWidget {
  const GenericSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _baseSuccessScaffold(
      context,
      title: 'Successful',
      message: 'Transaction completed successfully.',
      primaryButtonLabel: 'Done',
      onPrimary: () {},
    );
  }
}

Widget _baseSuccessScaffold(
  BuildContext context, {
  required String title,
  required String message,
  required String primaryButtonLabel,
  required VoidCallback onPrimary,
}) {
  return Scaffold(
    backgroundColor: const Color(0xFF142B71),
    body: SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 176.h,
                width: 168.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xff52D17C), Color(0xff22918B)],
                  ),
                ),
                child: Center(
                  child: Icon(Icons.check, color: Colors.white, size: 90.sp),
                ),
              ),
              SizedBox(height: 30.h.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.h.h),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70, fontSize: 15.sp),
              ),
              SizedBox(height: 50.h.h),
              ElevatedButton(
                onPressed: onPrimary,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD602),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  primaryButtonLabel,
                  style: TextStyle(
                    color: Color(0xFF142B71),
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              SizedBox(height: 16.h.h),
              ElevatedButton(
                onPressed:
                    () => Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/homepage',
                      (route) => false,
                    ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD602),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(
                    color: Color(0xFF142B71),
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
