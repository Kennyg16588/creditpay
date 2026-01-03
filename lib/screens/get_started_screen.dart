import 'package:creditpay/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Color(0XFF142B71),
      body: SingleChildScrollView(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox( height: 107.h,),
            Image.asset('images/creditlogo.png',
            height: 312.0.h,
            width: 312.0.w,),
            SizedBox(height: 10.0.h),
        Text( 'Fast, Flexible Credit at \nYour Fingertips ',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.0.sp,
        color: Color(0XFFFFD602),
        fontStyle: FontStyle.italic
        ),
        ),
        SizedBox( height: 73.h,),
            
        Column(crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(margin: EdgeInsets.only(left: 20.r, right: 20.r),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0.r),
              color: Color(0XFFFFD602),),
              child: TextButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/signup');
                  }, child: Text(
                    'Create an Account',
                  style: TextStyle(
                    color: Color(0XFF142B71),
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0.sp,
                  ),),),
            ),
            SizedBox(height: 20.0.h),
        
        Container(margin: EdgeInsets.only(left: 20.0.r, right: 20.r),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0.r),
              color: Color(0XFFFFD602),),
          child: TextButton(
              onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
              }, child: Text( 'Login',
              style: TextStyle(
                    color: Color(0XFF142B71),
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0.sp,
              ),),
        ),
         ), 
         SizedBox(height: 50.h,),
         
             Row(
               children: [
                 Expanded(
                   child: Padding(
                     padding: const EdgeInsets.only(left:70, right: 20),
                     child: Divider(
                      color: Color(0XFFFFD602),),
                   ),
                 ),
                  Text('Continue with',
                  style: TextStyle(
                    color: Color(0XFFFFD602),
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0.sp,
              ),),
                   Expanded(
                     child: Padding(
                       padding: const EdgeInsets.only(left:20, right: 70),
                       child: Divider(
                                       color: Color(0XFFFFD602),),
                     ),
                   ),
               ],
             ),
        
                
         Container(margin: EdgeInsets.only(left: 50.0, right: 50, top: 20.0),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0.r),
              border: Border.all(color: Color(0XFFFFD602)),),
          child: Row(mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/google.png'),
              TextButton(
                  onPressed: null, child: Text( 'Google',
                  style: TextStyle(
                        color: Color(0XFFFFD602),
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0.sp,
                  ),),
                   ),
            ],
          ),
         ), 
         ],
        ),
            ],),
      ),);
  }
}
    
