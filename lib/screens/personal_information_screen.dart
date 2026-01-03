import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
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

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  Future<void> _loadCurrentData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // 1. Try Provider first (most up-to-date in memory)
    setState(() {
      _firstName.text = authProvider.firstName ?? '';
      _lastName.text = authProvider.lastName ?? '';
      _phone.text = authProvider.mobile ?? '';
    });

    // 2. Try SharedPreferences (fallback/persistent)
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      if (_firstName.text.isEmpty) {
        _firstName.text = prefs.getString('firstName') ?? '';
      }
      if (_lastName.text.isEmpty) {
        _lastName.text = prefs.getString('lastName') ?? '';
      }
      if (_phone.text.isEmpty) {
        _phone.text = prefs.getString('mobile') ?? '';
      }

      _dob.text = prefs.getString('dob') ?? '';
      _gender.text = prefs.getString('gender') ?? '';
      _address.text = prefs.getString('address') ?? '';
      _city.text = prefs.getString('city') ?? '';
      _state.text = prefs.getString('state') ?? '';
      _postalCode.text = prefs.getString('postalCode') ?? '';
    });
  }

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

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _loading = true);

      final data = {
        'firstName': _firstName.text.trim(),
        'lastName': _lastName.text.trim(),
        'dob': _dob.text.trim(),
        'gender': _gender.text.trim(),
        'address': _address.text.trim(),
        'city': _city.text.trim(),
        'state': _state.text.trim(),
        'postalCode': _postalCode.text.trim(),
        'mobile': _phone.text.trim(),
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
        Navigator.pushNamed(context, '/next_of_kin');
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
            'Personal Information',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.r),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.r),
              child: Text(
                'Please provide details of yourself',
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
                          controller: _firstName,
                          readOnly: true,
                          decoration: _fieldDecoration('First Name').copyWith(
                            suffixIcon: const Icon(
                              Icons.lock_outline,
                              size: 18,
                              color: Colors.blueGrey,
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 12.h),
                        TextFormField(
                          controller: _lastName,
                          readOnly: true,
                          decoration: _fieldDecoration('Last Name').copyWith(
                            suffixIcon: const Icon(
                              Icons.lock_outline,
                              size: 18,
                              color: Colors.blueGrey,
                            ),
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: _dob,
                          decoration: _fieldDecoration(
                            'Date of Birth',
                            hint: 'YYYY-MM-DD',
                          ),
                          keyboardType: TextInputType.datetime,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: _gender,
                          decoration: _fieldDecoration(
                            'Gender',
                            hint: 'e.g. Male / Female',
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: _address,
                          decoration: _fieldDecoration('Address'),
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: _city,
                          decoration: _fieldDecoration('City'),
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: _state,
                          decoration: _fieldDecoration('State / Province'),
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: _postalCode,
                          decoration: _fieldDecoration('Postal Code'),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: _phone,
                          readOnly: true,
                          decoration: _fieldDecoration('Phone Number').copyWith(
                            suffixIcon: const Icon(
                              Icons.lock_outline,
                              size: 18,
                              color: Colors.blueGrey,
                            ),
                          ),
                          keyboardType: TextInputType.phone,
                          textInputAction: TextInputAction.done,
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
