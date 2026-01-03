import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';

class ConfirmPinScreen extends StatefulWidget {
  const ConfirmPinScreen({super.key});

  @override
  State<ConfirmPinScreen> createState() => _ConfirmPinScreenState();
}

class _ConfirmPinScreenState extends State<ConfirmPinScreen> {
  final List<String> _pin = [];
  int attemptsLeft = 3;
  bool _verifying = false;

  void _onKeyTap(String value) {
    if (_pin.length < 4 && !_verifying) setState(() => _pin.add(value));
  }

  void _onBackspace() {
    if (_pin.isNotEmpty && !_verifying) setState(() => _pin.removeLast());
  }

  Future<void> _promptSetPin() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => AlertDialog(
            title: const Text('PIN not set'),
            content: const Text(
              'You have not set a PIN yet. Create a PIN now to proceed with transactions.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Set PIN'),
              ),
            ],
          ),
    );

    if (result == true) {
      await Navigator.pushNamed(context, '/set_pin');
      setState(() {
        _pin.clear();
      });
    }
  }

  Future<void> _onContinue() async {
    if (_verifying) return;
    final enteredPin = _pin.join('');
    final pinProvider = Provider.of<PinProvider>(context, listen: false);
    final flowProvider = Provider.of<TransactionFlowProvider>(
      context,
      listen: false,
    );

    if (!pinProvider.isLoaded) {
      setState(() => _verifying = true);
      // Wait for PIN loading to complete
      int timeout = 0;
      while (!pinProvider.isLoaded && timeout < 50) {
        // limit to 5s
        await Future.delayed(const Duration(milliseconds: 100));
        timeout++;
      }
      setState(() => _verifying = false);
    }

    if (!pinProvider.isPinSet) {
      await _promptSetPin();
      if (pinProvider.isPinSet) {
        setState(() {
          _pin.clear();
          _verifying = false;
        });
        return;
      }
    }

    setState(() => _verifying = true);
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    if (pinProvider.verifyPin(enteredPin)) {
      // 🔹 Execute the pending transaction
      final success = await flowProvider.executeTransaction(context);

      if (!mounted) return;

      if (success) {
        final successScreen = flowProvider.resolveSuccessScreen();
        flowProvider.clear();

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => successScreen),
          (route) => false,
        );
      } else {
        setState(() {
          _pin.clear();
          _verifying = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Transaction Failed. Insufficient funds or error.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      setState(() {
        attemptsLeft--;
        _pin.clear();
        _verifying = false;
      });

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => IncorrectPinScreen(attemptsLeft: attemptsLeft),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isComplete = _pin.length == 4 && !_verifying;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: const Color(0xFF142B71),
              size: 24.sp,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirm PIN',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF142B71),
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Kindly enter your 4-digit pin.',
                style: TextStyle(fontSize: 16.sp, color: Colors.black54),
              ),
              SizedBox(height: 60.h),
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
                        index < _pin.length ? '•' : '',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF142B71),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 80.h),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 90.w),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 25.h,
                    crossAxisSpacing: 25.w,
                  ),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    if (index == 9) return const SizedBox.shrink();
                    if (index == 10) return _numButton('0');
                    if (index == 11) {
                      return IconButton(
                        onPressed: _onBackspace,
                        icon: Icon(Icons.backspace_outlined, size: 24.sp),
                      );
                    }
                    return _numButton('${index + 1}');
                  },
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ElevatedButton(
                  onPressed: isComplete ? _onContinue : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF142B71),
                    disabledBackgroundColor: const Color(0xffE0E0E0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child:
                      _verifying
                          ? SizedBox(
                            height: 20.h,
                            width: 20.w,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                          : Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                ),
              ),
              SizedBox(height: 30.h),
            ],
          ),
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
          border: Border.all(color: const Color(0xff1E1E1E), width: 1.5),
        ),
        child: Center(
          child: Text(
            value,
            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class IncorrectPinScreen extends StatelessWidget {
  final int attemptsLeft;
  const IncorrectPinScreen({super.key, required this.attemptsLeft});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.black.withOpacity(0.4),
        child: Center(
          child: Container(
            margin: EdgeInsets.all(24.w),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: const Color(0xFF142B71), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('images/rafiki.png', height: 150.h),
                SizedBox(height: 16.h),
                Text(
                  'Oops.....',
                  style: TextStyle(
                    color: const Color(0xFF142B71),
                    fontWeight: FontWeight.bold,
                    fontSize: 22.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'You have entered an incorrect pin.\nYou have $attemptsLeft attempts left.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54, fontSize: 16.sp),
                ),
                SizedBox(height: 24.h),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF142B71),
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Okay',
                    style: TextStyle(color: Colors.white, fontSize: 16.sp),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
