import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

final List<Map<String, dynamic>> _actions = [
    {
      'icon': Icons.request_page,
      'label': 'Loan\nRequest',
      'tooltip': 'Loan\nRequest',
      'route': '/transfer',
    },
    {
      'icon': Icons.receipt_long,
      'label': 'Bills\nPayment',
      'tooltip': 'Bills\n Payment',
      'route': '/transfer',
    },
    {
      'icon': Icons.money_off,
      'label': 'Withdraw\n',
      'tooltip': 'Withdraw\n',
      'route': '/transfer',
    },
    {
      'icon': Icons.send,
      'label': 'Transfer\n',
      'tooltip': 'Transfer\n',
      'route': '/transfer',
    },
    
  ];

  @override
  Widget build(BuildContext context) {
// recentTransactions stays defined here
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
        // keep header, balance card and actions fixed; make only transactions scrollable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header (avatar + notification)
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Color(0XFF142B71),
                    radius: 35,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Text('Hi Ajoke!', style: Constants.kSignupTextstyle),
                  const Spacer(),
                  Icon(Icons.notifications, size: 40, color: Color(0XFF142B71)),
                ],
              ),
            ),

            // Balance card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Card(
                color: Color(0XFF142B71),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Balance', style: Constants.kloginbuttonsytle2),
                      const SizedBox(height: 12),
                      Text('₦21,020.00', style: Constants.kloginTextstyle),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: Color(0xffA4BEFF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextButton(
                                onPressed: () {},
                                child: Text('Current Loan', style: Constants.kHomeTextstyle),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Container(
                              height: 44,
                              decoration: BoxDecoration(
                                color: Color(0xffA4BEFF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: TextButton(
                                onPressed: () {},
                                child: Text('My Statistics', style: Constants.kHomeTextstyle),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Actions row (4 icon buttons)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_actions.length, (index) {
                  final action = _actions[index];
                  return Column(
                    children: [
                      Container(
                        height: 70,
                        width: 70,
                        decoration: BoxDecoration(
                          color: Color(0xffA4BEFF),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: Icon(action['icon'], color: Color(0XFF142B71)),
                          onPressed: ()=> Navigator.pushNamed(context, action['route']),
                          iconSize: 32,
                          tooltip: action['tooltip'],
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: 70,
                        child: Text(
                          action['label'],
                          style: const TextStyle(
                            color: Color(0XFF142B71),
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),

            const SizedBox(height: 24),

            // Recent transactions title (fixed)
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
        ),
      );
  }
}