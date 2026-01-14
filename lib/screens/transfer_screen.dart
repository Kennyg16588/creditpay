import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:creditpay/screens/confirm_pin_screen.dart';
import 'package:provider/provider.dart';
import 'package:creditpay/providers/app_providers.dart';
import 'package:creditpay/services/paystack_service.dart';
import 'package:creditpay/models/bank_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:creditpay/services/beneficiary_service.dart';
import 'package:creditpay/models/beneficiary_model.dart';
import 'dart:async';

class TransferScreen extends StatefulWidget {
  const TransferScreen({super.key});

  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final TextEditingController _amountCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  final TextEditingController _accountNumberCtrl = TextEditingController();

  final PaystackService _paystackService = PaystackService();
  final BeneficiaryService _beneficiaryService = BeneficiaryService();

  List<Bank> _banks = [];
  Bank? _selectedBank;
  String? _verifiedAccountName;
  bool _isLoadingBanks = true;
  bool _isVerifying = false;
  bool _saveBeneficiary = false;

  List<Beneficiary> _beneficiaries = [];

  Timer? _debounceTimer;
  String?
  _lastVerifiedAccount; // Track last verified account to prevent duplicates

  @override
  void initState() {
    super.initState();
    _fetchBanks();
    _fetchBeneficiaries();
    _accountNumberCtrl.addListener(_onAccountNumberChanged);
  }

  Future<void> _fetchBeneficiaries() async {
    final list = await _beneficiaryService.getBeneficiaries();
    if (mounted) {
      setState(() {
        _beneficiaries = list;
      });
    }
  }

  Future<void> _fetchBanks() async {
    setState(() => _isLoadingBanks = true);
    final banks = await _paystackService.getBanks();
    setState(() {
      _banks = banks;
      _isLoadingBanks = false;
    });
  }

  void _onAccountNumberChanged() {
    // Cancel previous timer
    _debounceTimer?.cancel();

    // Clear verified name if account number changes
    if (_verifiedAccountName != null) {
      setState(() => _verifiedAccountName = null);
    }

    // Auto-verify when account number is 10 digits with debouncing
    if (_accountNumberCtrl.text.length == 10 && _selectedBank != null) {
      // Wait 1.5s after user stops typing to avoid 429 Rate Limits
      _debounceTimer = Timer(const Duration(milliseconds: 1500), () {
        _verifyAccount();
      });
    }
  }

  Future<void> _verifyAccount() async {
    if (_selectedBank == null || _accountNumberCtrl.text.length != 10) {
      return;
    }

    // specific key for this verification attempt
    final currentKey = '${_selectedBank!.code}-${_accountNumberCtrl.text}';

    // Prevent duplicate verification for the same details
    if (_lastVerifiedAccount == currentKey && _verifiedAccountName != null) {
      return;
    }

    setState(() => _isVerifying = true);

    try {
      final verification = await _paystackService.verifyAccountNumber(
        accountNumber: _accountNumberCtrl.text,
        bankCode: _selectedBank!.code,
      );

      if (!mounted) return;

      setState(() {
        _isVerifying = false;
        _verifiedAccountName = verification?.accountName;
        if (verification != null) {
          _lastVerifiedAccount = currentKey;
        }
      });

      if (verification != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('✅ Account verified: ${verification.accountName}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isVerifying = false;
        _verifiedAccountName = null;
        _lastVerifiedAccount = null;
      });

      // Extract message from exception
      final errorMessage = e.toString().replaceAll('Exception:', '').trim();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ $errorMessage'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  void _onSelectBeneficiary(Beneficiary beneficiary) {
    _accountNumberCtrl.text = beneficiary.accountNumber;

    // Find matching bank
    try {
      final bank = _banks.firstWhere(
        (b) => b.code == beneficiary.bankCode,
        orElse:
            () => _banks.firstWhere(
              (b) => b.name.toLowerCase() == beneficiary.bankName.toLowerCase(),
            ),
      );
      setState(() {
        _selectedBank = bank;
        _verifiedAccountName = beneficiary.accountName;
      });
    } catch (e) {
      // Bank not found in list (maybe new list doesn't have it)
      // Just set prompt to manually select
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bank information updated, please re-select bank'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _amountCtrl.dispose();
    _descCtrl.dispose();
    _accountNumberCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Select Transfer Option'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Where',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF142B71),
                ),
              ),
              Text(
                'To Send',
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF142B71),
                ),
              ),
              SizedBox(height: 20.h),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF142B71),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance,
                      color: Colors.white,
                      size: 26.sp,
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Other Banks',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30.h),

              SizedBox(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDADADA),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (_beneficiaries.isNotEmpty) ...[
                        Text(
                          "Saved Beneficiaries",
                          style: TextStyle(
                            color: const Color(0xFF142B71),
                            fontWeight: FontWeight.w600,
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),
                        SizedBox(
                          height: 90.h,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: _beneficiaries.length,
                            separatorBuilder: (_, __) => SizedBox(width: 10.w),
                            itemBuilder: (context, index) {
                              final b = _beneficiaries[index];
                              return GestureDetector(
                                onTap: () => _onSelectBeneficiary(b),
                                child: Container(
                                  width: 80.w,
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8.r),
                                    border: Border.all(
                                      color: const Color(
                                        0xFF142B71,
                                      ).withOpacity(0.2),
                                    ),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        radius: 18.r,
                                        backgroundColor: const Color(
                                          0xFF142B71,
                                        ).withOpacity(0.1),
                                        child: Text(
                                          b.accountName.isNotEmpty
                                              ? b.accountName[0].toUpperCase()
                                              : '?',
                                          style: TextStyle(
                                            color: const Color(0xFF142B71),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.sp,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5.h),
                                      Text(
                                        b.accountName
                                            .split(' ')
                                            .first, // First name only
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(fontSize: 10.sp),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 20.h),
                      ],

                      SizedBox(height: 10.h),
                      Text(
                        'Enter Amount',
                        style: TextStyle(
                          color: Color(0xFF142B71),
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(height: 10.h),

                      // 💰 Amount Field
                      TextField(
                        controller: _amountCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          prefixIcon: Container(
                            width: 50.w,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(8.r),
                                bottomLeft: Radius.circular(8.r),
                              ),
                              // border: Border.all(color: Color(0xffB3B3B3)),
                              color: Color(0xFF142B71),
                            ),
                            child: Text(
                              '₦',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          hintText: 'Enter amount',
                          filled: true,
                          fillColor: Color(0xFFDADADA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),

                      // 🏦 Select Bank Dropdown
                      DropdownSearch<Bank>(
                        enabled: !_isLoadingBanks,
                        items: _banks,
                        selectedItem: _selectedBank,
                        itemAsString: (Bank bank) => bank.name,
                        dropdownDecoratorProps: DropDownDecoratorProps(
                          dropdownSearchDecoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.account_balance,
                              color: Color(0xFF142B71),
                            ),
                            filled: true,
                            fillColor: const Color(0xFFDADADA),
                            hintText:
                                _isLoadingBanks
                                    ? 'Loading banks...'
                                    : 'Select Bank',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                        popupProps: PopupProps.menu(
                          showSearchBox: true,
                          searchFieldProps: TextFieldProps(
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              hintText: 'Search bank...',
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ),
                          menuProps: MenuProps(
                            backgroundColor: Colors.white,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          itemBuilder: (context, bank, isSelected) {
                            return ListTile(
                              title: Text(
                                bank.name,
                                style: TextStyle(
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                              selected: isSelected,
                            );
                          },
                        ),
                        onChanged: (Bank? value) {
                          setState(() {
                            _selectedBank = value;
                            _verifiedAccountName = null;
                          });
                          // Trigger verification if account number is already entered
                          if (_accountNumberCtrl.text.length == 10) {
                            _verifyAccount();
                          }
                        },
                      ),
                      SizedBox(height: 15.h),

                      // 🔢 Account Number
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _accountNumberCtrl,
                            builder: (context, value, child) {
                              return TextField(
                                controller: _accountNumberCtrl,
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                decoration: InputDecoration(
                                  hintText: 'Account Number',
                                  filled: true,
                                  fillColor: Color(0xFFDADADA),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  counterText: '',
                                  suffixIcon:
                                      _isVerifying
                                          ? Padding(
                                            padding: EdgeInsets.all(12.0),
                                            child: SizedBox(
                                              width: 20.w,
                                              height: 20.h,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                          )
                                          : _verifiedAccountName != null
                                          ? const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          )
                                          : (value.text.length == 10 &&
                                              _selectedBank != null)
                                          ? TextButton(
                                            onPressed: _verifyAccount,
                                            child: Text(
                                              'Verify',
                                              style: TextStyle(
                                                color: Color(0xFF142B71),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.sp,
                                              ),
                                            ),
                                          )
                                          : null,
                                ),
                              );
                            },
                          ),
                          if (_verifiedAccountName != null) ...[
                            SizedBox(height: 8.h),
                            Container(
                              padding: EdgeInsets.all(12.w),
                              decoration: BoxDecoration(
                                color: Colors.green.shade50,
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(
                                  color: Colors.green.shade200,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.account_circle,
                                    color: Colors.green.shade700,
                                    size: 20.sp,
                                  ),
                                  SizedBox(width: 8.w),
                                  Expanded(
                                    child: Text(
                                      _verifiedAccountName!,
                                      style: TextStyle(
                                        color: Colors.green.shade700,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: 15.h),

                      // 📝 Description
                      TextField(
                        controller: _descCtrl,
                        decoration: InputDecoration(
                          hintText: 'Description',
                          filled: true,
                          fillColor: Color(0xFFDADADA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                      SizedBox(height: 15.h),

                      // 💾 Save Beneficiary Toggle
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Save Beneficiary',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF142B71),
                            ),
                          ),
                          Switch(
                            value: _saveBeneficiary,
                            onChanged: (value) {
                              setState(() => _saveBeneficiary = value);
                            },
                            activeColor: const Color(0xFF142B71),
                          ),
                        ],
                      ),
                      SizedBox(height: 25.h),

                      // ✅ Verify Button
                      SizedBox(
                        width: double.infinity,
                        height: 50.h,
                        child: ElevatedButton(
                          onPressed: () {
                            final amountText = _amountCtrl.text.trim();
                            final desc = _descCtrl.text.trim();
                            final accountNumber =
                                _accountNumberCtrl.text.trim();

                            if (amountText.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter an amount'),
                                ),
                              );
                              return;
                            }

                            if (_selectedBank == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please select a bank'),
                                ),
                              );
                              return;
                            }

                            if (accountNumber.isEmpty ||
                                accountNumber.length != 10) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please enter a valid 10-digit account number',
                                  ),
                                ),
                              );
                              return;
                            }

                            if (_verifiedAccountName == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Please wait for account verification',
                                  ),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                              return;
                            }

                            // Save beneficiary if toggle is on
                            if (_saveBeneficiary) {
                              _beneficiaryService.saveBeneficiary(
                                accountName: _verifiedAccountName!,
                                accountNumber: accountNumber,
                                bankName: _selectedBank!.name,
                                bankCode: _selectedBank!.code,
                              );
                            }

                            Provider.of<TransactionFlowProvider>(
                              context,
                              listen: false,
                            ).setPendingAction(
                              TransactionType.transfer,
                              payload: {
                                'amount': amountText,
                                'description':
                                    "Transfer to ${_verifiedAccountName!}",
                                'bank_name': _selectedBank!.name,
                                'bank_code': _selectedBank!.code,
                                'account_number': accountNumber,
                                'account_name': _verifiedAccountName!,
                              },
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ConfirmPinScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFD602),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                          child: Text(
                            'Verify',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF142B71),
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
        ),
      ),
    );
  }
}
