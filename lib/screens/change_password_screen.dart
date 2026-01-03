import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:creditpay/constants/constants.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentCtrl = TextEditingController();
  final TextEditingController _newCtrl = TextEditingController();
  final TextEditingController _confirmCtrl = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _loading = false;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _updatePassword() async {
    if (_currentCtrl.text.isEmpty ||
        _newCtrl.text.isEmpty ||
        _confirmCtrl.text.isEmpty) {
      _showMessage("Please fill all fields");
      return;
    }

    if (_newCtrl.text != _confirmCtrl.text) {
      _showMessage("New passwords do not match");
      return;
    }

    if (_newCtrl.text.length < 6) {
      _showMessage("New password must be at least 6 characters");
      return;
    }

    setState(() => _loading = true);

    try {
      final user = _auth.currentUser!;
      
      // Reauthenticate user with current password
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentCtrl.text.trim(),
      );

      await user.reauthenticateWithCredential(credential);

      // Update password
      await user.updatePassword(_newCtrl.text.trim());

      if (!mounted) return;
      _showMessage("Password updated successfully!", isSuccess: true);

      Navigator.pop(context); // Go back after success
    } on FirebaseAuthException catch (e) {
      String error = "Password update failed";
      if (e.code == "wrong-password") {
        error = "Current password is incorrect";
      } else if (e.code == "weak-password") {
        error = "New password is too weak";
      } else if (e.code == "requires-recent-login") {
        error = "Please login again to continue";
      }
      _showMessage(error);
    } catch (_) {
      _showMessage("An error occurred. Try again.");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _showMessage(String msg, {bool isSuccess = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isSuccess ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.white,
      ),
      body: Padding( 
        padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 10.h), 
        child: 
        Column( crossAxisAlignment: CrossAxisAlignment.start,
         children: [ Text( "Change Password", style: Constants.kSignupTextstyle, ),
          SizedBox(height: 10.h), 
          Text( "You can create a new password here.", 
          style: TextStyle( fontSize: 14.sp, color: Colors.black54, ), ), 
          SizedBox(height: 35.h),
            /// Current Password
            TextField(
              controller: _currentCtrl,
              obscureText: !_showCurrent,
              decoration: InputDecoration(
                labelText: "Current Password",
                // filled: true,
                // fillColor: const Color(0xffA4BEFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showCurrent ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0XFF142B71),
                  ),
                  onPressed: () =>
                      setState(() => _showCurrent = !_showCurrent),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            /// New Password
            TextField(
              controller: _newCtrl,
              obscureText: !_showNew,
              decoration: InputDecoration(
                labelText: "New Password",
                // filled: true,
                // fillColor: const Color(0xffA4BEFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showNew ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0XFF142B71),
                  ),
                  onPressed: () => setState(() => _showNew = !_showNew),
                ),
              ),
            ),
            SizedBox(height: 20.h),

            /// Confirm New Password
            TextField(
              controller: _confirmCtrl,
              obscureText: !_showConfirm,
              decoration: InputDecoration(
                labelText: "Confirm New Password",
                // filled: true,
                // fillColor: const Color(0xffA4BEFF),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    _showConfirm ? Icons.visibility : Icons.visibility_off,
                    color: const Color(0XFF142B71),
                  ),
                  onPressed: () =>
                      setState(() => _showConfirm = !_showConfirm),
                ),
              ),
            ),
            SizedBox(height: 30.h),

            /// Update Button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0XFF142B71),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: TextButton(
                onPressed: _loading ? null : _updatePassword,
                child: _loading
                    ? SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: const CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
                        "Update Password",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
