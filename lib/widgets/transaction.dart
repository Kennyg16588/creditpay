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
        'icon': Icons.account_balance_wallet,
      },
      {
        'title': 'GOTV Subscription',
        'date': 'Oct 18, 2025',
        'amount': '₦45.50',
        'icon': Icons.tv,
      },
      {
        'title': 'Bills',
        'date': 'Oct 17, 2025',
        'amount': '₦260.00',
        'icon': Icons.receipt_long,
      },
      {
        'title': 'Transfer',
        'date': 'Oct 15, 2025',
        'amount': '₦320.00',
        'icon': Icons.send,
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
                  child: Text('Recent transactions', style: Constants.kSignupTextstyle),
                ),
            const SizedBox(height: 12),

            // -> Make only this area scrollable
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: ListView.separated(
                  itemCount: recentTransactions.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final tx = recentTransactions[index];
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      elevation: 2,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        leading: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0XFF142B71),
                          ),
                          height: 93,
                          width: 83,
                          child: Icon(tx['icon'] as IconData, color: Color(0xffA4BEFF)),
                        ),
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