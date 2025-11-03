import 'package:creditpay/constants/constants.dart';
import 'package:flutter/material.dart';


class KycScreen extends StatelessWidget {
  const KycScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(backgroundColor: Colors.white,
        body: Column(mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 385),
            Center(child: Image.asset('images/kycimage.png',
           width: 191,
           height: 191,
           fit: BoxFit.contain,
            )),
              SizedBox(height: 20.0),
             Container(
              height: 108,
              width: 352,
              decoration: BoxDecoration(
                color: Color(0xff142B71),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: TextButton(onPressed: (){
                  Navigator.pushNamed(context, '/accountinfo');
                }, child: Text('Complete your KYC',
                style: Constants.kloginTextstyle,
              ),
             ),),),
          ],
        ),    
     ), );
  }

  
}

