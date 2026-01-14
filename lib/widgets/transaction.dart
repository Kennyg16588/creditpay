import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:creditpay/constants/constants.dart';
import 'package:creditpay/providers/app_providers.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creditpay/screens/receipt_screen.dart';
import 'package:intl/intl.dart';

class Transaction extends StatelessWidget {
  const Transaction({super.key});

  String _formatDate(dynamic date) {
    if (date == null) return 'N/A';
    DateTime dateTime;
    if (date is Timestamp) {
      dateTime = date.toDate();
    } else if (date is String) {
      dateTime = DateTime.tryParse(date) ?? DateTime.now();
    } else {
      return 'N/A';
    }
    return DateFormat('MMM dd, yyyy  hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    final transactionProvider = Provider.of<TransactionProvider>(context);
    final recentTransactions = transactionProvider.transactions;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pushNamed(context, '/homepage'),
            icon: Icon(Icons.arrow_back_ios_new, size: 18.sp),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          foregroundColor: const Color(0xFF142B71),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: Row(
                children: [
                  Text(
                    'Transaction History',
                    style: Constants.kSignupTextstyle,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0.w),
              child: Container(
                height: 45.h,
                width: 115.w,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xffE0E0E0)),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Text('All', style: Constants.kSignupTextstyle),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_drop_down,
                        size: 32.sp,
                        color: const Color(0XFF142B71),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                child:
                    recentTransactions.isEmpty
                        ? const Center(child: Text("No transactions found"))
                        : ListView.builder(
                          itemCount: recentTransactions.length,
                          itemBuilder: (context, index) {
                            final tx = recentTransactions[index];
                            final amount = tx['amount'] ?? 0.0;
                            final type = tx['type'] ?? 'debit';
                            final color =
                                type == 'credit' ? Colors.green : Colors.red;
                            final prefix = type == 'credit' ? '+' : '-';

                            return Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                border: Border(
                                  bottom: BorderSide(color: Color(0xffA4BEFF)),
                                ),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                ),
                                title: Text(
                                  tx['account_name'] ??
                                      tx['description'] ??
                                      tx['title'] ??
                                      'Transaction',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(_formatDate(tx['date'])),
                                trailing: Text(
                                  "$prefix₦${amount.toStringAsFixed(2)}",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: color,
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              ReceiptScreen(transaction: tx),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
