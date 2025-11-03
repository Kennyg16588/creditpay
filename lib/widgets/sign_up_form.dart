
import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 80,),
                      Text('CreditPay' ,style: Constants.kloginbuttonsytle,),
                      SizedBox(height: 20,),
                      
                    ],
                  ),
                
                ),
            SizedBox(height: 200,),

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
                                      SizedBox(height: 40.0),
                                      Form(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'First Name',
                                            border: OutlineInputBorder(),
                                           ),
                                        ),
                                      ),
                                      SizedBox(height: 40.0),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Last Name',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      SizedBox(height: 40.0),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Email Address',
                                            border: OutlineInputBorder(),
                                           ),
                                        ),
                                        SizedBox(height: 40.0),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          labelText: 'Mobile Number',
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                      SizedBox(height: 80.0),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0XFF142B71),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                             Navigator.pushNamed(context, '/signnumber');
                                          },
                                          child: Text(
                                            'Create an Account',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                   
                                    ],
                                  ),
                                ),
                              )
                  ),
                    
                  ),],
              );
  }
}