
import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

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
                      Text('Welcome Back!' ,style: Constants.kloginTextstyle,),
                      Text('Enter your email address and password to login' ,style: Constants.kloginTextstyle2,),
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
                                            labelText: 'Email Address / Mobile Number',
                                            border: OutlineInputBorder(),
                                           ),
                                        ),
                                      ),
                                      SizedBox(height: 40.0),
                                      TextFormField(
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          border: OutlineInputBorder(),
                                        ),
                                      ),
                                      SizedBox(height: 40.0),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0XFF142B71),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                             Navigator.pushNamed(context, '/homepage');
                                          },
                                          child: Text(
                                            'Login',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.0),
                                      TextButton(
                                        onPressed: () {
                                          // Handle forgot password action
                                        },
                                        child: Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                            color: Color(0XFFFFD602),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                      Row(mainAxisAlignment: MainAxisAlignment.center,
                                        children: [

                                          Text(
                                              'Don\'t have an account?',
                                              style: TextStyle(
                                                color: Color(0XFF142B71),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            TextButton(
                                        onPressed: () {
                                          Navigator.pushNamed(context, '/signup');
                                        },
                                        child: Text(
                                          'Create Account',
                                          style: TextStyle(
                                            color: Color(0XFFFFD602),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ),
                                        ],
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