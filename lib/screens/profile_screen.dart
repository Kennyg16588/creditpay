import 'package:creditpay/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  bool _isUploading = false;

  // 🔹 PICK IMAGE FROM CAMERA
  Future<void> _pickImageFromCamera() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      setState(() => _isUploading = true);

      final auth = Provider.of<AuthProvider>(context, listen: false);
      final imageFile = File(pickedFile.path);

      debugPrint('📁 Camera image path: ${imageFile.path}');
      debugPrint('📁 File size: ${imageFile.lengthSync()} bytes');

      final photoUrl = await auth.uploadProfileImage(imageFile, auth.uid ?? '');

      if (!mounted) return;

      setState(() => _isUploading = false);

      if (photoUrl != null) {
        debugPrint('✅ Photo URL: $photoUrl');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Profile picture updated!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Failed to upload picture'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Camera error: $e');
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  // 🔹 PICK IMAGE FROM GALLERY
  Future<void> _pickImageFromGallery() async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile == null) return;

      setState(() => _isUploading = true);

      final auth = Provider.of<AuthProvider>(context, listen: false);
      final imageFile = File(pickedFile.path);

      debugPrint('📁 Gallery image path: ${imageFile.path}');
      debugPrint('📁 File size: ${imageFile.lengthSync()} bytes');

      final photoUrl = await auth.uploadProfileImage(imageFile, auth.uid ?? '');

      if (!mounted) return;

      setState(() => _isUploading = false);

      if (photoUrl != null) {
        debugPrint('✅ Photo URL: $photoUrl');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Profile picture updated!'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Failed to upload picture'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      debugPrint('❌ Gallery error: $e');
      if (mounted) {
        setState(() => _isUploading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  void _showImagePickerOptions() {
    showModalBottomSheet(
      context: context,
      builder:
          (ctx) => Container(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.camera),
                  title: const Text('Take a Photo'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImageFromCamera();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.image),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(ctx);
                    _pickImageFromGallery();
                  },
                ),
              ],
            ),
          ),
    );
  }

  final List<Map<String, dynamic>> items = [
    {
      'icon': Icons.person,
      'title': 'Account Information',
      'route': '/accountinfo',
    },
    {'icon': Icons.badge, 'title': 'Account Tier', 'route': '/tier'},
    {'icon': Icons.lock, 'title': 'Security Settings', 'route': '/security'},
    {
      'icon': Icons.feedback,
      'title': 'Support & Feedback',
      'route': '/support_feedback',
    },
    {'icon': Icons.help, 'title': 'Contact Us', 'route': '/support_feedback'},
    {'icon': Icons.logout, 'title': 'Log Out', 'route': '/login'},
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/homepage');
            },
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: const Color(0xFF142B71),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 165.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF142B71),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Stack(
                        children: [
                          Consumer<AuthProvider>(
                            builder: (context, authProvider, _) {
                              final photoUrl = authProvider.photo;

                              if (photoUrl != null && photoUrl.isNotEmpty) {
                                return CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey[300],
                                  backgroundImage: NetworkImage(photoUrl),
                                  onBackgroundImageError: (
                                    exception,
                                    stackTrace,
                                  ) {
                                    debugPrint(
                                      '❌ Image load error: $exception',
                                    );
                                  },
                                );
                              }

                              return CircleAvatar(
                                radius: 50,
                                backgroundColor: const Color(0xffD9D9D9B2),
                                child: Icon(
                                  Icons.person,
                                  size: 50.sp,
                                  color: Colors.white,
                                ),
                              );
                            },
                          ),
                          Positioned(
                            width: 32,
                            height: 32,
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap:
                                  _isUploading ? null : _showImagePickerOptions,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: const Color(0xffFFD602),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2.w,
                                  ),
                                ),
                                padding: EdgeInsets.all(8.r),
                                child:
                                    _isUploading
                                        ? SizedBox(
                                          width: 16.sp,
                                          height: 16.sp,
                                          child:
                                              const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                      Color
                                                    >(Color(0xFF142B71)),
                                              ),
                                        )
                                        : Icon(
                                          Icons.camera_alt,
                                          size: 10.sp,
                                          color: const Color(0xFF142B71),
                                        ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Consumer<AuthProvider>(
                              builder: (context, authProvider, _) {
                                final firstName =
                                    authProvider.firstName ?? 'User';
                                final lastName = authProvider.lastName ?? '';
                                return Text(
                                  '$firstName $lastName'.trim(),
                                  style: Constants.kloginTextstyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                );
                              },
                            ),
                            SizedBox(height: 10.h),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.r),
                                color: const Color(0xffFFD602),
                              ),
                              height: 38.h,
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/tier');
                                },
                                child: Text(
                                  'Upgrade Account',
                                  style: Constants.kHomeTextstyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
                  separatorBuilder: (_, __) => SizedBox(height: 20.h),
                  itemBuilder: (context, index) {
                    final it = items[index];
                    final isLogout = it['title'] == 'Log Out';
                    return _InfoCard(
                      icon: it['icon'] as IconData,
                      title: it['title'] as String,
                      color: Colors.white,
                      onTap: () {
                        if (isLogout) {
                          _showLogoutDialog(context);
                        } else {
                          Navigator.pushNamed(context, it['route'] as String);
                        }
                      },
                      textColor:
                          isLogout ? Colors.red : const Color(0xFF142B71),
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

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Log Out'),
            content: const Text('Are you sure you want to log out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await Provider.of<AuthProvider>(
                    context,
                    listen: false,
                  ).signOut();
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (_) => false,
                  );
                },
                child: const Text(
                  'Log Out',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback onTap;
  final Color textColor;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.color,
    required this.onTap,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45.h,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: const Color(0xff142B71).withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12.r),
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
            Icon(icon, color: const Color(0xFF142B71), size: 24.sp),
            SizedBox(width: 30.w),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}
