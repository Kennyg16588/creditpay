import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class LoanPersonalInfo extends StatefulWidget {
  const LoanPersonalInfo({super.key});

  @override
  State<LoanPersonalInfo> createState() => _LoanPersonalInfoState();
}

class _LoanPersonalInfoState extends State<LoanPersonalInfo> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  String? employmentStatus;
  String? incomeRange;

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
          "Personal Information",
          style: Constants.kHomeTextstyle,
        ),
      ),

      body: Padding(
        padding:EdgeInsets.symmetric(horizontal: 20.r),
        child: ListView(
          children: [
             Text(
              "kindly select the necessary details",
              style: TextStyle(
                fontSize: 14.sp,
                color: Color(0xFF142B71),
              ),
            ),
             SizedBox(height: 25.h),

            // FULL NAME
             Text(
              "Full Name",
              style: Constants.kHomeTextstyle,
            ),
             SizedBox(height: 5.h),
            _inputField(controller: nameController, hint: "Please enter your name"),

             SizedBox(height: 20.h),

            // EMPLOYMENT STATUS
             Text(
              "Employment Status",
              style: Constants.kHomeTextstyle,
            ),
             SizedBox(height: 5.h),
            _dropdownField(
              value: employmentStatus,
              items: ["Employed", "Unemployed", "Self-employed"],
              onChanged: (v) => setState(() => employmentStatus = v),
            ),

             SizedBox(height: 20.h),

            // INCOME
             Text(
              "Income",
              style: Constants.kHomeTextstyle,
            ),
            SizedBox(height: 5.h),
            _dropdownField(
              value: incomeRange,
              items: ["Below ₦50000", "₦50000 - ₦200,000", "Above ₦200,000"],
              onChanged: (v) => setState(() => incomeRange = v),
            ),

             SizedBox(height: 20.h),

            // AGE
             Text(
              "Age",
              style: Constants.kHomeTextstyle,
            ),
             SizedBox(height: 5.h),
            _inputField(controller: ageController, hint: "", keyboardType: TextInputType.number),

             SizedBox(height: 20.h),

            // HOME ADDRESS
             Text(
              "Home Address",
              style: Constants.kHomeTextstyle,
            ),
             SizedBox(height: 5.h),
            _inputField(controller: addressController, hint: ""),

             SizedBox(height: 200.h),

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
                  Navigator.pushNamed(context, '/loan_bverify');
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
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF142B71), width: 2.w),
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding:  EdgeInsets.symmetric(horizontal: 15.r),
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
        borderRadius: BorderRadius.circular(12.r),
      ),
      padding:  EdgeInsets.symmetric(horizontal: 15.r),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor:Colors.white,
          value: value,
          hint: const Text(""),
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF142B71)),
        ),
      ),
    );
  }
}
