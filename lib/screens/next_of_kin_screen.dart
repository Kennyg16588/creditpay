import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  Future<void> _loadCurrentData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _fullName.text = prefs.getString('nok_fullName') ?? '';
      _phone.text = prefs.getString('nok_phone') ?? '';
      _homeAddress.text = prefs.getString('nok_homeAddress') ?? '';
      _relationship.text = prefs.getString('nok_relationship') ?? '';
    });
  }

  @override
  void dispose() {
    _fullName.dispose();
    _phone.dispose();
    _homeAddress.dispose();
    _relationship.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _loading = true);

      final data = {
        'nok_fullName': _fullName.text.trim(),
        'nok_phone': _phone.text.trim(),
        'nok_homeAddress': _homeAddress.text.trim(),
        'nok_relationship': _relationship.text.trim(),
      };

      try {
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.updateUserData(data);

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Changes saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushNamed(context, '/employment_info');
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        if (mounted) setState(() => _loading = false);
      }
    }
  }

  InputDecoration _fieldDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 12.r, vertical: 14.r),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
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
          title: Text(
            'Next of Kin',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.r),
              child: Text(
                'Fill in the details of your next of kin',
                style: Constants.kHomeTextstyle,
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.r, 20.r, 20.r, 40.r),
                child: Form(
                  key: _formKey,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xffA4BEFF),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.all(10.r),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _fullName,
                          decoration: _fieldDecoration('Full Name'),
                          textInputAction: TextInputAction.next,
                          validator:
                              (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Enter full name'
                                      : null,
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: _phone,
                          decoration: _fieldDecoration(
                            'Phone Number',
                            hint: '+234...',
                          ),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
                          validator:
                              (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Enter phone number'
                                      : null,
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: _homeAddress,
                          decoration: _fieldDecoration('Home Address'),
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: _relationship,
                          decoration: _fieldDecoration(
                            'Relationship',
                            hint: 'e.g. Father, Sister',
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20.r, 20.r, 20.r, 40.r),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xff142B71),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: TextButton(
                  onPressed: _loading ? null : _saveChanges,
                  child:
                      _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                            'Save Changes',
                            style: Constants.kloginTextstyle,
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
