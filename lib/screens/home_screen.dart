import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // You can add navigation or logic here
    });
  }

  final List<Map<String, dynamic>> _actions = [
    {
      'icon': Icons.request_page,
      'label': 'Loan\nRequest',
      'tooltip': 'Loan\nRequest',
      'onPressed': () {},
    },
    {
      'icon': Icons.receipt_long,
      'label': 'Bills\nPayment',
      'tooltip': 'Bills\n Payment',
      'onPressed': () {},
    },
    {
      'icon': Icons.money_off,
      'label': 'Withdraw\n',
      'tooltip': 'Withdraw\n',
      'onPressed': () {},
    },
    {
      'icon': Icons.send,
      'label': 'Transfer\n',
      'tooltip': 'Transfer\n',
      'onPressed': () {},
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Wrap content in a scrollable view to avoid overflow and make structure clearer
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.blue[900],
                          radius: 35,
                          child: Icon(Icons.person, size: 50, color: Colors.white),
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Hi Ajoke!',
                          style: Constants.kSignupTextstyle,
                        ),
                        Spacer(),
                        Icon(
                          Icons.notifications,
                          size: 40,
                          color: Colors.blue[900],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: Card(
                        color: Colors.blue[900],
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, top: 30),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Balance',
                                style: Constants.kloginbuttonsytle2,
                              ),
                              SizedBox(height: 20),
                              Text(
                                '£21,020.00',
                                style: Constants.kloginTextstyle,
                              ),
                              SizedBox(height: 50),
                              Row(
                                children: [
                                  Container(
                                    height: 44,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Current Loan',
                                        style: Constants.kHomeTextstyle,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 40),
                                  Container(
                                    height: 44,
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'My Statistics',
                                        style: Constants.kHomeTextstyle,
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
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(_actions.length, (index) {
                      final action = _actions[index];
                      return Column(
                        children: [
                          Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: IconButton(
                              icon: Icon(action['icon'], color: Colors.blue[900]),
                              onPressed: action['onPressed'],
                              iconSize: 40,
                              tooltip: action['tooltip'],
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            action['label'],
                            style: TextStyle(
                              color: Colors.blue[900],
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    }),
                  ),
                  SizedBox(height: 40),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60.0, bottom: 20.0),
                child: Text(
                  'Recent transactions',
                  style: Constants.kSignupTextstyle,
                ),
              ),
      
                      Padding(
                        padding: const EdgeInsets.only(left: 60.0, bottom: 20.0),
                        child: Container(
                          height: 100,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.blue[900],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.account_balance_wallet, color: Colors.grey),
                            onPressed: () {},
                            iconSize: 60,
                          ),
                        ),
                      ),
                Padding(
                        padding: const EdgeInsets.only(left: 60.0, bottom: 20.0),
                        child: Container(
                          height: 100,
                          width: 120,
                          decoration: BoxDecoration(
                            color: Colors.blue[900],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: IconButton(
                            icon: Icon(Icons.tv, color: Colors.grey),
                            onPressed: () {},
                            iconSize: 60,
                          ),
                        ),
                      ),
              
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        backgroundColor: Colors.blue[900],
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Transaction',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: 'Loans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}