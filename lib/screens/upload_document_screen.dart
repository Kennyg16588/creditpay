import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

import 'package:creditpay/services/cloudinary_service.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> _showUploadOptions(BuildContext context, String title) async {
  final picker = ImagePicker();

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
    ),
    builder: (_) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.folder_open),
                title: const Text('Choose file'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.custom,
                    allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
                  );
                  if (result == null || result.files.isEmpty) return;
                  final path = result.files.single.path;
                  if (path == null) return;
                  final file = File(path);
                  await _uploadFile(context, file, title);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final picked = await picker.pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 80,
                  );
                  if (picked == null) return;
                  final file = File(picked.path);
                  await _uploadFile(context, file, title);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final picked = await picker.pickImage(
                    source: ImageSource.camera,
                    imageQuality: 80,
                  );
                  if (picked == null) return;
                  final file = File(picked.path);
                  await _uploadFile(context, file, title);
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

// helper: upload file to Firebase Storage and save url in SharedPreferences
// helper: upload file to Cloudinary and save url in SharedPreferences and Firestore
Future<void> _uploadFile(BuildContext context, File file, String title) async {
  final scaffold = ScaffoldMessenger.of(context);
  try {
    scaffold.showSnackBar(const SnackBar(content: Text('Uploading...')));
    final auth = Provider.of<AuthProvider>(context, listen: false);
    final user = auth.user;
    if (user == null) {
      scaffold.showSnackBar(
        const SnackBar(
          content: Text('You must be logged in to upload'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final ext = file.path.split('.').last.toLowerCase();

    // Determine resource type based on extension
    CloudinaryResourceType resourceType = CloudinaryResourceType.Auto;
    if (['jpg', 'jpeg', 'png'].contains(ext)) {
      resourceType = CloudinaryResourceType.Image;
    } else {
      resourceType = CloudinaryResourceType.Raw;
    }

    final cloudinaryService = CloudinaryService();
    final downloadUrl = await cloudinaryService.uploadFile(
      file,
      folder: 'kyc/${user.uid}',
      resourceType: resourceType,
    );

    if (downloadUrl == null) {
      scaffold.showSnackBar(
        const SnackBar(
          content: Text('Upload failed'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // save url in SharedPreferences under key 'kyc_<title>'
    final key = 'kyc_${title.replaceAll(' ', '_').toLowerCase()}';

    // update provider and Firestore
    await auth.updateUserData({key: downloadUrl});

    scaffold.hideCurrentSnackBar();
    scaffold.showSnackBar(
      const SnackBar(
        content: Text('Uploaded successfully'),
        backgroundColor: Colors.green,
      ),
    );
    debugPrint('Uploaded $title -> $downloadUrl');
  } catch (e) {
    debugPrint('Upload error: $e');
    scaffold.showSnackBar(
      SnackBar(content: Text('Upload error: $e'), backgroundColor: Colors.red),
    );
  }
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
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.only(left: 20.r),
              child: Text(
                'Upload Documents',
                style: Constants.kSignupTextstyle,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(20.r),
                child: FutureBuilder<SharedPreferences>(
                  future: SharedPreferences.getInstance(),
                  builder: (context, snapshot) {
                    final prefs = snapshot.data;
                    return ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => SizedBox(height: 30.h),
                      itemBuilder: (context, index) {
                        final it = items[index];
                        final title = it['title'] as String;
                        final key =
                            'kyc_${title.replaceAll(' ', '_').toLowerCase()}';
                        final isUploaded = prefs?.getString(key) != null;

                        return _InfoCard(
                          icon: it['icon'] as IconData,
                          title: title,
                          subtitle:
                              isUploaded
                                  ? '✅ File uploaded'
                                  : it['subtitle'] as String,
                          color:
                              isUploaded
                                  ? Colors.green.withOpacity(0.05)
                                  : Colors.white,
                          onTap: () async {
                            await _showUploadOptions(context, title);
                            // rebuild to show status
                            (context as Element).markNeedsBuild();
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.r, 20.r, 20.r, 80.r),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xff142B71),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextButton(
                  onPressed: () => _markKycDoneAndReturn(context),
                  child: Text('Submit', style: Constants.kloginTextstyle),
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
    // Navigator.pushReplacementNamed(context, '/homepage');
    // final kyc = Provider.of<KycProvider>(context, listen: false);
    // await kyc.setCompleted(true);

    // After successful KYC submission
    final auth = Provider.of<AuthProvider>(context, listen: false);
    await auth.completeKyc();

    // Then navigate
    Navigator.pushNamedAndRemoveUntil(context, '/homepage', (route) => false);
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
        height: 113.h,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Color(0xff142B71).withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6.r,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF142B71), size: 44.r),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF142B71),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12.sp, color: Colors.black54),
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
