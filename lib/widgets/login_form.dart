
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
                      Text('Credit Pay' ,style: Constants.kloginbuttonsytle,),
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
                                          color: Colors.blue[900],
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                             Navigator.pushNamed(context, '/home');
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
                                            color: Colors.yellow[700],
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
                                                color: Colors.blue[900],
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
                                            color: Colors.yellow[700],
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