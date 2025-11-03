import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';
import 'package:verification_code_field/verification_code_field.dart';

class VerifyCodeScreen extends StatelessWidget {
  const VerifyCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0XFF142B71),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 80),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 40,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0XFF142B71),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 150),

            Expanded(
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 70.0),
                        Text('Verify Code', style: Constants.kSignupTextstyle),
                        SizedBox(height: 10.0),
                        Container(height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0XFF142B71),
                        ),
                        
                          alignment: Alignment.center,
  child: VerificationCodeField(
     codeDigit: CodeDigit.five,
     filled: true,
     fillColor: Colors.white,
     textStyle: TextStyle(
      fontSize: 24.0,
      color: Color(0XFF142B71),
      fontWeight: FontWeight.bold,),
      
    
    onSubmit: (String value) {
      // Optionally, verify the code or enable the Verify button
    },
    onChanged: ( value) {
      // Opt ionally handle editing state
    },
  ),                      
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Didn\'t receive the code?',
                              style: TextStyle(
                                color: Color(0XFF142B71),
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Resend method
                              },
                              child: Text(
                                'Resend',
                                style: TextStyle(
                                  color: Color(0XFF142B71),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 310.0),
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0XFF142B71),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: TextButton(
                            onPressed: () {
                               Navigator.pushNamed(context, '/password');
                            },
                            child: Text(
                              'Verify',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                      ],
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
