import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';

class NextOfKinScreen extends StatefulWidget {
  const NextOfKinScreen({super.key});

  @override
  State<NextOfKinScreen> createState() => _NextOfKinScreenState();
}

class _NextOfKinScreenState extends State<NextOfKinScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _fullName = TextEditingController();
 final TextEditingController _phone = TextEditingController();
  final TextEditingController _homeAddress = TextEditingController();
  final TextEditingController _relationship = TextEditingController();
 
  

  @override
  void dispose() {
    _fullName.dispose();
     _phone.dispose();
    _homeAddress.dispose();
    _relationship.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState?.validate() ?? false) {
      // collect values or send to backend
      final data = {
        'fullName': _fullName.text.trim(),
        'phone': _phone.text.trim(),
        'homeAddress': _homeAddress.text.trim(),
        'relationship': _relationship.text.trim(),
      };

      // show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Changes saved')),
      );
      Navigator.pushNamed(context, '/employment_info');
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
              child: Text('Next of Kin',
              style: Constants.kSignupTextstyle,),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Fill in the details of your next of kin',
              style: Constants.kHomeTextstyle,),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 40, 20,40),
                child: Form(
                  key: _formKey,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    color: Color(0xffA4BEFF),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _fullName,
                          decoration: _fieldDecoration('Full Name'),
                          textInputAction: TextInputAction.next,
                          validator: (v) => (v == null || v.trim().isEmpty) ? 'Enter full name' : null,
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
                        TextFormField(
                          controller: _homeAddress,
                          decoration: _fieldDecoration('Home Address'),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          controller: _relationship,
                          decoration: _fieldDecoration('Relationship', hint: 'e.g. Father, Sister'),
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