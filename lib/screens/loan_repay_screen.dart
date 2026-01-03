import 'package:creditpay/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoanRepaymentPage extends StatelessWidget {
  const LoanRepaymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoanRepaymentProvider>();
    final summary = provider.summary;

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A2F75)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Loan Repayment",
          style: TextStyle(
            color: Color(0xFF1A2F75),
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30.h),

            // -----------------------
            // Payment Options
            // -----------------------
            Text("Select a repayment option", style: Constants.kHomeTextstyle),
            SizedBox(height: 12.h),

            Row(
              children: [
                _paymentOption(
                  title: "Part Payment",
                  selected: provider.isPartPayment,
                  onTap: () => provider.togglePaymentType(true),
                ),
                SizedBox(width: 10.w),
                _paymentOption(
                  title: "Full Payment",
                  selected: !provider.isPartPayment,
                  onTap: () => provider.togglePaymentType(false),
                ),
              ],
            ),

            SizedBox(height: 45.h),

            // -----------------------
            // Amount Input
            // -----------------------
            Text(
              "Enter the amount you want to pay",
              style: Constants.kHomeTextstyle,
            ),
            SizedBox(height: 10.h),

            TextField(
              keyboardType: TextInputType.number,
              onChanged: provider.updateAmount,
              decoration: InputDecoration(
                hintText: "₦35,000",
                hintStyle: Constants.kloanTextstyle,
                prefixStyle: Constants.kloanTextstyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(
                    color: Color(0xFF1A2F75),
                    width: 1.4.w,
                  ),
                ),
              ),
            ),

            SizedBox(height: 45.h),

            Text("Pay with", style: Constants.kHomeTextstyle),
            SizedBox(height: 10.h),

            _bankTile(),

            SizedBox(height: 45.h),

            Text(
              "You are about to make a loan repayment of",
              style: Constants.kHomeTextstyle,
            ),

            SizedBox(height: 15.h),

            _summaryBox(summary),

            SizedBox(height: 125.h),

            // -----------------------
            // Make Payment Button
            // -----------------------
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                onPressed:
                    provider.isLoading
                        ? null
                        : () async {
                          bool result = await provider.submitRepayment(context);
                          if (result) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Payment Successful"),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoanApproval(),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Payment Failed"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A2F75),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child:
                    provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          "Make Payment",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------
  // WIDGET METHODS
  // -------------------------------------------

  Widget _paymentOption({
    required String title,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 45.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: selected ? const Color(0xFFE6F6FF) : Colors.white,
            border: Border.all(
              color: selected ? const Color(0xFF142B71) : Colors.grey,
            ),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color:
                        selected
                            ? const Color(0xFF142B71)
                            : Colors.grey.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (selected)
                  Padding(
                    padding: EdgeInsets.only(left: 5.r),
                    child: Icon(
                      Icons.check_circle,
                      color: Color(0xFF18B81E),
                      size: 18.sp,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bankTile() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.r, vertical: 12.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Color(0xFF142B71)),
      ),
      child: Row(
        children: [
          Image.asset("images/access.png", height: 32.h),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Access Bank***0016", style: Constants.kloanTextstyle),
                SizedBox(height: 3.h),
                Text("Service fee 0.00", style: Constants.kloanTextstyle),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text('Change', style: Constants.kloanTextstyle),
          ),
        ],
      ),
    );
  }

  Widget _summaryBox(summary) {
    return Container(
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF142B71)),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          _summaryRow("Amount", "₦${summary.amount.toStringAsFixed(0)}"),
          SizedBox(height: 10.h),
          _summaryRow(
            "Service fee",
            "₦${summary.serviceFee.toStringAsFixed(2)}",
          ),
          const Divider(),
          _summaryRow(
            "Total",
            "₦${summary.total.toStringAsFixed(0)}",
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Constants.kloanTextstyle),
        Text(value, style: Constants.kloanTextstyle),
      ],
    );
  }
}

class LoanApproval extends StatelessWidget {
  const LoanApproval({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.r),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 176.h,
                  width: 168.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xff52D17C),
                        const Color(0xff22918B),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.check, color: Colors.white, size: 90),
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  'Repayment Sucessful',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF142B71),
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                SizedBox(height: 170.h),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/homepage',
                      (route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF142B71),
                    minimumSize: Size(double.infinity, 50.sp),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Go back to Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
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
}
