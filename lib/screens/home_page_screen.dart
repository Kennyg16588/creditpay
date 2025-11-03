
import 'package:creditpay/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:creditpay/widgets/home.dart';
import 'package:creditpay/widgets/transaction.dart';
import 'package:creditpay/widgets/loan.dart';


class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedIndex = 0;


  @override
  void  initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) async {
    final prefs = await SharedPreferences.getInstance();
    final bool kycDone = prefs.getBool('kycCompleted') ?? false;
    if (!kycDone) {
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pushReplacementNamed(context, '/kyc');
    }
  });
}

final List<Widget> _pages = [
  Home(),
  Transaction(),
  Loan(),
  ProfileScreen(),
];

  void _onItemTapped(int index) {
  setState(() => _selectedIndex = index);
}


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: IndexedStack( 
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        backgroundColor: Color(0XFF142B71),
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Color(0xffA4BEFF),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet), label: 'Transaction'),
          BottomNavigationBarItem(icon: Icon(Icons.pie_chart), label: 'Loans'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}