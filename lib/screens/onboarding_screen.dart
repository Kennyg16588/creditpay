
import 'package:flutter/material.dart';
import 'package:creditpay/widgets/onboard_page.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
 final PageController _controller = PageController();
 int _currentPage = 0;

  final List<Map<String, String>> _onboardData = [
    {
      'title': 'Access to credit, \nBuild Wealth. Stay in control',
      'description': 'Smart, seecure loans for individuals \nand small businesses.',
      'image': 'images/image1.png',
    },
    {
      'title': 'Fast & Flexible Credit',
      'description': 'Smart Financing, Zero Delays. CreditPay \n delivers flexible credit, right when you need it.',
      'image': 'images/image2.png',
    },
    
    {
      'title': 'Track and Grow your finances',
      'description': 'Track every transaction, unlock your \nfinancial potential.',
      'image': 'images/image3.png',
    },

  {
      'title': 'Privacy & Trust',
      'description': 'Our ultra-safe encrypted systems,\nrelentlessly work to secure your information. \nwe use it to get you a loan, nothing else! .',
      'image': 'images/image4.png',
    },
  ];

void _nextPage(){
  if (_currentPage != _onboardData.length -1){
    _controller.nextPage(duration: Duration(milliseconds: 800 ), curve: Curves.easeOut,);
  }
  else{
     Navigator.pushNamed(context, '/login');
  }
}

void _skip(){
  
  if (_currentPage != _onboardData.length -1){
   _controller.jumpToPage(_onboardData.length -1);
  }
  else{
    Navigator.pushNamed(context, '/getstarted'); 
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _onboardData.length,
            itemBuilder: (context, index) => OnboardPage(
              currentPage: _currentPage,
              totalPages: _onboardData.length,
              title: _onboardData[index]['title']!,
              description: _onboardData[index]['description']!,
              image: _onboardData[index]['image']!,
              onNext: _nextPage,
              onSkip: _skip,
              isLast: _currentPage == _onboardData.length - 1, // Pass isLast flag
            ),
          ),
          Positioned(
            bottom: 280,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...List.generate(_onboardData.length, (index) => Container(
                  margin: EdgeInsets.only(left: 10.0),
                  width: 10.0,
                  height: 10.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index ? Colors.blue[900] : Colors.blueGrey[200],
                  ),
                ))
              ],
            ),
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 80.0, right: 80),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.blue[900],
                  ),
                  child: TextButton(
                    onPressed: _nextPage,
                    child: Text(
                      _currentPage == _onboardData.length - 1 ? 'Login' : 'Next',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  margin: EdgeInsets.only(left: 80.0, right: 80),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.yellow[700],
                  ),
                  child: TextButton(
                    onPressed: _skip,
                    child: Text(
                      _currentPage == _onboardData.length - 1 ? 'Get Started' : 'Skip',
                      style: TextStyle(
                        color: Colors.blue[900],
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

