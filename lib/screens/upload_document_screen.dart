import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _showUploadOptions(BuildContext context, String title) async {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
    ),
    builder: (_) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.folder_open),
                title: const Text('Choose file'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Choose file tapped for $title')),
                  );
                  // TODO: integrate file picker here (e.g. file_picker package)
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take photo'),
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Take photo tapped for $title')),
                  );
                  // TODO: integrate camera capture here (e.g. image_picker package)
                },
              ),
              ListTile(
                leading: const Icon(Icons.close),
                title: const Text('Cancel'),
                onTap: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class UploadDocument extends StatelessWidget {
  const UploadDocument({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'icon': Icons.upload_file,
        'title': 'NIN Slip',
        'subtitle': 'Click here to upload file',
      },
      {
        'icon': Icons.upload_file,
        'title': 'Utility Bill',
        'subtitle': 'Not more than  months old \n Click here to upload file',
      },
      {
        'icon': Icons.upload_file,
        'title': 'Employment ID',
        'subtitle': 'Click here to upload file',
      },
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: const Color(0xFF142B71),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Upload Documents',
                style: Constants.kSignupTextstyle,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 30),
                  itemBuilder: (context, index) {
                    final it = items[index];
                    return _InfoCard(
                      icon: it['icon'] as IconData,
                      title: it['title'] as String,
                      subtitle: it['subtitle'] as String,
                      color: const Color(0xFFF5F8FF),
                      onTap: () => _showUploadOptions(context, it['title'] as String),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xff142B71),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextButton(
                  onPressed: () => _markKycDoneAndReturn(context),
                  child: const Text(
                    'Submit',
                    style: Constants.kloginTextstyle,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // call this when KYC/upload completes successfully
  Future<void> _markKycDoneAndReturn(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('kycCompleted', true);
   debugPrint('Set kycCompleted = true');
  
  await Future.delayed(const Duration(milliseconds: 300));
  
  if (!context.mounted) return;
  Navigator.pushReplacementNamed(context, '/homepage');
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
            Icon(icon, color: const Color(0xFFA4BEFF), size: 44),
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
          ],
        ),
      ),
    );
  }
}

