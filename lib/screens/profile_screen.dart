import 'package:creditpay/constants/constants.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'icon': Icons.person,
        'title': 'Account Information',
        'route': '/accountinfo',
      },
      {
        'icon': Icons.badge,
        'title': 'Account Tier',
        'route': '/tier',
      },
      {
        'icon': Icons.lock,
        'title': 'Security Settings',
        'route': '/security',
      },
      {
        'icon': Icons.feedback,
        'title': 'Support & Feedback',
        'route': '/upload_doc',
      },
       {
        'icon': Icons.help,
        'title': 'Contact Us',
        'route': '/employment_info',
      },
      {
        'icon': Icons.logout,
        'title': 'Log Out',
        'route': '/login',
      },
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Navigator.pushNamed(context, '/homepage');
            },
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: const Color(0xFF142B71),
        ),
        body: 
          Column(crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(height: 165,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF142B71),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xffD9D9D9B2),
                          child: IconButton(onPressed:(){}, icon: Icon(Icons.camera_alt,
                          size: 30,
                          color: Colors.white,
                          ),),
                        ),
                        SizedBox(width: 130,),
                        Column(
                          children: [
                            Text('Sanni Ajoke',
                             style: Constants.kloginTextstyle,
                            ),
                            SizedBox(height: 10),
                            Container(decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Color(0xffFFD602),
                            ),
                                height: 38,
                              child: TextButton(onPressed: (){
                                Navigator.pushNamed(context, '/tier');
                              }, child: Text('Upgrade Account',
                              style: Constants.kHomeTextstyle,))),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final it = items[index];
                    final isLogout = it['title'] == 'Log Out';
                    return _InfoCard(
                      icon: it['icon'] as IconData,
                      title: it['title'] as String,
                      color: Colors.white,
                      onTap: () => Navigator.pushNamed(context, it['route'] as String),
                          textColor: isLogout ? Colors.red : const Color(0xFF142B71),
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
  // final String subtitle;
  final Color color;
  final VoidCallback onTap;
  // final Color iconColor;
  final Color textColor;

  const _InfoCard({
    required this.icon,
    required this.title,
    // required this.subtitle,
    required this.color,
    required this.onTap,
    // required this.iconColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Color(0xff142B71).withOpacity(0.3)),
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
            Icon(icon, color: const Color(0xFF142B71), size: 24),
            const SizedBox(width: 30),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style:  TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 6),
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

