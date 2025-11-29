import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';

class BillPaymentScreen extends StatefulWidget {
  const BillPaymentScreen({super.key});

  @override
  State<BillPaymentScreen> createState() => _BillPaymentScreenState();
}

class _BillPaymentScreenState extends State<BillPaymentScreen> {
  final List<Map<String, dynamic>> _actions = [
    {
      'image': 'images/airtime.jpg',
      'label': 'Airtime',
      'route': '/airtime',
    },
    {
      'image': 'images/data.png',
      'label': 'Data',
      'route': '/data',
    },
    {
      'image': 'images/betting.jpg',
      'label': 'Betting',
      'route': '/betting',
    },
    {
      'image': 'images/electricity.jpg',
      'label': 'Electricity',
      'route': '/elect',
    },
    {
      'image': 'images/shopping.png',
      'label': 'Shopping',
      'route': '/shop',
    },
    {
      'image': 'images/tv.png',
      'label': 'TV',
      'route': '/tv',
    },
  ];

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 40), 
              Padding( 
                padding: const EdgeInsets.only(bottom: 20), 
                child: Text('Bill Payment', style: Constants.kSignupTextstyle,), ),
              // 🔹 Balance Card
              Container(
                width: double.infinity,
                height: 151,
                decoration: BoxDecoration(
                  color: const Color(0xFF142B71),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total Balance', style: Constants.kloginbuttonsytle2),
                    const SizedBox(height: 12),
                    Text('₦21,020.00', style: Constants.kloginTextstyle),
                  ],
                ),
              ),

              const SizedBox(height: 60),

              // 🔹 Action Buttons
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _actions.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 30,
                  crossAxisSpacing: 30,
                ),
                itemBuilder: (context, index) {
                  final action = _actions[index];
                  return Column(
                    children: [
                      InkWell(
                        onTap: () =>
                            Navigator.pushNamed(context, action['route']),
                        borderRadius: BorderRadius.circular(50),
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(color: Color(0xFF142B71), width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Image.asset(
                              action['image'],
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        action['label'],
                        style: const TextStyle(
                          color: Color(0xFF142B71),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
