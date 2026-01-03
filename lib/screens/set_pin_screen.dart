
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SetPinScreen extends StatefulWidget {
  const SetPinScreen({super.key});
  @override
  State<SetPinScreen> createState() => _SetPinScreenState();
}

class _SetPinScreenState extends State<SetPinScreen> {
  String _first = '';
  String _entered = '';
  bool _confirming = false;

  void _onKeyTap(String d) {
    setState(() {
      if (_entered.length < 4) _entered += d;
      if (_entered.length == 4) _onComplete();
    });
  }
 
  void _onBackspace() {
    setState(() {
      if (_entered.isNotEmpty) _entered = _entered.substring(0, _entered.length - 1);
    });
  }

  void _onComplete() async {
    if (!_confirming) {
      _first = _entered;
      _entered = '';
      _confirming = true;
      setState(() {});
      return;
    }
    if (_first == _entered) {
      await context.read<PinProvider>().setPin(_entered);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const PinSetUp()),
      );
    } else {
      setState(() {
        _entered = '';
        _confirming = false;
        _first = '';
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('PINs do not match, try again')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final prompt = !_confirming ? 'Create a 4-digit PIN' : 'Confirm PIN';
    final prompt2 = !_confirming ? 'Kindly enter your 4-digit pin' : 'Kindly re-enter your 4-digit pin';
    return Scaffold(
      appBar:AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF142B71)),
            onPressed: () => Navigator.pop(context),
          ),),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                prompt,
                style:  TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF142B71),
                ),
              ),
              SizedBox(height: 8.h.h),
              Text(
                prompt2,
                style: TextStyle(fontSize: 16.sp, color: Colors.black54),
              ),
              SizedBox(height: 60.h.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    width: 55.w,
                    height: 55.h,
                    decoration: BoxDecoration(
                      color: const Color(0xffE0E0E0),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        index < _entered.length ? '•' : '',
                        style:  TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF142B71),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 80.h.h),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 90.w),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 25,
                    crossAxisSpacing: 25,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    if (index == 9) {
                      return const SizedBox.shrink();
                    } else if (index == 10) {
                      return _numButton('0');
                    } else if (index == 11) {
                      return IconButton(
                        onPressed: _onBackspace,
                        icon: const Icon(Icons.backspace_outlined),
                      );
                    } else {
                      return _numButton('${index + 1}');
                    }
                  },
                ),
              ),
              ElevatedButton(
                onPressed: _entered.length == 4 ? _onComplete : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF142B71),
                  disabledBackgroundColor: const Color(0xffE0E0E0),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child:  Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 30.h.h),
            ],
          ),
        ),
    );
  }

  Widget _numButton(String value) {
    return InkWell(
      onTap: () => _onKeyTap(value),
      borderRadius: BorderRadius.circular(50.r),
      child: Container(
        height: 30.h,
        width: 30.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xff1E1E1E), width: 1.5.w),
        ),
        child: Center(
          child: Text(
            value,
            style:  TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class PinSetUp extends StatelessWidget {
  const PinSetUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF142B71),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 176.h,
                  width: 168.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      const Color(0xff52D17C),
                      const Color(0xff22918B),
                    ]),
                  ),
                  child:  Center(
                    child: Icon(Icons.check, color: Colors.white, size: 90.sp),
                  ),
                ),
                SizedBox(height: 30.h.h),
                 Text(
                  'Pin Setup Sucessful!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                 SizedBox(height: 20.h),
                 Text(
                  'This pin will be used for subsequent\ntransactions',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15.sp,
                  ),
                ),
                
                  SizedBox(height: 170.h.h),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD602),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child:  Text(
                    'Close',
                    style: TextStyle(
                      color: Color(0xFF142B71),
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                ),],
                ),),),),);
  }
  }

