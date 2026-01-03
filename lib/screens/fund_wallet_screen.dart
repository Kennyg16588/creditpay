import 'package:creditpay/providers/app_providers.dart';
import 'package:creditpay/services/paystack_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class FundWalletScreen extends StatefulWidget {
  const FundWalletScreen({super.key});

  @override
  State<FundWalletScreen> createState() => _FundWalletScreenState();
}

class _FundWalletScreenState extends State<FundWalletScreen> {
  final TextEditingController _amountCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  Future<void> _initiatePayment() async {
    final amountText = _amountCtrl.text.replaceAll(',', '').trim();
    if (amountText.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter an amount')));
      return;
    }

    final double? amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invalid amount')));
      return;
    }

    // Get user email
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final email = authProvider.email;

    if (email == null || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User email not found. Please login again.'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final paystack = PaystackService();
      final reference = paystack.generateReference();

      final success = await paystack.chargeCard(
        context: context,
        amount: amount,
        email: email,
        reference: reference,
      );

      if (success && mounted) {
        // Credit the wallet in Firestore
        await Provider.of<WalletProvider>(
          context,
          listen: false,
        ).creditWallet(amount);

        if (mounted) {
          Provider.of<NotificationProvider>(
            context,
            listen: false,
          ).addNotification(
            title: 'Wallet Funded',
            message: 'You have successfully funded your wallet with ₦$amount',
            icon: Icons.account_balance_wallet,
          );
        }

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Successfully funded wallet with ₦$amount'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context); // Return to previous screen
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment cancelled or failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Fund Wallet'),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF142B71),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter Amount',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF142B71),
              ),
            ),
            SizedBox(height: 10.h),
            TextFormField(
              controller: _amountCtrl,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
              ],
              style: TextStyle(fontSize: 18.sp, color: Colors.black),
              decoration: InputDecoration(
                prefixText: '₦ ',
                hintText: '0.00',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(color: Color(0xFF142B71)),
                ),
              ),
            ),
            SizedBox(height: 40.h),
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _initiatePayment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF142B71),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
                child:
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                          'Proceed to Pay',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
