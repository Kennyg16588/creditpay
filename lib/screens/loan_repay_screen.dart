import 'package:creditpay/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';

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
        title: const Text(
          "Loan Repayment",
          style: TextStyle(
            color: Color(0xFF1A2F75),
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            // -----------------------
            // Payment Options
            // -----------------------
            const Text("Select a repayment option",
                style: Constants.kHomeTextstyle),
            const SizedBox(height: 12),

            Row(
              children: [
                _paymentOption(
                    title: "Part Payment",
                    selected: provider.isPartPayment,
                    onTap: () =>
                        provider.togglePaymentType(true)),
                const SizedBox(width: 10),
                _paymentOption(
                    title: "Full Payment",
                    selected: !provider.isPartPayment,
                    onTap: () =>
                        provider.togglePaymentType(false)),
              ],
            ),

            const SizedBox(height: 45),

            // -----------------------
            // Amount Input
            // -----------------------
            const Text("Enter the amount you want to pay",
                style: Constants.kHomeTextstyle),
            const SizedBox(height: 10),

            TextField(
              keyboardType: TextInputType.number,
              onChanged: provider.updateAmount,
              decoration: InputDecoration(
                hintText: "₦35,000",
                hintStyle: Constants.kloanTextstyle,
                prefixStyle: Constants.kloanTextstyle,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      const BorderSide(color: Color(0xFF1A2F75), width: 1.4),
                ),
              ),
            ),

            const SizedBox(height: 45),

            const Text("Pay with",
                style: Constants.kHomeTextstyle),
            const SizedBox(height: 10),

            _bankTile(),

            const SizedBox(height: 45),

            const Text(
              "You are about to make a loan repayment of",
              style: Constants.kHomeTextstyle,
            ),

            const SizedBox(height: 15),

            _summaryBox(summary),

            const SizedBox(height: 165),

            // -----------------------
            // Make Payment Button
            // -----------------------
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: provider.isLoading
                    ? null
                    : () async {
                        bool result = await provider.submitRepayment();
                        if (result) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Payment Successful"),
                                backgroundColor: Colors.green),
                          );
                         Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoanApproval()),
      );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Payment Failed"),
                                backgroundColor: Colors.red),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1A2F75),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: provider.isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "Make Payment",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600),
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
          height: 45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: selected ? const Color(0xFFE6F6FF) : Colors.white,
            border: Border.all(
                color: selected ? const Color(0xFF142B71) : Colors.grey),
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(title,
                    style: TextStyle(
                        color: selected
                            ? const Color(0xFF142B71)
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.w600)),
                if (selected)
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Icon(Icons.check_circle,
                        color: Color(0xFF18B81E), size: 18),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bankTile() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(0xFF142B71)),
      ),
      child: Row(
        children: [
          Image.asset("images/image1.png", height: 32),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Access Bank***0016",
                    style:
                        Constants.kloanTextstyle),
                SizedBox(height: 3),
                Text("Service fee 0.00",
                    style: Constants.kloanTextstyle),
              ],
            ),
          ),
          TextButton(onPressed: (){}, child: Text('Change',
            style: Constants.kloanTextstyle),),
        ],
      ),
    );
  }

  Widget _summaryBox(summary) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xFF142B71)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _summaryRow("Amount", "₦${summary.amount.toStringAsFixed(0)}"),
          const SizedBox(height: 10),
          _summaryRow("Service fee", "₦${summary.serviceFee.toStringAsFixed(2)}"),
          const Divider(),
          _summaryRow("Total", "₦${summary.total.toStringAsFixed(0)}",
              bold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: Constants.kloanTextstyle),
        Text(value,
            style: Constants.kloanTextstyle),
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 176,
                  width: 168,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      const Color(0xff52D17C),
                      const Color(0xff22918B),
                    ]),
                  ),
                  child: const Center(
                    child: Icon(Icons.check, color: Colors.white, size: 90),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Repayment Sucessful',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF142B71),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                  const SizedBox(height: 170),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/homepage');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF142B71),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Go back to Home',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),],
                ),),),),);
  }
  }