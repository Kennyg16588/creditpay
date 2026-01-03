import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class OnboardPage extends StatelessWidget {
     final String title;
     final String description;
     final String image;
     final VoidCallback onNext;
     final VoidCallback onSkip;
    final bool isLast;
    final int currentPage;
    final int totalPages;

     const OnboardPage({
      required this.title,
      required this.description,
      required this.image,
      required this.onNext,
      required this.onSkip,
      required this.isLast,
      required this.currentPage,
      required this.totalPages,
     });

     

  @override
  Widget build(BuildContext context) {
    return Column(mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // SizedBox( height: 80.h,),
    Image.asset(image,
    height: 287.h,
    width: 289.w,),
    SizedBox(height: 10.h),
      Text( title,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20.sp,
      color: Color(0XFF142B71),
      fontWeight: FontWeight.bold,
      
      ),
      
      ),
      SizedBox(height: 30.0.h),
      Text(description,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16.0.sp,
      color: Color(0xff142B71),
       ),
      
      ),
      SizedBox( height: 80.h,),
      
      ],
      );
  }
}
