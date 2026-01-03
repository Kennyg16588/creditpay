import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:creditpay/constants/constants.dart';

class TierScreen extends StatefulWidget {
  const TierScreen({super.key});

  @override
  State<TierScreen> createState() => _TierScreenState();
}

class _TierScreenState extends State<TierScreen> {
 final PageController _pageController = PageController();
  int _currentPage = 0;

  final tiers = [
      {
        'title': 'Tier 1',
        'dlimit': 'Daily transaction limit  ₦20,000.00',
        'mlimit': 'Maximum account balance   ₦50,000.00',
        'requirement': 'Requirements:\n\n  BVN\n  Biometrics',
        'verified': true,
        'color': const Color(0xffCD7F32),
      },
      {
        'title': 'Tier 2',
        'dlimit': 'Daily transaction limit  ₦200,000.00',
        'mlimit': 'Maximum account balance   ₦500,000.00',
        'requirement': 'Requirements:\n\n  NIN',
        'verified': false,
        'color': const Color(0xffB0C4DE),
      },
      {
        'title': 'Tier 3',
        'dlimit': 'Daily transaction limit  ₦1,000,000',
        'mlimit': 'Maximum account balance   ₦5,000,000',
        'requirement': 'Requirements:\n\n  Electricity Bill',
        'verified': false,
        'color': const Color(0xffD4AF37),
      },
    ];

    void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
    setState(() => _currentPage = index);
  }

  @override
  Widget build(BuildContext context) {

    final currentTier = tiers[_currentPage];
     final Color currentColor = currentTier['color'] as Color;



    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: (){
              Navigator.pushNamed(context, '/profile');
            },
            icon: const Icon(Icons.arrow_back),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: const Color(0xFF142B71),
        ),
        body: 
          Column(crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40.h),
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Text('Upgrade Account',
              style: Constants.kSignupTextstyle,),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 15),
              child: Text('Verify your account with the required documents to \nenjoy increased transactional limit and higher loan amounts',
      style: TextStyle(fontSize: 16.0.sp,
      color: Color(0xff142B71),
       ),),
            ),
            SizedBox(height: 30.h),
       Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _tierButton('Tier 1', 0),
                  _tierButton('Tier 2', 1),
                  _tierButton('Tier 3', 2),
                ],
              ),

              SizedBox(height: 40.h),
              // Animated container showing current tier
              Padding(
                padding: const EdgeInsets.only(left:20, right: 20),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: currentColor,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    'Current tier: ${currentTier['title']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
                SizedBox(height: 40.h),
              // 🔹 PageView showing tier details
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemCount: tiers.length,
                  itemBuilder: (context, index) {
                    final t = tiers[index];
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        border: Border.all(color: currentColor),
                        color:  Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            t['dlimit'] as String,
                            style:  TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF142B71),
                            ),
                          ),
                          SizedBox(height: 15.h),
                          Text(
                            t['mlimit'] as String,
                            style:  TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF142B71),
                            ),
                          ),
                          SizedBox(height: 50.h),
                          Text(
                            t['requirement'] as String,
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF142B71),
                            ),
                          ),
                          SizedBox(height: 25.h),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: t['verified'] == true
                                    ? Colors.green
                                    : const Color(0xFF142B71),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 40,
                                  vertical: 12,
                                ),
                              ),
                              onPressed: () {
                                if (t['verified'] == false) {
                                  Navigator.pushNamed(context, '/upload_doc');
                                }
                              },
                              child: Text(
                                t['verified'] == true
                                    ? 'Verified'
                                    : 'Upgrade Now',
                                style:  TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 80.h),
            ],
          ),
        ),
      );
  }

  Widget _tierButton(String label, int index) {
    final isActive = _currentPage == index;
    const activeColor = Color(0xFF142B71); // fixed blue
    const inactiveColor = Color(0xffDADADA);
    return ElevatedButton(
      onPressed: () => _goToPage(index),
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? activeColor : inactiveColor,
        side: BorderSide(
          color: isActive ? activeColor : inactiveColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.r),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        elevation: isActive ? 4 : 0,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.white : const Color(0xFF142B71),
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
          




