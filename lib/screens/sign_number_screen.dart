import 'package:flutter/material.dart';
import 'package:creditpay/constants/constants.dart';

class SignNumberScreen extends StatelessWidget {
  const SignNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(backgroundColor: Color(0XFF142B71),
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
                        child: Icon(Icons.person, size: 50, color: Color(0XFF142B71)),
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
                                      SizedBox(height: 20.0),
                                       Text('Please verify your \nmobile number' ,style: Constants.kSignupTextstyle,),
                                      SizedBox(height: 70.0),
                                      Text(
                                              'Mobile Number',
                                              style: TextStyle(
                                                color: Color(0XFF142B71),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            SizedBox(height: 10.0),
                                      Form(
                                        child: TextFormField(
                                          decoration: InputDecoration(
                                            prefixText: '+234  ',
                                            border: OutlineInputBorder(),
                                            
                                           ),
                                           keyboardType: TextInputType.phone,
                                        ),
                                      ),
                                      
                                      SizedBox(height: 350.0),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Color(0XFF142B71),
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        child: TextButton(
                                          onPressed: () {
                                             Navigator.pushNamed(context, '/verify');
                                          },
                                          child: Text(
                                            'Send Code',
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
  