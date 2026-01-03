import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class LoanBankVerify extends StatefulWidget {
  const LoanBankVerify({super.key});

  @override
  State<LoanBankVerify> createState() => _LoanBankVerifyState();
}

class _LoanBankVerifyState extends State<LoanBankVerify> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? bank;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF142B71)),
          onPressed: () => Navigator.pop(context),
        ),
        title:  Text(
          "Bank Verification",
          style: Constants.kHomeTextstyle,
        ),
      ),

      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal: 20.r),
        child: ListView(
          children: [
             Text(
              "kindly input your bank information",
              style: TextStyle(
                fontSize: 14.sp,
                color: Color(0xFF142B71),
              ),
            ),
             SizedBox(height: 25.h),

            // BVN
             Text(
              "BVN",
              style: Constants.kHomeTextstyle,
            ),
             SizedBox(height: 5.h),
            _inputField(controller: nameController, hint: ""),

             SizedBox(height: 20.h),

            // ACCOUNT NUMBER
             Text(
              "Account Number",
              style: Constants.kHomeTextstyle,
            ),
             SizedBox(height: 5.h),
            _inputField(controller: addressController, hint: ""),
            

             SizedBox(height: 20.h),

            // BANK
             Text(
              "Bank",
              style: Constants.kHomeTextstyle,
            ),
             SizedBox(height: 5.h),
            _dropdownField(
              value: bank,
              items: ["GTB", "Access", "Palmpay"],
              onChanged: (v) => setState(() => bank = v),
            ),

             SizedBox(height: 240.h),

            // NEXT BUTTON
            SizedBox(
              width: double.infinity,
              height: 55.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D2D6C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/loan_application');
                },
                child:  Text(
                  "Next",
                  style: Constants.kloginTextstyle,
                ),
              ),
            ),

            SizedBox(height: 25.h),
          ],
        ),
      ),
    );
  }

  // TEXT FIELD WIDGET
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.number,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF142B71), width: 2.w),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15.r),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
        ),
      ),
    );
  }

  // DROPDOWN FIELD WIDGET
  Widget _dropdownField({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF142B71), width: 2.w),
        borderRadius: BorderRadius.circular(12),
      ),
      padding:  EdgeInsets.symmetric(horizontal: 15.r),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor:Colors.white,
          value: value,
          hint: const Text("Select bank"),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF142B71)),
        ),
      ),
    );
  }
}
