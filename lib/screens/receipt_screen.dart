import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReceiptScreen extends StatelessWidget {
  final Map<String, dynamic> transaction;

  const ReceiptScreen({super.key, required this.transaction});

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
    dynamic rawAmount = transaction['amount'];
    double amount = 0.0;
    if (rawAmount is num) {
      amount = rawAmount.toDouble();
    } else if (rawAmount is String) {
      amount = double.tryParse(rawAmount) ?? 0.0;
    }
    final type = transaction['type'] ?? 'debit';
    final description =
        transaction['description'] ??
        transaction['title'] ??
        transaction['account_name'] ??
        'Transaction';
    final reference = transaction['reference'] ?? 'N/A';
    final status = transaction['status'] ?? 'Success';
    final date = _formatDate(transaction['date']);

    final isCredit = type == 'credit';
    final amountColor = isCredit ? Colors.green : Colors.red;
    final prefix = isCredit ? '+' : '-';

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          backgroundColor: Colors.grey[100],
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.close,
              color: const Color(0xFF142B71),
              size: 24.sp,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Transaction Receipt',
            style: TextStyle(
              color: const Color(0xFF142B71),
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),
              Container(
                padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 60.sp),
                    SizedBox(height: 16.h),
                    Text(
                      'Transaction Successful',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF142B71),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      '$prefix₦${amount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: amountColor,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 30.h),
                    const Divider(),
                    SizedBox(height: 20.h),
                    _buildRow('Transaction Type', type.toUpperCase()),
                    SizedBox(height: 16.h),
                    _buildRow('Description', description),
                    SizedBox(height: 16.h),
                    _buildRow('Reference', reference),
                    SizedBox(height: 16.h),
                    _buildRow('Status', status.toUpperCase()),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Share receipt logic could go here
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share Receipt'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF142B71),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    textStyle: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
        SizedBox(width: 20.w),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF142B71),
            ),
          ),
        ),
      ],
    );
  }
}
