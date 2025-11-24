import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _dob = TextEditingController();
  final TextEditingController _gender = TextEditingController();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _state = TextEditingController();
  final TextEditingController _postalCode = TextEditingController();
  final TextEditingController _phone = TextEditingController();

  @override
  void dispose() {
    _firstName.dispose();
    _lastName.dispose();
    _dob.dispose();
    _gender.dispose();
    _address.dispose();
    _city.dispose();
    _state.dispose();
    _postalCode.dispose();
    _phone.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      // collect values or send to backend
      // final data = {
      //   'firstName': _firstName.text.trim(),
      //   'lastName': _lastName.text.trim(),
      //   'dob': _dob.text.trim(),
      //   'gender': _gender.text.trim(),
      //   'address': _address.text.trim(),
      //   'city': _city.text.trim(),
      //   'state': _state.text.trim(),
      //   'postalCode': _postalCode.text.trim(),
      //   'phone': _phone.text.trim(),
      // };

      // show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved')),
      );
        Navigator.pushNamed(context, '/next_of_kin');
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
              child: Text('Personal Information',
              style: Constants.kSignupTextstyle,),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Please provide details of yourself',
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
                          controller: _firstName,
                          decoration: _fieldDecoration('First Name'),
                          textInputAction: TextInputAction.next,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter first name' : null,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _lastName,
                          decoration: _fieldDecoration('Last Name'),
                          textInputAction: TextInputAction.next,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter last name' : null,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _dob,
                          decoration: _fieldDecoration('Date of Birth', hint: 'YYYY-MM-DD'),
                          keyboardType: TextInputType.datetime,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _gender,
                          decoration: _fieldDecoration('Gender', hint: 'e.g. Male / Female'),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _address,
                          decoration: _fieldDecoration('Address'),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _city,
                          decoration: _fieldDecoration('City'),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _state,
                          decoration: _fieldDecoration('State / Province'),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _postalCode,
                          decoration: _fieldDecoration('Postal Code'),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _phone,
                          decoration: _fieldDecoration('Phone Number', hint: '+234...'),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter phone number' : null,
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