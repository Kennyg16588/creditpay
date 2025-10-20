import 'package:flutter/material.dart';


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
        SizedBox( height: 100,),
    Image.asset(image,
    height: 287.0,
    width: 289.0,),
    SizedBox(height: 10.0),
      Text( title,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 20.0,
      color: Colors.blue[900],
      fontWeight: FontWeight.bold,
      
      ),
      
      ),
      SizedBox(height: 30.0),
      Text(description,
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16.0,
      color: Colors.blueGrey,
       ),
      
      ),
      SizedBox( height: 80,),
      
      ],
      );
  }
}