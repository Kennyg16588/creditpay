import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';
import 'package:creditpay/screens/confirm_pin_screen.dart';
import 'package:creditpay/constants/constants.dart';

class AirtimeScreen extends StatelessWidget {
  AirtimeScreen({super.key});

  final TextEditingController amountController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final List<int> quickAmounts = [200, 1000, 2000];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AirtimeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: const Color(0xFF142B71),
            size: 24.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Airtime", style: Constants.kSignupTextstyle),
            SizedBox(height: 15.h),

            /// TOP BIG PROVIDER ICONS
            Row(
              children: [
                _bigProvider(context, provider, "MTN", "images/mtn.png"),
                SizedBox(width: 15.w),
                _bigProvider(context, provider, "Airtel", "images/airtel.png"),
              ],
            ),

            SizedBox(height: 25.h),
            Text(
              "Choose an amount",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 15.h),

            Row(
              children:
                  quickAmounts.map((amount) {
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          amountController.text = amount.toString();
                          provider.setAmount(amount);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.w),
                          padding: EdgeInsets.symmetric(vertical: 12.h),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: const Color(0xFF142B71)),
                          ),
                          child: Center(
                            child: Text(
                              "₦$amount",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                                color: const Color(0xFF142B71),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),

            SizedBox(height: 25.h),
            Row(
              children: [
                Text(
                  "Amount",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
                const Spacer(),
                Consumer<WalletProvider>(
                  builder: (context, walletProvider, _) {
                    final balance = walletProvider.balance;
                    return Text(
                      "Balance: ₦${balance.toStringAsFixed(2)}",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                        color: const Color(0xFF142B71),
                      ),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 10.h),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              onChanged: (v) {
                if (v.isNotEmpty) provider.setAmount(int.parse(v));
              },
              decoration: _inputDecoration("Enter amount"),
            ),

            SizedBox(height: 25.h),
            Text(
              "Choose Network",
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 10.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _smallNetwork(context, provider, "MTN", "images/mtn.png"),
                _smallNetwork(context, provider, "Airtel", "images/airtel.png"),
                _smallNetwork(context, provider, "Glo", "images/glo.png"),
                _smallNetwork(
                  context,
                  provider,
                  "Etisalat",
                  "images/etisalat.png",
                ),
              ],
            ),

            SizedBox(height: 25.h),
            Text(
              "Phone Number",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
            ),
            SizedBox(height: 10.h),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              onChanged: provider.setPhoneNumber,
              decoration: _inputDecoration("Enter phone number"),
            ),

            SizedBox(height: 35.h),

            /// PROCEED BUTTON
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                onPressed:
                    provider.isValid
                        ? () {
                          final amount = amountController.text.trim();
                          final phone = phoneController.text.trim();
                          final network =
                              provider.selectedNetwork ??
                              provider.selectedProvider ??
                              "Network";

                          Provider.of<TransactionFlowProvider>(
                            context,
                            listen: false,
                          ).setPendingAction(
                            TransactionType.airtimePurchase,
                            payload: {
                              'amount': amount,
                              'description': "Airtime $network ($phone)",
                            },
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ConfirmPinScreen(),
                            ),
                          );
                        }
                        : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF142B71),
                  disabledBackgroundColor: Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  "Proceed",
                  style: TextStyle(
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  Widget _bigProvider(
    BuildContext context,
    AirtimeProvider provider,
    String name,
    String img,
  ) {
    final isSelected = provider.selectedProvider == name;

    return GestureDetector(
      onTap: () => provider.setProvider(name),
      child: Container(
        width: 75.w,
        height: 75.h,
        padding: EdgeInsets.all(10.w),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? const Color(0xFF142B71) : Colors.grey.shade400,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Image.asset(img, fit: BoxFit.cover),
      ),
    );
  }

  Widget _smallNetwork(
    BuildContext context,
    AirtimeProvider provider,
    String name,
    String img,
  ) {
    final isSelected = provider.selectedNetwork == name;

    return GestureDetector(
      onTap: () => provider.setNetwork(name),
      child: Container(
        width: 60.w,
        height: 55.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? const Color(0xFF142B71) : Colors.grey.shade400,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Image.asset(img, fit: BoxFit.contain),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF142B71)),
        borderRadius: BorderRadius.circular(8.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF142B71)),
        borderRadius: BorderRadius.circular(8.r),
      ),
    );
  }
}
