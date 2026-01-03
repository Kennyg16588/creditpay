import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
      'description':
          'Smart, secure loans for individuals \nand small businesses.',
      'image': 'images/image1.png',
    },
    {
      'title': 'Fast & Flexible Credit',
      'description':
          'Smart Financing, Zero Delays. CreditPay \n delivers flexible credit, right when you need it.',
      'image': 'images/image2.png',
    },

    {
      'title': 'Track and Grow your finances',
      'description':
          'Track every transaction, unlock your \nfinancial potential.',
      'image': 'images/image3.png',
    },

    {
      'title': 'Privacy & Trust',
      'description':
          'Our ultra-safe encrypted systems,\nrelentlessly work to secure your information. \nWe use it to get you a loan, nothing else! .',
      'image': 'images/image4.png',
    },
  ];

  Future<void> _nextPage() async {
    if (_currentPage != _onboardData.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOut,
      );
    } else {
      // Mark onboarding as seen
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('seenOnboarding', true);

      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    }
  }

  Future<void> _skip() async {
    // Mark onboarding as seen immediately
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);

    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/getstarted', (route) => false);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
            itemBuilder:
                (context, index) => OnboardPage(
                  currentPage: _currentPage,
                  totalPages: _onboardData.length,
                  title: _onboardData[index]['title'] ?? '',
                  description: _onboardData[index]['description'] ?? '',
                  image: _onboardData[index]['image'] ?? '',
                  onNext: _nextPage,
                  onSkip: _skip,
                  isLast:
                      _currentPage ==
                      _onboardData.length - 1, // Pass isLast flag
                ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.22, // Approx 190.h
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardData.length,
                (index) => Container(
                  margin: EdgeInsets.only(left: 10.w),
                  width: 10.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        _currentPage == index
                            ? const Color(0XFF142B71)
                            : const Color(0xffA4BEFF),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.09, // Approx 80.h
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 80.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Next/Login Button
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: const Color(0XFF142B71),
                    ),
                    child: TextButton(
                      onPressed: _nextPage,
                      child: Text(
                        _currentPage == _onboardData.length - 1
                            ? 'Login'
                            : 'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Skip/Get Started Button
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      color: const Color(0XFFFFD602),
                    ),
                    child: TextButton(
                      onPressed: _skip,
                      child: Text(
                        _currentPage == _onboardData.length - 1
                            ? 'Get Started'
                            : 'Skip',
                        style: TextStyle(
                          color: const Color(0XFF142B71),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
