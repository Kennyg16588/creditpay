import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';

class PasswordScreen extends StatelessWidget {
  const PasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(backgroundColor: Colors.blue[900],
        body: Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 80,),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 40,
                        child: Icon(Icons.person, size: 50, color: Colors.blue[900]),
                      ),
                   
                    ],
                  ),
                
                ),
            SizedBox(height: 150,),

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
                                       Text('Create your \npassword' ,style: Constants.kSignupTextstyle,),
                                      SizedBox(height: 20.0),
                                      
                                      Form(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Enter password',
                                            border: OutlineInputBorder(),
                                            
                                           ),
                                        ),
                                      ),
                                      SizedBox(height: 30.0),
                                      TextFormField(
                                          decoration: InputDecoration(
                                            labelText: 'Confirm password',
                                            border: OutlineInputBorder(),
                                            
                                           ),
                                        ),
                                        SizedBox(height: 30.0),
                                      Row(
                                        children: [
                                          Icon(Icons.check_box_outline_blank,
                                          color: Colors.blue[900],),
                                          SizedBox(width: 10,),
                                          Text(
                                                  'I agree to the Term of Service & Privacy Policy',
                                                  style: TextStyle(
                                                    color: Colors.blue[900],
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                        ],
                                      ),
                                            
                                      SizedBox(height: 300.0),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue[900],
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                             Navigator.pushNamed(context, '/login');
                                          },
                                          child: Text(
                                            'Sign Up',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 10.0),
                                      
                                      Row(mainAxisAlignment: MainAxisAlignment.center,
                                        children: [                                             
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                  ),
                    
                  ),],
              ),  
     ), );
  }
}
  