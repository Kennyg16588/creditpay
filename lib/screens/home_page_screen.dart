import 'package:creditpay/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:creditpay/widgets/home.dart';
import 'package:creditpay/widgets/transaction.dart';
import 'package:creditpay/widgets/loan.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final auth = Provider.of<AuthProvider>(context, listen: false);
      if (!auth.kycCompleted) {
        debugPrint(
          '⚠️ KYC not completed for ${auth.email}. Redirecting to KYC screen...',
        );
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/kyc');
      } else {
        debugPrint('✅ KYC completed for ${auth.email}');
      }
    });
  }

  final List<Widget> _pages = [Home(), Transaction(), Loan(), ProfileScreen()];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final shouldLogout = await showDialog<bool>(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Log out?'),
                content: const Text(
                  'Are you sure you want to log out and exit?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
        );

        if (shouldLogout == true) {
          final auth = Provider.of<AuthProvider>(context, listen: false);
          await auth.signOut();
          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        }
      },
      child: Scaffold(
        body: IndexedStack(index: _selectedIndex, children: _pages),
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
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet),
              label: 'Transaction',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.pie_chart),
              label: 'Loans',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
          ],
        ),
      ),
    );
  }
}
