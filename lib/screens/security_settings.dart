import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';

class SecuritySettings extends StatelessWidget {
  const SecuritySettings({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'title': 'Biometric Unlock',
        'route': '/personal_info',
      },
      {
        'title': 'Change Password',
        'route': '/next_of_kin',
      },
      {
        'title': 'Change Transaction PIN',
        'route': '/set_pin',
      },
      {
        'title': 'Reset PIN',
        'route': '/upload_doc',
      },
      {
        'title': 'Set Security Questions',
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
              child: Text('Security Settings',
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
                      title: it['title'] as String,
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
  final String title;
  final VoidCallback onTap;

  const _InfoCard({
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xff142B71).withOpacity(0.3)),
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

