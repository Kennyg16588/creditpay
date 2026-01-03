import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportFeedbackScreen extends StatelessWidget {
  const SupportFeedbackScreen({Key? key}) : super(key: key);

  // ─────────── ACTION HANDLERS ───────────
  Future<void> _callSupport() async {
    final url = Uri.parse("tel:+2342012345678");
    if (await canLaunchUrl(url)) launchUrl(url);
  }

  Future<void> _emailSupport(BuildContext context) async {
  final Uri uri = Uri(
    scheme: 'mailto',
    path: 'support@creditpay.com',
  );

  try {
    bool launched = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication, // Required for mail apps
    );

    if (!launched) {
      _showNoEmailDialog(context);
    }

  } catch (e) {
    _showNoEmailDialog(context); // fallback if launch throws an error
  }
}

void _showNoEmailDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("No email app found"),
      content: const Text("Please install Gmail or an email app to proceed."),
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () => Navigator.pop(context),
        )
      ],
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color:  Color(0xff142B71),),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
          "Support & Feedback",
          style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF142B71),
                      ),
        ),
        SizedBox(height: 40.h.h),
            /// Frequently Asked Questions
            _tileButton(
              label: "Frequently Asked Questions",
              onTap: () {},
            ),
            SizedBox(height: 10.h.h),

            /// Rate Us
            _tileButton(
              label: "Rate Us",
              onTap: () {},
            ),
            SizedBox(height: 200.h.h),

            // ───────── PHONE ─────────
             Text(
              "Phone",
              style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF142B71),
                      ),
            ),
            SizedBox(height: 06.h.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text("02012345678", style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xFF142B71),
                      ),),
                InkWell(
                  onTap: _callSupport,
                  child: const Icon(Icons.phone, color: Color(0xFF142B71),),
                )
              ],
            ),

             Divider(height: 30.h),

            // ───────── EMAIL ─────────
             Text(
              "Email",
              style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF142B71),
                      ),
            ),
            SizedBox(height: 06.h.h),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text("support@creditpay.com", style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xFF142B71),
                      ),),
                InkWell(
                  onTap: () => _emailSupport(context),
                  child: const Icon(Icons.email, color: Color(0xFF142B71),),
                )
              ],
            ),

            const Spacer(),

            // ───────── LIVE CHAT ─────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D2A76),
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6.r)),
                ),
                child:  Text("Live Chat", style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),),
              ),
            ),

            SizedBox(height: 10.h.h),
             Center(
              child: Text(
                "Service time: 24hrs",
                style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xFF142B71),
                      ),
              ),
            ),

            SizedBox(height: 20.h.h),
          ],
        ),
      ),
    );
  }

  // 🔹 REUSABLE TILE BUTTON UI
  Widget _tileButton({required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(color: Color(0xFF142B71)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(
                        fontSize: 14.sp,
                        color: Color(0xFF142B71),
                      ),),
             Icon(Icons.arrow_forward_ios, size: 16.sp),
          ],
        ),
      ),
    );
  }
}

