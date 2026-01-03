import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';
import 'package:creditpay/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoanApplicationPage extends StatefulWidget {
  const LoanApplicationPage({super.key});

  @override
  State<LoanApplicationPage> createState() => _LoanApplicationPageState();
}

class _LoanApplicationPageState extends State<LoanApplicationPage> {
  final purposeController = TextEditingController();
  final periodController = TextEditingController(text: "6 months");
  final interestController = TextEditingController(text: "5%");
  final installmentController = TextEditingController(
    text: "₦35,000 Per month",
  );

  bool agreeToTerms = false;

  @override
  Widget build(BuildContext context) {
    final selectedAmount = context.watch<LoanProvider>().selectedAmount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF142B71)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Loan Application", style: Constants.kHomeTextstyle),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.r, vertical: 10.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // AMOUNT FIELD (READ-ONLY)
            Text("Amount", style: Constants.kHomeTextstyle),
            SizedBox(height: 5.h),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0xFF142B71), width: 2.w),
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 15.h),
              child: TextField(
                style: Constants.kloanTextstyle,
                readOnly: true,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText:
                      selectedAmount.isEmpty ? "Select amount" : selectedAmount,
                ),
              ),
            ),
            SizedBox(height: 20.h),

            // PURPOSE
            Text("Purpose", style: Constants.kHomeTextstyle),
            SizedBox(height: 5.h),
            _inputField(controller: purposeController, hint: "Reason for loan"),
            SizedBox(height: 20.h),

            // PERIOD
            Text("Period", style: Constants.kHomeTextstyle),
            SizedBox(height: 5.h),
            _inputField(controller: periodController, hint: ""),
            SizedBox(height: 20.h),

            // INTEREST
            Text("Interest", style: Constants.kHomeTextstyle),
            SizedBox(height: 5.h),
            _inputField(controller: interestController, hint: ""),
            SizedBox(height: 20.h),

            // INSTALLMENT
            Text("Installment", style: Constants.kHomeTextstyle),
            SizedBox(height: 5.h),
            _inputField(controller: installmentController, hint: ""),
            SizedBox(height: 20.h),

            // TERMS CHECKBOX
            Row(
              children: [
                Checkbox(
                  value: agreeToTerms,
                  onChanged: (value) {
                    setState(() => agreeToTerms = value!);
                  },
                ),
                const Text("Accept our Terms and Conditions"),
              ],
            ),
            SizedBox(height: 20.h),

            // CONFIRM BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    (agreeToTerms && !context.watch<LoanProvider>().isLoading)
                        ? () async {
                          bool success = await context
                              .read<LoanProvider>()
                              .applyForLoan(context);
                          if (success) {
                            if (context.mounted) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoanApproval(),
                                ),
                              );
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Loan Application Failed"),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  backgroundColor: const Color(0xFF142B71),
                  padding: EdgeInsets.symmetric(vertical: 14.r),
                ),
                child:
                    context.watch<LoanProvider>().isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text("Confirm", style: Constants.kloginTextstyle),
              ),
            ),
            SizedBox(height: 20.h),

            // CANCEL BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    () => Navigator.popAndPushNamed(context, '/homepage'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  backgroundColor: Color(0xFFA4BEFF),
                  padding: EdgeInsets.symmetric(vertical: 14.r),
                ),
                child: Text("Cancel", style: Constants.kloginTextstyle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _inputField({
  required TextEditingController controller,
  required String hint,
  TextInputType keyboardType = TextInputType.text,
}) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(color: const Color(0xFF142B71), width: 2.w),
      borderRadius: BorderRadius.circular(12.r),
    ),
    padding: EdgeInsets.symmetric(horizontal: 15.r),
    child: TextField(
      style: Constants.kloanTextstyle,
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(border: InputBorder.none, hintText: hint),
    ),
  );
}

class LoanApproval extends StatelessWidget {
  const LoanApproval({super.key});

  @override
  Widget build(BuildContext context) {
    // loan details (replace with dynamic values if available)
    const nextRepayment = '30/05/2025';
    const interestRate = '5%';
    const monthlyRepayment = '₦35,000';
    const numberOfPayments = '6';
    const purpose = 'To purchase goods for resale';
    const totalPayment = '₦210,000';

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
                  child: Center(
                    child: Icon(Icons.check, color: Colors.white, size: 90.sp),
                  ),
                ),
                SizedBox(height: 30.h),
                Text(
                  'Congratulations!\nYour loan has been\napproved!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF142B71),
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16.h),
                Text(
                  'Your loan has been sucessfully\ncredited into your account!',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Color(0xFF142B71), fontSize: 18.sp),
                ),

                SizedBox(height: 24.h),

                // NEW: Loan summary card
                Card(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      children: [
                        _detailRow('Next Repayment Date', nextRepayment),
                        Divider(),
                        _detailRow('Interest Rate', interestRate),
                        Divider(),
                        _detailRow('Monthly Repayment', monthlyRepayment),
                        Divider(),
                        _detailRow('No. of Payments', numberOfPayments),
                        Divider(),
                        _detailRow('Purpose', purpose),
                        Divider(),
                        _detailRow(
                          'Total Payment Amount',
                          totalPayment,
                          emphasize: true,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 70.h),
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

  Widget _detailRow(String label, String value, {bool emphasize = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.r),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: Color(0xFF142B71), fontSize: 14.sp),
            ),
          ),
          SizedBox(width: 8.w),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF142B71),
              fontSize: emphasize ? 16.sp : 14.sp,
              fontWeight: emphasize ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
