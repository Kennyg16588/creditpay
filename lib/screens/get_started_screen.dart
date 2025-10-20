import 'package:creditpay/screens/login_screen.dart';
import 'package:flutter/material.dart';


class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.blue[900],
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox( height: 150,),
    Image.asset('images/creditlogo.png',
    height: 312.0,
    width: 312.0,),
    SizedBox(height: 10.0),
      Text( 'Fast, Flexible Credit at \nYour Fingertips ',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 30.0,
      color: Colors.yellow[700],
      fontWeight: FontWeight.bold,
      fontStyle: FontStyle.italic
      ),
      ),
      SizedBox( height: 100,),
    
      Column(crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(margin: EdgeInsets.only(left: 50.0, right: 50),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
            color: Colors.yellow[700],),
            child: TextButton(
                onPressed: (){
                  Navigator.pushNamed(context, '/signup');
                }, child: Text(
                  'Create an Account',
                style: TextStyle(
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                ),),),
          ),
          SizedBox(height: 20.0),

      Container(margin: EdgeInsets.only(left: 50.0, right: 50),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
            color: Colors.yellow[700],),
        child: TextButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            }, child: Text( 'Login',
            style: TextStyle(
                  color: Colors.blue[900],
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
            ),),
      ),
       ), 
       SizedBox(height: 100,),
       
           Row(
             children: [
               Expanded(
                 child: Padding(
                   padding: const EdgeInsets.only(left:70, right: 20),
                   child: Divider(
                    color: Colors.yellow,),
                 ),
               ),
                Text('Continue with',
                style: TextStyle(
                  color: Colors.yellow[700],
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
            ),),
                 Expanded(
                   child: Padding(
                     padding: const EdgeInsets.only(left:20, right: 70),
                     child: Divider(
                                     color: Colors.yellow,),
                   ),
                 ),
             ],
           ),
      
              
       Container(margin: EdgeInsets.only(left: 50.0, right: 50, top: 20.0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0),
            border: Border.all(color: Colors.yellow),),
        child: Row(mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/google.png'),
            TextButton(
                onPressed: null, child: Text( 'Google',
                style: TextStyle(
                      color: Colors.yellow[700],
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                ),),
                 ),
          ],
        ),
       ), 
       ],
      ),
    ],),);
  }
}
    