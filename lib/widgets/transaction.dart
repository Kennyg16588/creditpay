import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';

class Transaction extends StatelessWidget {
  const Transaction({super.key});

  @override
  Widget build(BuildContext context) {
    final recentTransactions = [
      {
        'title': 'Loan Payment',
        'date': 'Oct 19, 2025',
        'amount': '₦120.00',
      },
      {
        'title': 'GOTV Subscription',
        'date': 'Oct 18, 2025',
        'amount': '₦45.50',
      },
      {
        'title': 'Bills',
        'date': 'Oct 17, 2025',
        'amount': '₦260.00',
      },
      {
        'title': 'Transfer',
        'date': 'Oct 15, 2025',
        'amount': '₦320.00',
      },
    ];
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pushNamed(context, '/homepage'),
            icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          ),
          backgroundColor: Colors.white, 
          elevation: 0, 
          foregroundColor: const Color(0xFF142B71),
          ),
          body: Column(crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Row(
                    children: [
                      Text('Transaction History', style: Constants.kSignupTextstyle),
                    ],
                  ),
                ),
            const SizedBox(height: 40),
            Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Container(
                    height: 45,
                  width: 115,
                  decoration: BoxDecoration(
                    border: Border.all(color: Color(0xffE0E0E0)),
                  ),
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('All', style: Constants.kSignupTextstyle),
                        ),
                      IconButton(onPressed: (){}, icon: Icon(Icons.arrow_drop_down,
                      size: 32,
                      color: Color(0XFF142B71),),),
                      ],
                    ),),
                ),
             SizedBox(height: 20),
            // -> Make only this area scrollable
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: ListView.builder(
                  itemCount: recentTransactions.length,
                  // separatorBuilder: (_, __) => const SizedBox(height: 0),
                  itemBuilder: (context, index) {
                    final tx = recentTransactions[index];
                    return Container(
                      decoration: BoxDecoration(
                      color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Color(0xffA4BEFF)),
                        )
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                        title: Text(
                          tx['title'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(tx['date'] as String),
                        trailing: Text(
                          tx['amount'] as String,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        onTap: () {},
                      ),
                    );
                  },
                ),
              ),
            ),
            ],
          ),),
        );
  }
}