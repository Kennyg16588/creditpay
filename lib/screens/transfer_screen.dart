import 'package:flutter/material.dart';

class TransferScreen extends StatelessWidget {
  const TransferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF142B71)),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Select Transfer Option',
            style: TextStyle(color: Color(0xFF142B71), fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Where',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF142B71),
                ),
              ),
              const Text(
                'To Send',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF142B71),
                ),
              ),
              const SizedBox(height: 20),

              // 🔹 Other Banks Button
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF142B71),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.account_balance, color: Colors.white, size: 26),
                    SizedBox(width: 12),
                    Text(
                      'Other Banks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 🔹 Transfer Form
              SizedBox(
                height: 684,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDADADA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Enter Amount',
                        style: TextStyle(
                          color: Color(0xFF142B71),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                
                      // 💰 Amount Field
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            width: 50,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(8),
                               bottomLeft: Radius.circular(8),),
                              // border: Border.all(color: Color(0xffB3B3B3)),
                              color: Color(0xFF142B71),
                            ),
                            child: const Text(
                              '₦',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          hintText: 'Enter amount',
                          filled: true,
                          fillColor: Color(0xFFDADADA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                
                      // 🏦 Select Bank Dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.account_balance, color: Color(0xFF142B71)),
                          filled: true,
                          fillColor: Color(0xFFDADADA),
                          hintText: 'Select Bank',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Access', child: Text('Access Bank')),
                          DropdownMenuItem(value: 'GTB', child: Text('GT Bank')),
                          DropdownMenuItem(value: 'Zenith', child: Text('Zenith Bank')),
                        ],
                        onChanged: (value) {},
                      ),
                      const SizedBox(height: 15),
                
                      // 🔢 Account Number
                      TextField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'Account Number',
                          filled: true,
                          fillColor: Color(0xFFDADADA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                
                      // 📝 Description
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Description',
                          filled: true,
                          fillColor: Color(0xFFDADADA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                
                      // 💾 Save Beneficiary Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Save Beneficiary',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF142B71),
                            ),
                          ),
                          Switch(
                            value: false,
                            onChanged: (_) {},
                            activeColor: const Color(0xFF142B71),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                
                      // ✅ Verify Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/confirm_pin');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD700),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Verify',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF142B71),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
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