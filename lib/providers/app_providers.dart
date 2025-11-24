import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:creditpay/services/loan_repayment_service.dart';
import 'package:creditpay/models/loan_repayment_model.dart';

// Example auth provider (expand as needed)
class AuthProvider extends ChangeNotifier {
  String? _userId;
  String? get userId => _userId;

  void setUser(String id) {
    _userId = id;
    notifyListeners();
  }

  void clear() {
    _userId = null;
    notifyListeners();
  }
}

// KYC provider that persists the completion flag
class KycProvider extends ChangeNotifier {
  bool _completed = false;
  bool get completed => _completed;

  KycProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _completed = prefs.getBool('kycCompleted') ?? false;
    notifyListeners();
  }

  Future<void> setCompleted(bool value) async {
    _completed = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('kycCompleted', value);
    notifyListeners();
  }
}

class LoanProvider extends ChangeNotifier {
  String selectedAmount = "";

  void setSelectedAmount(String amount) {
    selectedAmount = amount;
    notifyListeners();
  }
}

class LoanRepaymentProvider with ChangeNotifier {
  final LoanRepaymentService _service = LoanRepaymentService();

  bool isPartPayment = true;
  double enteredAmount = 35000;
  String selectedBank = "Access Bank***0016";
  bool isLoading = false;

  double serviceFee = 0.0;

  void togglePaymentType(bool part) {
    isPartPayment = part;
    notifyListeners();
  }

  void updateAmount(String value) {
    if (value.trim().isEmpty) return;

    enteredAmount = double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), "")) ?? 0;
    notifyListeners();
  }

  LoanRepaymentModel get summary {
    double total = enteredAmount + serviceFee;

    return LoanRepaymentModel(
      amount: enteredAmount,
      serviceFee: serviceFee,
      total: total,
    );
  }

  Future<bool> submitRepayment() async {
    isLoading = true;
    notifyListeners();

    bool success = await _service.makeRepayment(
      amount: enteredAmount,
      repaymentType: isPartPayment ? "part" : "full",
      bankAccount: selectedBank,
    );

    isLoading = false;
    notifyListeners();

    return success;
  }
}

// Transactions provider (skeleton)
class TransactionProvider extends ChangeNotifier {

  Future<bool> performTransaction({
    required String actionType,
    Map<String, dynamic>? payload,
  }) async {

    await Future.delayed(const Duration(seconds: 1)); // simulate processing

    switch (actionType) {
      case "transfer":
        // Example: send transfer API call
        print("Processing transfer: $payload");
        break;

      case "bill_payment":
        print("Paying bill: $payload");
        break;

      case "loan_repayment":
        print("Repaying loan: $payload");
        break;

      case "withdrawal":
        print("Processing withdrawal: $payload");
        break;

      default:
        print("Unknown transaction");
    }

    return true;
  }
}


// Upload provider (skeleton)
class UploadProvider extends ChangeNotifier {
  // add upload state and helpers
}

class PinProvider extends ChangeNotifier {
  String? _pin;
  String? get pin => _pin;

  bool get isPinSet => _pin != null;

  PinProvider() {
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    _pin = prefs.getString('user_pin');
    notifyListeners();
  }

  Future<void> setPin(String newPin) async {
    _pin = newPin;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_pin', newPin);
    notifyListeners();
  }

  bool verifyPin(String entered) {
    return _pin != null && entered == _pin;
  }

  Future<void> clearPin() async {
    _pin = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_pin');
    notifyListeners();
  }
}