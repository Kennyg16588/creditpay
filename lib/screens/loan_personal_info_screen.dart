import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';


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
        title: const Text(
          "Personal Information",
          style: Constants.kHomeTextstyle,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            const Text(
              "kindly select the necessary details",
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF142B71),
              ),
            ),
            const SizedBox(height: 25),

            // FULL NAME
            const Text(
              "Full Name",
              style: Constants.kHomeTextstyle,
            ),
            const SizedBox(height: 5),
            _inputField(controller: nameController, hint: "Please enter your name"),

            const SizedBox(height: 20),

            // EMPLOYMENT STATUS
            const Text(
              "Employment Status",
              style: Constants.kHomeTextstyle,
            ),
            const SizedBox(height: 5),
            _dropdownField(
              value: employmentStatus,
              items: ["Employed", "Unemployed", "Self-employed"],
              onChanged: (v) => setState(() => employmentStatus = v),
            ),

            const SizedBox(height: 20),

            // INCOME
            const Text(
              "Income",
              style: Constants.kHomeTextstyle,
            ),
            const SizedBox(height: 5),
            _dropdownField(
              value: incomeRange,
              items: ["Below ₦50000", "₦50000 - ₦200,000", "Above ₦200,000"],
              onChanged: (v) => setState(() => incomeRange = v),
            ),

            const SizedBox(height: 20),

            // AGE
            const Text(
              "Age",
              style: Constants.kHomeTextstyle,
            ),
            const SizedBox(height: 5),
            _inputField(controller: ageController, hint: "", keyboardType: TextInputType.number),

            const SizedBox(height: 20),

            // HOME ADDRESS
            const Text(
              "Home Address",
              style: Constants.kHomeTextstyle,
            ),
            const SizedBox(height: 5),
            _inputField(controller: addressController, hint: ""),

            const SizedBox(height: 240),

            // NEXT BUTTON
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D2D6C),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/loan_bverify');
                },
                child: const Text(
                  "Next",
                  style: Constants.kloginTextstyle,
                ),
              ),
            ),

            const SizedBox(height: 25),
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
        border: Border.all(color: const Color(0xFF142B71), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
        border: Border.all(color: const Color(0xFF142B71), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 15),
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
