
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';


class DataScreen extends StatefulWidget {
  const DataScreen({super.key});
  @override
  State<DataScreen> createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  int selectedNetwork = -1;
  final TextEditingController serviceCtrl = TextEditingController();
  final TextEditingController packageCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();

  void _onProceed() {
    if (selectedNetwork < 0 || packageCtrl.text.isEmpty || phoneCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill all fields')));
      return;
    }

    final provider = Provider.of<TransactionFlowProvider>(context, listen: false);

    // Save the pending action and optional payload (amount/phone/package)
    provider.setPendingAction(TransactionType.billPayment, payload: {
      'network': selectedNetwork == 0 ? 'MTN' : 'Airtel',
      'package': packageCtrl.text,
      'phone': phoneCtrl.text,
    });

    // Navigate to the unified ConfirmPinScreen (it will check pinProvider state)
    Navigator.pushNamed(context, '/confirm_pin');
  }

  @override
  Widget build(BuildContext context) {
    // Example: using the uploaded image file if you want:
    // final uploadedImagePath = '/mnt/data/6f865d51-a924-49a5-a75d-5b9de4a7d112.png';
    // Image.file(File(uploadedImagePath))

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, leading: IconButton(icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF142B71)), onPressed: () => Navigator.pop(context))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          const Text('Data', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF142B71))),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(mainAxisAlignment: MainAxisAlignment.start, 
            children: [
              _networkOption(0, 'images/mtn.png', '3.2GB for\n2 Days'),
              const SizedBox(width: 15),
              _networkOption(1, 'images/airtel.png', '5GB for\n7 Days'),
            ]),
          ),
          const SizedBox(height: 24),
          const Text('Service Provider', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(controller: serviceCtrl, decoration: _inputDecoration('Service Provider')),
          const SizedBox(height: 12),
          const Text('Package', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(controller: packageCtrl, decoration: _inputDecoration('Package (e.g. 5GB)')),
          const SizedBox(height: 12),
          const Text('Phone Number', style: TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          TextField(controller: phoneCtrl, keyboardType: TextInputType.phone, decoration: _inputDecoration('Enter phone number')),
          const SizedBox(height: 44),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(onPressed: _onProceed, 
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF142B71),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))), 
            child: const Text('Proceed', 
            style:  TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),)),
          ),
        ]),
      ),
    );
  }

  Widget _networkOption(int idx, String assetPath, String label) {
    final selected = selectedNetwork == idx;
    return GestureDetector(
      onTap: () => setState(() => selectedNetwork = idx),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(shape: BoxShape.circle, 
            border: Border.all(color: selected ? const Color(0xFF142B71) : Colors.grey.shade300, width: 2)),
            child: Image.asset(assetPath, height: 60, width: 60, fit: BoxFit.cover,
          
            ),
          ),
          const SizedBox(height: 6),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF142B71))),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xFF142B71)), borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Color(0xFF142B71)), borderRadius: BorderRadius.circular(8)),
      );
}
