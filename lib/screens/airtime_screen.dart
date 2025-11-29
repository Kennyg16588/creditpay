import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';
import 'package:creditpay/screens/confirm_pin_screen.dart';

class AirtimeScreen extends StatelessWidget {
  AirtimeScreen({super.key});

  final TextEditingController amountController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final List<int> quickAmounts = [200, 1000, 2000];
  final double balance = 21020.00;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AirtimeProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF142B71)),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
          "Airtime",
          style: TextStyle(
            color: Color(0xFF142B71),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 15),
            /// TOP BIG PROVIDER ICONS
            Row(
              children: [
                _bigProvider(context, provider, "MTN", "images/mtn.png"),
                const SizedBox(width: 15),
                _bigProvider(context, provider, "Airtel", "images/airtel.png"),
              ],
            ),

            const SizedBox(height: 25),
            const Text("Choose an amount",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 15),

            Row(
              children: quickAmounts.map((amount) {
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      amountController.text = amount.toString();
                      provider.setAmount(amount);
                    },
                    child: Container(
                       margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFF142B71)),
                      ),
                      child: Center(
                        child: Text(
                          "₦$amount",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF142B71)),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 25),
            Row(
              children: [
                const Text("Amount",
                    style: TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                Text(
                  "Balance: ₦${balance.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF142B71)),
                ),
              ],
            ),

            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              onChanged: (v) {
                if (v.isNotEmpty) provider.setAmount(int.parse(v));
              },
              decoration: _inputDecoration("Enter amount"),
            ),

            const SizedBox(height: 25),
            const Text("Choose Network",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _smallNetwork(context, provider, "MTN", "images/mtn.png"),
                _smallNetwork(context, provider, "Airtel", "images/airtel.png"),
                _smallNetwork(context, provider, "Glo", "images/glo.png"),
                _smallNetwork(context, provider, "Etisalat", "images/etisalat.png"),
              ],
            ),

            const SizedBox(height: 25),
            const Text("Phone Number",
                style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),

            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              onChanged: provider.setPhoneNumber,
              decoration: _inputDecoration("Enter phone number"),
            ),

            const SizedBox(height: 35),

            /// PROCEED BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: provider.isValid
                    ? () {Provider.of<TransactionFlowProvider>(context, listen: false)
    .setPendingAction(TransactionType.billPayment, payload:{});

Navigator.push(
  context,
  MaterialPageRoute(builder: (_) =>  ConfirmPinScreen()),
);
} 
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF142B71),
                  disabledBackgroundColor: Colors.grey.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Proceed",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _bigProvider(context, AirtimeProvider provider, String name, String img) {
    final isSelected = provider.selectedProvider == name;

    return GestureDetector(
      onTap: () => provider.setProvider(name),
      child: Container(
        width: 75,
        height: 75,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? const Color(0xFF142B71) : Colors.grey.shade400,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: Image.asset(img, fit: BoxFit.cover,),
      ),
    );
  }

  Widget _smallNetwork(context, AirtimeProvider provider, String name, String img) {
    final isSelected = provider.selectedNetwork == name;

    return GestureDetector(
      onTap: () => provider.setNetwork(name),
      child: Container(
        width: 60,
        height: 55,
        // padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF142B71) : Colors.grey.shade400,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Image.asset(img,fit: BoxFit.contain,),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      // filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF142B71)),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder:  OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFF142B71)),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
