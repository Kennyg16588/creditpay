import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart'; // ensure path matches

class ConfirmPinScreen extends StatefulWidget {
  const ConfirmPinScreen({super.key});

  @override
  State<ConfirmPinScreen> createState() => _ConfirmPinScreenState();
}

class _ConfirmPinScreenState extends State<ConfirmPinScreen> {
  final List<String> _pin = [];
  int attemptsLeft = 3;

  void _onKeyTap(String value) {
    if (_pin.length < 4) {
      setState(() => _pin.add(value));
    }
  }

  void _onBackspace() {
    if (_pin.isNotEmpty) {
      setState(() => _pin.removeLast());
    }
  }

  void _onContinue() {
    final enteredPin = _pin.join('');
    final pinProvider = Provider.of<PinProvider>(context, listen: false);

    if (!pinProvider.isPinSet) {
      // No PIN set yet — prompt user to create one or handle accordingly
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('PIN not set'),
          content: const Text('You have not set a PIN yet. Please create a PIN in settings or use the Set PIN flow.'),
          actions: [
            TextButton(onPressed: () { Navigator.pop(context);
            Navigator.pushNamed(context, '/set_pin').then((_) {
              setState(() {}); // rebuild screen after returning
            });
          }, child: const Text('Set Pin')),
          ],
        ),
      );
      setState(() => _pin.clear());
      return;
    }

    final verified = pinProvider.verifyPin(enteredPin);

    if (verified) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const TransferSuccessScreen()),
      );
    } else {
      setState(() {
        attemptsLeft--;
        _pin.clear();
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF142B71)),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Confirm PIN',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF142B71),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Kindly enter your 4-digit pin.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(4, (index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                      color: const Color(0xffE0E0E0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        index < _pin.length ? '•' : '',
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF142B71),
                        ),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 80),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 90),
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
                onPressed: _pin.length == 4 ? _onContinue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF142B71),
                  disabledBackgroundColor: const Color(0xffE0E0E0),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Continue",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numButton(String value) {
    return InkWell(
      onTap: () => _onKeyTap(value),
      borderRadius: BorderRadius.circular(50),
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xff1E1E1E), width: 1.5),
        ),
        child: Center(
          child: Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

//
// 🟥 Incorrect PIN Modal
//
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
            margin: const EdgeInsets.all(24),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF142B71), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('images/rafiki.png', height: 150),
                const SizedBox(height: 16),
                const Text(
                  'Oops.....',
                  style: TextStyle(
                    color: Color(0xFF142B71),
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'You have entered an incorrect pin.\nYou have $attemptsLeft attempts left.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF142B71),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Okay',
                    style: TextStyle(color: Colors.white, fontSize: 16),
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

//
// 🟩 Transfer Success Screen
//
class TransferSuccessScreen extends StatelessWidget {
  const TransferSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF142B71),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 176,
                  width: 168,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Color(0xff52D17C),
                      Color(0xff22918B),
                    ]),
                  ),
                  child: const Center(
                    child: Icon(Icons.check,
                        color: Colors.white, size: 90),
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Transferred\nSuccessfully',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Dear user, your amount has been transferred\nsuccessfully. You can view your receipt below.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD602),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'View Details',
                    style: TextStyle(
                      color: Color(0xFF142B71),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/homepage');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFD602),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                      color: Color(0xFF142B71),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
