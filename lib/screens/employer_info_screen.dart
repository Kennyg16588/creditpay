import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';

class EmployerInfoScreen extends StatefulWidget {
  const EmployerInfoScreen({super.key});

  @override
  State<EmployerInfoScreen> createState() => _EmployerInfoScreenState();
}

class _EmployerInfoScreenState extends State<EmployerInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _companyName = TextEditingController();
  final TextEditingController _jobTitle = TextEditingController();
  final TextEditingController _doe = TextEditingController();
  final TextEditingController _monthlySalary = TextEditingController();
  final TextEditingController _companyAddress = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _country = TextEditingController();
 

  @override
  void dispose() {
    _companyName.dispose();
    _jobTitle.dispose();
    _doe.dispose();
    _monthlySalary.dispose();
    _companyAddress.dispose();
    _state.dispose();
    _country.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      // collect values or send to backend
      // final data = {
      //   'companyName': _companyName.text.trim(),
      //   'jobTitle': _jobTitle.text.trim(),
      //   'doe': _doe.text.trim(),
      //   'monthlySalary': _monthlySalary.text.trim(),
      //   'companyAddress': _companyAddress.text.trim(),
      //   'state': _state.text.trim(),
      //   'country': _country.text.trim(),
      // };

      // show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved')),
      );
        Navigator.pushNamed(context, '/upload_doc');
      // TODO: persist `data` where needed
    }
  }

  InputDecoration _fieldDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: const Color(0xFF142B71),
        ),
        body: Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Employer Info',
              style: Constants.kSignupTextstyle,),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Please provide details of your current employment',
              style: Constants.kHomeTextstyle,),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 40, 20,40),
                child: Form(
                  key: _formKey,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffA4BEFF),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _companyName,
                          decoration: _fieldDecoration('Company\'s Name'),
                          textInputAction: TextInputAction.next,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter Company\'s name' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _jobTitle,
                          decoration: _fieldDecoration('Job Title'),
                          textInputAction: TextInputAction.next,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter Job Title' : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _doe,
                          decoration: _fieldDecoration('Date of Employment', hint: 'YYYY-MM-DD'),
                          keyboardType: TextInputType.datetime,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _monthlySalary,
                          decoration: _fieldDecoration('Monthly Salary', hint: 'e.g. Male / Female'),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _companyAddress,
                          decoration: _fieldDecoration('Company\'s Address'),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _state,
                          decoration: _fieldDecoration('State'),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _country,
                          decoration: _fieldDecoration('Country'),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 80),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Color(0xff142B71),
                            borderRadius: BorderRadius.circular(10),
                            
                          ),
                        child: TextButton(
                          onPressed: _saveChanges,
                          child: const Text('Save Changes',
                          style: Constants.kloginTextstyle,),
                        ),
                                            ),
                      ),
                  
          ],
        ),
      ),
    );
  }
}