import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentData();
  }

  Future<void> _loadCurrentData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _companyName.text = prefs.getString('emp_companyName') ?? '';
      _jobTitle.text = prefs.getString('emp_jobTitle') ?? '';
      _doe.text = prefs.getString('emp_doe') ?? '';
      _monthlySalary.text = prefs.getString('emp_monthlySalary') ?? '';
      _companyAddress.text = prefs.getString('emp_companyAddress') ?? '';
      _state.text = prefs.getString('emp_state') ?? '';
      _country.text = prefs.getString('emp_country') ?? '';
    });
  }

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

  Future<void> _saveChanges() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _loading = true);

      final data = {
        'emp_companyName': _companyName.text.trim(),
        'emp_jobTitle': _jobTitle.text.trim(),
        'emp_doe': _doe.text.trim(),
        'emp_monthlySalary': _monthlySalary.text.trim(),
        'emp_companyAddress': _companyAddress.text.trim(),
        'emp_state': _state.text.trim(),
        'emp_country': _country.text.trim(),
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
        Navigator.pushNamed(context, '/upload_doc');
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
            'Employer Info',
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
                'Please provide details of your current employment',
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
                          controller: _companyName,
                          decoration: _fieldDecoration('Company\'s Name'),
                          textInputAction: TextInputAction.next,
                          validator:
                              (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Enter Company\'s name'
                                      : null,
                        ),
                        SizedBox(height: 12.h),
                        TextFormField(
                          controller: _jobTitle,
                          decoration: _fieldDecoration('Job Title'),
                          textInputAction: TextInputAction.next,
                          validator:
                              (v) =>
                                  (v == null || v.trim().isEmpty)
                                      ? 'Enter Job Title'
                                      : null,
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: _doe,
                          decoration: _fieldDecoration(
                            'Date of Employment',
                            hint: 'YYYY-MM-DD',
                          ),
                          keyboardType: TextInputType.datetime,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: _monthlySalary,
                          decoration: _fieldDecoration(
                            'Monthly Salary',
                            hint: 'e.g. 100000',
                          ),
                          keyboardType: TextInputType.number,
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: _companyAddress,
                          decoration: _fieldDecoration('Company\'s Address'),
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: _state,
                          decoration: _fieldDecoration('State'),
                          textInputAction: TextInputAction.next,
                        ),
                        SizedBox(height: 20.h),
                        TextFormField(
                          controller: _country,
                          decoration: _fieldDecoration('Country'),
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
