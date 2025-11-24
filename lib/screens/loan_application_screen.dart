import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';
import 'package:creditpay/constants/constants.dart';


class LoanApplicationPage extends StatefulWidget {
  const LoanApplicationPage({super.key});

  @override
  State<LoanApplicationPage> createState() => _LoanApplicationPageState();
}

class _LoanApplicationPageState extends State<LoanApplicationPage> {
  final purposeController = TextEditingController();
  final periodController = TextEditingController(text: "6 months");
  final interestController = TextEditingController(text: "5%");
  final installmentController = TextEditingController(text: "₦35,000 Per month");

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
        title: const Text(
          "Loan Application",
          style: Constants.kHomeTextstyle,
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // AMOUNT FIELD (READ-ONLY)
            Text("Amount",
            style: Constants.kHomeTextstyle),
            const SizedBox(height: 5),
            Container(decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF142B71), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
              child: TextField(
                style: Constants.kloanTextstyle,
                readOnly: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: selectedAmount.isEmpty ? "Select amount" : selectedAmount,
                      ),
                    ),
            ),
            const SizedBox(height: 20),

            // PURPOSE
            
            Text("Purpose",
            style: Constants.kHomeTextstyle),
            const SizedBox(height: 5),
            _inputField(controller: purposeController, hint: "Reason for loan"),
            const SizedBox(height: 20),

            // PERIOD
            Text("Period",
            style: Constants.kHomeTextstyle),
            const SizedBox(height: 5),
             _inputField(controller: periodController, hint: ""),
            const SizedBox(height: 20),

            // INTEREST
            Text("Interest",
            style:Constants.kHomeTextstyle),
            const SizedBox(height: 5),
             _inputField(controller: interestController, hint: ""),
            const SizedBox(height: 20),

            // INSTALLMENT
            Text("Installment",
            style: Constants.kHomeTextstyle),
            const SizedBox(height: 5),
             _inputField(controller: installmentController, hint: ""),
            const SizedBox(height: 20),

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
            const SizedBox(height: 20),

            // CONFIRM BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: agreeToTerms ? () {
                   Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoanApproval()),
      );
                } : null,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Color(0xFF142B71),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Confirm",
                style: Constants.kloginTextstyle,
              ),),
            ),
            const SizedBox(height: 20),

            // CANCEL BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.popAndPushNamed(context, '/homepage'),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Color(0xFFA4BEFF),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text("Cancel",
                style: Constants.kloginTextstyle,
              ),
            ),),
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
        border: Border.all(color: const Color(0xFF142B71), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextField(
        style: Constants.kloanTextstyle,
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
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
                  'Congratulations!\nYour loan has been\napproved!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF142B71),
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your loan has been sucessfully\ncredited into your account!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF142B71),
                    fontSize: 18,
                  ),
                ),

                const SizedBox(height: 24),

                // NEW: Loan summary card
                Card(color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _detailRow('Next Repayment Date', nextRepayment),
                        const Divider(),
                        _detailRow('Interest Rate', interestRate),
                        const Divider(),
                        _detailRow('Monthly Repayment', monthlyRepayment),
                        const Divider(),
                        _detailRow('No. of Payments', numberOfPayments),
                        const Divider(),
                        _detailRow('Purpose', purpose),
                        const Divider(),
                        _detailRow('Total Payment Amount', totalPayment, emphasize: true),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 70),
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
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF142B71),
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: TextStyle(
              color: Color(0xFF142B71),
              fontSize: emphasize ? 16 : 14,
              fontWeight: emphasize ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}