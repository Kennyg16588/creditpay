import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';

class EnterAmount extends StatefulWidget {
  const EnterAmount({super.key});

  @override
  State<EnterAmount> createState() => _EnterAmountState();
}

class _EnterAmountState extends State<EnterAmount> {
  final TextEditingController _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: const Color(0xFF142B71),
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),

              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Image.asset('images/image1.png'),
              ),

              Text('Type your loan amount', style: Constants.kHomeTextstyle),
              const SizedBox(height: 60),

              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter amount",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF142B71)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              GestureDetector(
                onTap: () {
                  final enteredAmount = _amountController.text.trim();

                  if (enteredAmount.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please enter an amount")),
                    );
                    return;
                  }

                  // Save into Provider
                  context
                      .read<LoanProvider>()
                      .setSelectedAmount("₦$enteredAmount");

                  // Navigate to Loan Personal Info Page
                  Navigator.pushNamed(context, '/loan_pinfo');
                },
                child: Container(
                  alignment: Alignment.center,
                  height: 60,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF142B71),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Next',
                    style: Constants.kloginTextstyle,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
