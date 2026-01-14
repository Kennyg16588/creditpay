import 'package:creditpay/models/loan_repayment_model.dart';
import 'package:creditpay/models/loan_model.dart';
import 'package:creditpay/screens/success_screen.dart';
import 'package:creditpay/services/cloudinary_service.dart';
import 'package:creditpay/services/remote_config_service.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'dart:async';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? _avatarUrl;
  String? get avatarUrl => _avatarUrl;

  User? get user => _auth.currentUser;
  String? get uid => user?.uid;

  // LOCAL VARIABLES
  String? _firstName;
  String? _lastName;
  String? _mobile;
  String? _email;
  String? _photo;

  // GETTERS
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get mobile => _mobile;
  String? get email => _email;
  String? get photo => _photo;

  bool get isLoggedIn => user != null;

  // KYC completion flag
  bool _kycCompleted = false;

  bool get kycCompleted => _kycCompleted;

  AuthProvider() {
    _init();
  }

  void _init() {
    _auth.authStateChanges().listen((user) async {
      if (user != null) {
        debugPrint(
          '👤 AuthStateChange: User detected (${user.uid}). Loading data...',
        );
        // 1. Load locally for instant UI update
        await loadUserData();
        // 2. Sync with Firestore for latest data
        await _loadFromFirestore();
      } else {
        debugPrint('👤 AuthStateChange: No user detected.');
        _firstName = null;
        _lastName = null;
        _mobile = null;
        _email = null;
        _photo = null;
        _kycCompleted = false;
        notifyListeners();
      }
    });
  }

  // ============================================================
  // 🔹 SAVE USER DATA LOCALLY (Provider + SharedPreferences)
  // ============================================================
  Future<void> _saveLocally(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();

    if (data.containsKey("firstName")) _firstName = data["firstName"];
    if (data.containsKey("lastName")) _lastName = data["lastName"];
    if (data.containsKey("mobile")) _mobile = data["mobile"];
    if (data.containsKey("email")) _email = data["email"];
    if (data.containsKey("photo")) _photo = data["photo"];
    if (data.containsKey("kycCompleted")) {
      _kycCompleted = data["kycCompleted"] ?? false;
    }

    // Save all keys from the map to SharedPreferences
    for (var entry in data.entries) {
      if (entry.value is String) {
        await prefs.setString(entry.key, entry.value);
      } else if (entry.value is bool) {
        await prefs.setBool(entry.key, entry.value);
      } else if (entry.value is int) {
        await prefs.setInt(entry.key, entry.value);
      } else if (entry.value is double) {
        await prefs.setDouble(entry.key, entry.value);
      }
    }

    await prefs.setBool("isLoggedIn", true);

    notifyListeners();
  }

  // ============================================================
  // 🔹 upload profile image
  // ============================================================
  Future<String?> uploadProfileImage(File file, String uid) async {
    try {
      debugPrint('📸 Uploading profile image for user: $uid to Cloudinary');

      final cloudinaryService = CloudinaryService();
      final url = await cloudinaryService.uploadFile(
        file,
        folder: 'users/$uid',
        resourceType: CloudinaryResourceType.Image,
      );

      if (url == null) {
        debugPrint('❌ Upload failed');
        return null;
      }

      debugPrint('✅ Download URL: $url');

      // Save to Firestore
      try {
        await _firestore.collection('users').doc(uid).update({'photo': url});
        debugPrint('✅ Photo URL saved to Firestore');
      } catch (e) {
        debugPrint('⚠️ Firestore update failed (ignoring): $e');
      }

      // Save to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('photo', url);

      _photo = url;
      notifyListeners();

      return url;
    } catch (e) {
      debugPrint('❌ Upload error: $e');
      return null;
    }
  }

  // ============================================================
  // 🔹 SET USER DATA (FROM LOGIN SCREEN)
  // ============================================================
  void setUserData({String? name, String? photo, String? email}) {
    if (name != null) {
      final parts = name.trim().split(" ");
      _firstName = parts.first;
      _lastName = parts.length > 1 ? parts.sublist(1).join(" ") : "";
    }

    _photo = photo;
    _email = email;

    notifyListeners();
  }

  // ============================================================
  // 🔹 LOAD USER PROFILE FROM FIRESTORE
  // ============================================================
  Future<void> _loadFromFirestore() async {
    if (uid == null) return;

    try {
      final doc = await _firestore.collection("users").doc(uid).get();
      if (doc.exists) {
        await _saveLocally(doc.data()!);
      }
    } catch (e) {
      debugPrint("⚠️ Firestore error: $e");
    }
  }

  // ============================================================
  // 🔹 LOAD LOCAL DATA ON APP START
  // ============================================================
  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    _firstName = prefs.getString('firstName');
    _lastName = prefs.getString('lastName');
    _mobile = prefs.getString('mobile');
    _email = prefs.getString('email');
    _photo = prefs.getString('photo');
    _kycCompleted = prefs.getBool('kycCompleted') ?? false;

    notifyListeners();
  }

  // ============================================================
  // 🔹 REGISTER USER
  // ============================================================
  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String mobile,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    final data = {
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "email": email.trim(),
      "photo": "",
      "uid": cred.user!.uid,
      "createdAt": FieldValue.serverTimestamp(),
      "kycCompleted": false,
      "balance": 0.0,
    };

    await _firestore.collection("users").doc(cred.user!.uid).set(data);
    await _saveLocally(data);

    return cred;
  }

  // ============================================================
  // 🔹 RESET PASSWORD
  // ============================================================
  Future<void> sendPasswordResetEmail(String email) async {
    // 1️⃣ Check if email exists in Firestore first
    final snapshot =
        await _firestore
            .collection("users")
            .where("email", isEqualTo: email.trim())
            .limit(1)
            .get();

    if (snapshot.docs.isEmpty) {
      throw Exception("This email address is not registered with us.");
    }

    // 2️⃣ If email exists, send the reset link
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      debugPrint('❌ Firebase Reset Error: $e');
      rethrow;
    }
  }

  // ============================================================
  // 🔹 UPDATE USER DATA
  // ============================================================
  Future<void> updateUserData(Map<String, dynamic> data) async {
    if (uid == null) return;

    try {
      await _firestore.collection("users").doc(uid).update(data);
      await _saveLocally(data);
      debugPrint('✅ User data updated in Firestore and locally');
    } catch (e) {
      debugPrint('❌ Error updating user data: $e');
      rethrow;
    }
  }

  // ============================================================
  // 🔹 SIGN IN USER
  // ============================================================
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    debugPrint('✅ User signed in: ${cred.user?.email}');

    try {
      await _loadFromFirestore();
    } catch (e) {
      debugPrint(
        '⚠️ Firestore load failed, loading from SharedPreferences: $e',
      );
      await loadUserData();
    }

    debugPrint('✅ User data loaded. KYC Completed: $_kycCompleted');
    notifyListeners();

    return cred;
  }

  // ============================================================
  // 🔹 SIGN OUT USER (CLEARS ALL DATA)
  // ============================================================
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();

    // 🔹 Clear only session-related data, preserving critical flags
    final keys = prefs.getKeys();
    final preserve = {'seenOnboarding', 'user_pin', 'show_balance'};
    for (String key in keys) {
      if (!preserve.contains(key)) {
        await prefs.remove(key);
      }
    }

    await _auth.signOut();

    _firstName = null;
    _lastName = null;
    _mobile = null;
    _email = null;
    _photo = null;
    _kycCompleted = false;

    notifyListeners();
  }

  // ============================================================
  // 🔹 MARK KYC AS COMPLETED
  // ============================================================
  Future<void> completeKyc() async {
    final prefs = await SharedPreferences.getInstance();

    _kycCompleted = true;
    await prefs.setBool('kycCompleted', true);

    // Also save to Firestore if available
    if (uid != null) {
      try {
        await FirebaseFirestore.instance.collection("users").doc(uid).update({
          "kycCompleted": true,
        });
        debugPrint('✅ KYC marked complete in Firestore');
      } catch (e) {
        debugPrint('⚠️ Firestore update failed (ignoring): $e');
      }
    }

    notifyListeners();
  }
}

class LoanProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String selectedAmount = "";
  bool isLoading = false;
  Loan? _activeLoan;

  Loan? get activeLoan => _activeLoan;

  // Initialize and fetch active loan
  LoanProvider() {
    _init();
  }

  void _init() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        fetchActiveLoan();
      } else {
        _activeLoan = null;
        notifyListeners();
      }
    });
  }

  void setSelectedAmount(String amount) {
    selectedAmount = amount;
    notifyListeners();
  }

  Future<void> fetchActiveLoan() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final snapshot =
          await _firestore
              .collection('users')
              .doc(uid)
              .collection('loans')
              //.where('userId', isEqualTo: uid) // Redundant in subcollection
              .where('status', isEqualTo: 'active')
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        _activeLoan = Loan.fromFirestore(snapshot.docs.first);
      } else {
        _activeLoan = null;
      }
      notifyListeners();
    } catch (e) {
      debugPrint("❌ Error fetching active loan: $e");
    }
  }

  Future<bool> applyForLoan(
    BuildContext context, {
    required String purpose,
    required int period,
  }) async {
    if (_activeLoan != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You already have an active loan. Please repay it first.',
          ),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      // Clean the amount string (e.g., "₦10,000" -> 10000)
      double amount =
          double.tryParse(selectedAmount.replaceAll(RegExp(r'[^0-9]'), "")) ??
          0.0;

      if (amount <= 0) {
        isLoading = false;
        notifyListeners();
        return false;
      }

      final uid = _auth.currentUser?.uid;
      if (uid == null) throw Exception("User not logged in");

      // Calculate financials
      // Interest: 5% per month on principal
      // Monthly Repayment = (Amount / Period) + (Amount * 0.05)
      double rate =
          RemoteConfigService().loanInterestRate; // Fetched from Firebase
      double monthlyInterest = amount * rate;
      double monthlyPrincipal = amount / period;
      double monthlyRepayment = monthlyPrincipal + monthlyInterest;
      double totalRepayment = monthlyRepayment * period;

      // 1. Create Loan in Firestore
      final loanData = {
        'userId': uid,
        'amount': amount, // Principal
        'balance':
            totalRepayment, // Initial balance is TOTAL repayment (Principal + Interest)
        'totalRepayment': totalRepayment,
        'monthlyRepayment': monthlyRepayment,
        'period': period,
        'purpose': purpose,
        'createdAt': FieldValue.serverTimestamp(),
        'dueDate': Timestamp.fromDate(
          DateTime.now().add(const Duration(days: 30)),
        ),
        'status': 'active',
      };

      await _firestore
          .collection('users')
          .doc(uid)
          .collection('loans')
          .add(loanData);

      // Refresh active loan immediately
      await fetchActiveLoan();

      final walletProvider = Provider.of<WalletProvider>(
        context,
        listen: false,
      );
      final notificationProvider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );

      // 2. Credit Wallet (Principal Amount)
      await walletProvider.creditWallet(
        amount,
        description: "Loan Disbursement",
        type: "credit",
      );

      // 3. Add Notification
      notificationProvider.addNotification(
        title: 'Loan Approved',
        message:
            'Your loan of ₦${amount.toStringAsFixed(0)} has been approved and credited to your wallet.',
        icon: Icons.celebration,
      );

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("❌ Error applying for loan: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

class LoanRepaymentProvider with ChangeNotifier {
  // We can access LoanProvider state via context in methods

  bool isPartPayment = true;
  double enteredAmount =
      0; // Default to 0, will be updated by UI or full balance
  String selectedBank = "Wallet Balance"; // Default to Wallet for now
  bool isLoading = false;
  double serviceFee = 0.0;

  void togglePaymentType(bool part, double fullBalance) {
    isPartPayment = part;
    if (!part) {
      enteredAmount = fullBalance;
    }
    notifyListeners();
  }

  void updateAmount(String value) {
    if (!isPartPayment) return; // Ignore updates if full payment selected
    if (value.trim().isEmpty) {
      enteredAmount = 0;
    } else {
      enteredAmount =
          double.tryParse(value.replaceAll(RegExp(r'[^0-9]'), "")) ?? 0;
    }
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

  Future<bool> submitRepayment(BuildContext context) async {
    final loanProvider = Provider.of<LoanProvider>(context, listen: false);
    final activeLoan = loanProvider.activeLoan;

    if (activeLoan == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No active loan found to repay.')),
      );
      return false;
    }

    if (enteredAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount.')),
      );
      return false;
    }

    if (enteredAmount > activeLoan.balance && isPartPayment) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Amount cannot exceed loan balance.')),
      );
      return false;
    }

    isLoading = true;
    notifyListeners();

    try {
      final walletProvider = Provider.of<WalletProvider>(
        context,
        listen: false,
      );

      // 1. Debit Wallet
      final transactionResult = await walletProvider.debitWallet(
        enteredAmount,
        description: "Loan Repayment",
        type: "debit",
      );

      if (transactionResult == null) {
        isLoading = false;
        notifyListeners();
        return false; // Debit failed (e.g. insufficient funds)
      }

      // 2. Update Firestore
      final newBalance = activeLoan.balance - enteredAmount;
      final isPaidOff = newBalance <= 1; // Tolerance for float errors

      await FirebaseFirestore.instance
          .collection('users')
          .doc(activeLoan.userId)
          .collection('loans')
          .doc(activeLoan.id)
          .update({
            'balance': isPaidOff ? 0 : newBalance,
            'status': isPaidOff ? 'paid' : 'active',
            'lastRepaymentDate': FieldValue.serverTimestamp(),
          });

      // 3. Refresh Active Loan State
      await loanProvider.fetchActiveLoan();

      // 4. Notification
      final notificationProvider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );

      notificationProvider.addNotification(
        title: isPaidOff ? 'Loan Fully Repaid' : 'Repayment Successful',
        message:
            isPaidOff
                ? 'Congratulations! You have fully repaid your loan of ₦${activeLoan.amount.toStringAsFixed(0)}.'
                : 'Repayment of ₦${enteredAmount.toStringAsFixed(0)} received. Balance: ₦${newBalance.toStringAsFixed(0)}',
        icon: Icons.check_circle,
      );

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("❌ Error in repayment: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Repayment failed: $e')));
      isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

// Transactions provider
class TransactionProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> _transactions = [];
  List<Map<String, dynamic>> get transactions => _transactions;

  StreamSubscription<QuerySnapshot>? _transactionSubscription;

  TransactionProvider() {
    _init();
  }

  void _init() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _startListeningToTransactions(user.uid);
      } else {
        _stopListeningAndClear();
      }
    });
  }

  void _startListeningToTransactions(String uid) {
    _transactionSubscription?.cancel();
    _transactionSubscription = _firestore
        .collection('users')
        .doc(uid)
        .collection('transactions')
        .orderBy('date', descending: true)
        .limit(20) // Limit to recent 20
        .snapshots()
        .listen((snapshot) {
          _transactions =
              snapshot.docs.map((doc) {
                final data = doc.data();
                // Convert timestamp to Date String or keep as is
                // For simple UI, we might format it here or in UI.
                // Let's keep raw data for now.
                return {'id': doc.id, ...data};
              }).toList();
          notifyListeners();
        });
  }

  void _stopListeningAndClear() {
    _transactionSubscription?.cancel();
    _transactions = [];
    notifyListeners();
  }

  // Placeholder for pending actions (existing logic)
  Future<bool> performTransaction({
    required String actionType,
    Map<String, dynamic>? payload,
  }) async {
    await Future.delayed(const Duration(seconds: 1)); // simulate processing
    return true;
  }
}

class PinProvider extends ChangeNotifier {
  String? _pin;
  String? get pin => _pin;
  bool _isLoaded = false;
  bool get isLoaded => _isLoaded;

  bool get isPinSet => _pin != null;

  PinProvider() {
    _init();
  }

  void _init() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user != null) {
        await _load();
      } else {
        _pin = null;
        _isLoaded = true;
        notifyListeners();
      }
    });
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _pin = prefs.getString('user_pin');

      if (_pin == null) {
        final uid = FirebaseAuth.instance.currentUser?.uid;
        if (uid != null) {
          final doc =
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .get();
          if (doc.exists &&
              doc.data()?.containsKey('transaction_pin') == true) {
            _pin = doc.data()!['transaction_pin'];
            await prefs.setString('user_pin', _pin!);
          }
        }
      }
    } catch (e) {
      debugPrint('❌ Error loading PIN: $e');
    } finally {
      _isLoaded = true;
      notifyListeners();
    }
  }

  Future<void> setPin(String newPin) async {
    _pin = newPin;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_pin', newPin);

    // Also save to Firestore
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'transaction_pin': newPin,
        });
        debugPrint('✅ Transaction PIN saved to Firestore');
        await prefs.setBool('has_completed_pin', true);
      } catch (e) {
        debugPrint('❌ Error saving PIN to Firestore: $e');
      }
    }

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

class AirtimeProvider extends ChangeNotifier {
  String? selectedProvider; // Big icons: MTN, Airtel
  String? selectedNetwork; // Small icons: MTN, Airtel, Glo, Etisalat

  int? amount;
  String phoneNumber = '';

  void setProvider(String provider) {
    selectedProvider = provider;
    notifyListeners();
  }

  void setNetwork(String network) {
    selectedNetwork = network;
    notifyListeners();
  }

  void setAmount(int value) {
    amount = value;
    notifyListeners();
  }

  void setPhoneNumber(String phone) {
    phoneNumber = phone;
    notifyListeners();
  }

  bool get isValid =>
      amount != null &&
      amount! > 0 &&
      phoneNumber.isNotEmpty &&
      selectedNetwork != null;
}

enum TransactionType {
  transfer,
  billPayment,
  withdrawal,
  loanRepayment,
  airtimePurchase,
  other,
}

class TransactionFlowProvider extends ChangeNotifier {
  TransactionType? _pendingAction;
  Map<String, dynamic>? _payload;

  TransactionType? get pendingAction => _pendingAction;
  Map<String, dynamic>? get payload => _payload;

  /// Set the transaction that requires PIN verification.
  void setPendingAction(
    TransactionType type, {
    required Map<String, String> payload,
  }) {
    _pendingAction = type;
    _payload = payload;

    notifyListeners();
  }

  /// Clear after success.
  void clear() {
    _pendingAction = null;
    _payload = null;
    notifyListeners();
  }

  /// Process pending transaction
  Future<bool> executeTransaction(BuildContext context) async {
    if (_pendingAction == null || _payload == null) return false;

    final walletProvider = Provider.of<WalletProvider>(context, listen: false);
    double amount = 0.0;
    String description = "Transaction";

    try {
      if (_payload!.containsKey('amount')) {
        amount = double.tryParse(_payload!['amount'].toString()) ?? 0.0;
      }
      if (_payload!.containsKey('description')) {
        description = _payload!['description'].toString();
      }
    } catch (e) {
      debugPrint("Error parsing payload: $e");
    }

    if (amount <= 0) {
      debugPrint("Invalid amount for transaction");
      return false;
    }

    // Attempt debit
    final transactionResult = await walletProvider.debitWallet(
      amount,
      description: description,
      type: 'debit',
    );

    if (transactionResult != null) {
      // Update payload with real transaction details (reference, date)
      _payload = {...?_payload, ...transactionResult};

      final notificationProvider = Provider.of<NotificationProvider>(
        context,
        listen: false,
      );

      IconData icon = Icons.receipt_long;
      switch (_pendingAction) {
        case TransactionType.transfer:
          icon = Icons.send;
          break;
        case TransactionType.billPayment:
          icon = Icons.receipt;
          break;
        case TransactionType.withdrawal:
          icon = Icons.money_off;
          break;
        case TransactionType.airtimePurchase:
          icon = Icons.phone_android;
          break;
        default:
          icon = Icons.check_circle;
      }

      notificationProvider.addNotification(
        title:
            '${_pendingAction.toString().split('.').last.toUpperCase()} Successful',
        message:
            'Your transaction of ₦${amount.toStringAsFixed(0)} for $description was successful.',
        icon: icon,
      );
      return true;
    }

    return false;
  }

  /// Resolve the correct success screen from the type.
  Widget resolveSuccessScreen() {
    switch (_pendingAction) {
      case TransactionType.transfer:
        return TransferSuccessScreen(transaction: _payload ?? {});
      case TransactionType.billPayment:
        return BillPaymentSuccessScreen(transaction: _payload ?? {});
      case TransactionType.withdrawal:
        return WithdrawalSuccessScreen();
      case TransactionType.loanRepayment:
        return LoanRepaymentSuccessScreen(transaction: _payload ?? {});
      case TransactionType.airtimePurchase:
        return AirtimeSuccessScreen(transaction: _payload ?? {});
      case TransactionType.other:
      default:
        return const GenericSuccessScreen();
    }
  }
}

class WalletProvider extends ChangeNotifier {
  double _balance = 0.0;
  double get balance => _balance;

  bool _showBalance = true;
  bool get showBalance => _showBalance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream subscription to listen to live balance changes
  StreamSubscription<DocumentSnapshot>? _balanceSubscription;

  WalletProvider() {
    _init();
  }

  void _init() async {
    final prefs = await SharedPreferences.getInstance();
    _showBalance = prefs.getBool('show_balance') ?? true;
    notifyListeners();

    // Listen to auth state changes to start/stop listening to balance
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _startListeningToBalance(user.uid);
      } else {
        _stopListeningAndClear();
      }
    });
  }

  Future<void> toggleBalanceVisibility() async {
    _showBalance = !_showBalance;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('show_balance', _showBalance);
    notifyListeners();
  }

  void _startListeningToBalance(String uid) {
    _balanceSubscription?.cancel();
    _balanceSubscription = _firestore
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen(
          (snapshot) {
            if (snapshot.exists) {
              final data = snapshot.data();
              if (data != null && data.containsKey('balance')) {
                // Handle both int and double types safely
                final val = data['balance'];
                if (val is num) {
                  _balance = val.toDouble();
                } else {
                  _balance = 0.0;
                }
              } else {
                // If balance field doesn't exist, default to 0.0
                _balance = 0.0;
              }
              notifyListeners();
            }
          },
          onError: (e) {
            debugPrint("⚠️ Error listening to wallet balance: $e");
          },
        );
  }

  void _stopListeningAndClear() {
    _balanceSubscription?.cancel();
    _balanceSubscription = null;
    _balance = 0.0;
    notifyListeners();
  }

  /// Credit the user's wallet (Add money)
  Future<void> creditWallet(
    double amount, {
    String description = "Fund Wallet",
    String type = "credit",
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      final userRef = _firestore.collection('users').doc(uid);
      final txRef = userRef.collection('transactions').doc();

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);

        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }

        final currentBalance =
            (snapshot.data()?['balance'] as num?)?.toDouble() ?? 0.0;
        final newBalance = currentBalance + amount;

        // Update balance
        transaction.update(userRef, {'balance': newBalance});

        // Add transaction ledger entry
        transaction.set(txRef, {
          'amount': amount,
          'type': type, // 'credit' or 'debit'
          'description': description,
          'date': FieldValue.serverTimestamp(),
          'status': 'success',
          'reference': txRef.id,
        });
      });
      debugPrint("✅ Wallet credited: +$amount");
    } catch (e) {
      debugPrint("❌ Error crediting wallet: $e");
      rethrow;
    }
  }

  /// Debit the user's wallet (Subtract money)
  /// Returns transaction details map if successful, null if insufficient funds or error.
  Future<Map<String, dynamic>?> debitWallet(
    double amount, {
    String description = "Transaction",
    String type = "debit",
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;

    try {
      Map<String, dynamic>? transactionResult;
      final userRef = _firestore.collection('users').doc(uid);
      final txRef = userRef.collection('transactions').doc();
      final now = DateTime.now();

      await _firestore.runTransaction((transaction) async {
        final snapshot = await transaction.get(userRef);

        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }

        final currentBalance =
            (snapshot.data()?['balance'] as num?)?.toDouble() ?? 0.0;

        if (currentBalance < amount) {
          throw Exception("Insufficient funds");
        }

        final newBalance = currentBalance - amount;

        // Update balance
        transaction.update(userRef, {'balance': newBalance});

        // Add transaction ledger entry
        final txData = {
          'amount': amount,
          'type': type,
          'description': description,
          'date': Timestamp.fromDate(now),
          'status': 'success',
          'reference': txRef.id,
        };

        transaction.set(txRef, txData);
        transactionResult = txData;
      });

      debugPrint("✅ Wallet debited: -$amount");
      return transactionResult;
    } catch (e) {
      debugPrint("❌ Error debiting wallet: $e");
      return null;
    }
  }

  @override
  void dispose() {
    _balanceSubscription?.cancel();
    super.dispose();
  }
}

class NotificationProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> _notifications = [];
  StreamSubscription<QuerySnapshot>? _notifSubscription;

  NotificationProvider() {
    _init();
  }

  void _init() {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _startListeningToNotifications(user.uid);
      } else {
        _stopListeningAndClear();
      }
    });
  }

  void _startListeningToNotifications(String uid) {
    _notifSubscription?.cancel();
    _notifSubscription = _firestore
        .collection('users')
        .doc(uid)
        .collection('notifications')
        .orderBy('timestamp', descending: true)
        .limit(50)
        .snapshots()
        .listen((snapshot) {
          _notifications =
              snapshot.docs.map((doc) {
                final data = doc.data();
                return {
                  'id': doc.id,
                  'title': data['title'],
                  'message': data['message'],
                  'time': _formatTimestamp(data['timestamp']),
                  'icon': IconData(
                    data['iconCode'],
                    fontFamily: 'MaterialIcons',
                  ),
                  'isRead': data['isRead'] ?? false,
                };
              }).toList();
          notifyListeners();
        });
  }

  String _formatTimestamp(dynamic timestamp) {
    if (timestamp == null) return "now";
    if (timestamp is Timestamp) {
      final dt = timestamp.toDate();
      final diff = DateTime.now().difference(dt);
      if (diff.inMinutes < 1) return "just now";
      if (diff.inMinutes < 60) return "${diff.inMinutes}m ago";
      if (diff.inHours < 24) return "${diff.inHours}h ago";
      return "${dt.day}/${dt.month}/${dt.year}";
    }
    return "now";
  }

  void _stopListeningAndClear() {
    _notifSubscription?.cancel();
    _notifications = [];
    notifyListeners();
  }

  List<Map<String, dynamic>> get notifications => _notifications;

  int get unreadCount {
    return _notifications.where((n) => n['isRead'] == false).length;
  }

  Future<void> markAsRead(int index) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    if (index >= 0 && index < _notifications.length) {
      final notifId = _notifications[index]['id'];
      try {
        await _firestore
            .collection('users')
            .doc(uid)
            .collection('notifications')
            .doc(notifId)
            .update({'isRead': true});
      } catch (e) {
        debugPrint("❌ Error marking notification as read: $e");
      }
    }
  }

  Future<void> markAllAsRead() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final batch = _firestore.batch();
    final unreadNotifs = _notifications.where((n) => n['isRead'] == false);

    for (var notif in unreadNotifs) {
      final docRef = _firestore
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .doc(notif['id']);
      batch.update(docRef, {'isRead': true});
    }

    try {
      await batch.commit();
    } catch (e) {
      debugPrint("❌ Error marking all notifications as read: $e");
    }
  }

  Future<void> addNotification({
    required String title,
    required String message,
    required IconData icon,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('notifications')
          .add({
            'title': title,
            'message': message,
            'timestamp': FieldValue.serverTimestamp(),
            'iconCode': icon.codePoint,
            'isRead': false,
          });
    } catch (e) {
      debugPrint("❌ Error adding notification: $e");
    }
  }
}
