import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecurityQuestionsScreen extends StatefulWidget {
  const SecurityQuestionsScreen({Key? key}) : super(key: key);

  @override
  State<SecurityQuestionsScreen> createState() => _SecurityQuestionsScreenState();
}

class _SecurityQuestionsScreenState extends State<SecurityQuestionsScreen> {
  final List<String> _questions = [
    'What is your mother\'s maiden name?',
    'What was the name of your first pet?',
    'In what city were you born?',
    'What is your favorite movie?',
    'What was your first car model?',
    'What is your favorite book?',
    'What is the name of your best friend?',
    'What was your childhood nickname?',
    'What is your favorite sports team?',
    'What is the name of your elementary school?',
  ];

  String? _selectedQuestion1;
  String? _selectedQuestion2;
  String? _selectedQuestion3;

  final TextEditingController _answer1Ctrl = TextEditingController();
  final TextEditingController _answer2Ctrl = TextEditingController();
  final TextEditingController _answer3Ctrl = TextEditingController();

  bool _saving = false;
  bool _showAnswer1 = false;
  bool _showAnswer2 = false;
  bool _showAnswer3 = false;

  @override
  void dispose() {
    _answer1Ctrl.dispose();
    _answer2Ctrl.dispose();
    _answer3Ctrl.dispose();
    super.dispose();
  }

  Future<void> _saveSecurityQuestions() async {
    // validate all fields
    if (_selectedQuestion1 == null ||
        _selectedQuestion2 == null ||
        _selectedQuestion3 == null ||
        _answer1Ctrl.text.trim().isEmpty ||
        _answer2Ctrl.text.trim().isEmpty ||
        _answer3Ctrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _saving = true);

    try {
      // TODO: Save to backend or local storage
      // Example: save to SharedPreferences or API call
      final securityData = {
        'question1': _selectedQuestion1,
        'answer1': _answer1Ctrl.text.trim(),
        'question2': _selectedQuestion2,
        'answer2': _answer2Ctrl.text.trim(),
        'question3': _selectedQuestion3,
        'answer3': _answer3Ctrl.text.trim(),
      };

      debugPrint('Security questions saved: $securityData');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Security questions saved')),
      );

      // go back to previous page
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save security questions')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  InputDecoration _questionDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
        borderSide: BorderSide.none,
      ),
    );
  }

  InputDecoration _answerDecoration(String label, bool showPassword, VoidCallback toggleShow) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          showPassword ? Icons.visibility : Icons.visibility_off,
          color: const Color(0xFF142B71),
        ),
        onPressed: toggleShow,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF142B71),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      'Security Questions',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF142B71),
                      ),
                    ),
                    SizedBox(height: 8.h.h),
                     Text(
                      'Answer the security questions to complete your registration',
                      style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                    ),
                    SizedBox(height: 24.h.h),

                    // Question 1
                    const Text(
                      'Security Question 1',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF142B71),
                      ),
                    ),
                    SizedBox(height: 8.h.h),
                    DropdownButtonFormField<String>(
                      dropdownColor: Colors.white,
                      value: _selectedQuestion1,
                      decoration: _questionDecoration('Select a question'),
                      items: _questions.map((q) {
                        return DropdownMenuItem(value: q, child: Text(q));
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedQuestion1 = val),
                    ),
                    SizedBox(height: 8.h.h),
                    TextFormField(
                      controller: _answer1Ctrl,
                      obscureText: !_showAnswer1,
                      decoration: _answerDecoration(
                        'Your answer',
                        _showAnswer1,
                        () => setState(() => _showAnswer1 = !_showAnswer1),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 40.h.h),

                    // Question 2
                    const Text(
                      'Security Question 2',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF142B71),
                      ),
                    ),
                    SizedBox(height: 8.h.h),
                    DropdownButtonFormField<String>(
                      dropdownColor: Colors.white,
                      value: _selectedQuestion2,
                      decoration: _questionDecoration('Select a question'),
                      items: _questions.map((q) {
                        return DropdownMenuItem(value: q, child: Text(q));
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedQuestion2 = val),
                    ),
                    SizedBox(height: 8.h.h),
                    TextFormField(
                      controller: _answer2Ctrl,
                      obscureText: !_showAnswer2,
                      decoration: _answerDecoration(
                        'Your answer',
                        _showAnswer2,
                        () => setState(() => _showAnswer2 = !_showAnswer2),
                      ),
                      textInputAction: TextInputAction.next,
                    ),
                    SizedBox(height: 40.h.h),

                    // Question 3
                    const Text(
                      'Security Question 3',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF142B71),
                      ),
                    ),
                    SizedBox(height: 8.h.h),
                    DropdownButtonFormField<String>(
                      dropdownColor: Colors.white,
                      value: _selectedQuestion3,
                      decoration: _questionDecoration('Select a question'),
                      items: _questions.map((q) {
                        return DropdownMenuItem(value: q, child: Text(q));
                      }).toList(),
                      onChanged: (val) => setState(() => _selectedQuestion3 = val),
                    ),
                    SizedBox(height: 8.h.h),
                    TextFormField(
                      controller: _answer3Ctrl,
                      obscureText: !_showAnswer3,
                      decoration: _answerDecoration(
                        'Your answer',
                        _showAnswer3,
                        () => setState(() => _showAnswer3 = !_showAnswer3),
                      ),
                      textInputAction: TextInputAction.done,
                    ),
                  ],
                ),
              ),
            ),
            // Continue Button at bottom
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: _saving ? null : _saveSecurityQuestions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF142B71),
                    disabledBackgroundColor: Colors.grey[400],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: _saving
                      ?  SizedBox(
                          height: 20.h,
                          width: 20.w,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      :  Text(
                          'Continue',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
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

