import 'package:creditpay/screens/loan_personal_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';

class Loan extends StatefulWidget {
  const Loan({super.key});

  @override
  State<Loan> createState() => _LoanState();
}

class _LoanState extends State<Loan> {
  final List<String> amounts = [
   '₦10,000',
   '₦20,000',
   '₦30,000',
   '₦50,000',
   '₦100,000',
   'Enter\nAmount', // handled differently below
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
              SizedBox(height: 30), 
              Padding( 
                padding: const EdgeInsets.only(bottom: 40), 
                child: Text('Loan Request', style: Constants.kSignupTextstyle,), ),
                
                 Text('Select a loan offer', style: Constants.kHomeTextstyle,),
              const SizedBox(height: 60),

              // 🔹 Action Buttons
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: amounts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  // mainAxisSpacing: 10,
                  crossAxisSpacing: 50,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      InkWell(
                        onTap: () {
              context.read<LoanProvider>().setSelectedAmount(amounts[index]);
                if ((index) == 5){
                  Navigator.pushNamed(context, '/enter_amount');
                }

                  else{
                  Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => LoanPersonalInfo()),
              );
                };
              
            },
                        borderRadius: BorderRadius.circular(50),
                        child: Container(alignment: Alignment.center,
                          height: 80,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Color(0xFF142B71), width: 1),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                        amounts[index],
                        style: const TextStyle(
                          color: Color(0xFF142B71),
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          height: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                    ],
                  );
                },
              ),
              const SizedBox(height: 60),
              Text('Select a Repayment Plan', style: Constants.kSignupTextstyle,),
               const SizedBox(height: 20),
              GestureDetector(
                child: Container(alignment: Alignment.center,
                            height: 60,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Color(0xFF142B71), width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                                          'Loan Repayment',
                                                          style: const TextStyle(
                                                            color: Color(0xFF142B71),
                                                            fontSize: 15,
                                                            height: 1.2,
                                                          ),
                                                        ),
                                                        const SizedBox(width: 20),
                                     Icon(Icons.arrow_drop_down_outlined),                  
                                ],
                              ),
                            ),
                          ),
                          onTap: (){
                            Navigator.pushNamed(context, '/loan_repay');
                          },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
