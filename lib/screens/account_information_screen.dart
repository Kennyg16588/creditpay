import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';

class AccountInformationScreen extends StatelessWidget {
  const AccountInformationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'icon': Icons.person,
        'title': 'Personal Information',
        'subtitle': 'Name, DOB, Address',
        'route': '/personal_info',
      },
      {
        'icon': Icons.group,
        'title': 'Next of Kin Information',
        'subtitle': 'Contact & relation',
        'route': '/next_of_kin',
      },
      {
        'icon': Icons.work,
        'title': 'Employment Information',
        'subtitle': 'Employer details',
        'route': '/employment_info',
      },
      {
        'icon': Icons.upload_file,
        'title': 'Upload Documents',
        'subtitle': 'ID, Payslip, KYC',
        'route': '/upload_doc',
      },
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Navigator.pushNamed(context, '/profile');
            },
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: const Color(0xFF142B71),
        ),
        body: 
          Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Account Information',
              style: Constants.kSignupTextstyle,),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final it = items[index];
                    return _InfoCard(
                      icon: it['icon'] as IconData,
                      title: it['title'] as String,
                      subtitle: it['subtitle'] as String,
                      color: const Color(0xFFF5F8FF),
                      onTap: () => Navigator.pushNamed(context, it['route'] as String),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: const Color(0xFF142B71),
              child: Icon(icon, color: const Color(0xFFA4BEFF), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF142B71),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}

