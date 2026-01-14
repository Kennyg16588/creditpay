import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creditpay/constants/constants.dart';
import 'package:creditpay/providers/app_providers.dart';
import 'package:creditpay/screens/receipt_screen.dart';
import 'package:creditpay/services/remote_config_service.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, dynamic>> _actions = [
    {
      'icon': Icons.phone,
      'label': 'Airtime\n',
      'tooltip': 'Airtime',
      'route': '/airtime',
    },
    {
      'icon': Icons.data_usage,
      'label': 'Data\n',
      'tooltip': 'Data\n',
      'route': '/data',
    },
    {
      'icon': Icons.receipt_long,
      'label': 'Bills\n',
      'tooltip': 'Bills\n',
      'route': '/bill_payment',
    },

    {
      'icon': Icons.send,
      'label': 'Transfer\n',
      'tooltip': 'Transfer\n',
      'route': '/transfer',
    },
  ];

  void _showNotificationsBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
      ),
      builder: (context) => NotificationsBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Fixed top section (header + balance + actions)
            Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header (avatar + notification)
                  Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Row(
                      children: [
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, _) {
                            final photoUrl = authProvider.photo;
                            return GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/profile');
                              },
                              child: CircleAvatar(
                                backgroundColor: const Color(0XFF142B71),
                                radius: 25.r,
                                backgroundImage:
                                    photoUrl != null && photoUrl.isNotEmpty
                                        ? NetworkImage(photoUrl)
                                        : null,
                                child:
                                    photoUrl == null || photoUrl.isEmpty
                                        ? Icon(
                                          Icons.person,
                                          size: 25.sp,
                                          color: Colors.white,
                                        )
                                        : null,
                              ),
                            );
                          },
                        ),
                        SizedBox(width: 10.w),
                        Consumer<AuthProvider>(
                          builder: (context, authProvider, _) {
                            final firstName = authProvider.firstName ?? 'User';
                            return Text(
                              'Hi $firstName!',
                              style: Constants.kSignupTextstyle,
                            );
                          },
                        ),
                        const Spacer(),
                        Consumer<NotificationProvider>(
                          builder: (context, notifProvider, _) {
                            final unreadCount = notifProvider.unreadCount;
                            return GestureDetector(
                              onTap: _showNotificationsBottomSheet,
                              child: Stack(
                                children: [
                                  Icon(
                                    Icons.notifications,
                                    size: 30.sp,
                                    color: const Color(0XFF142B71),
                                  ),
                                  if (unreadCount > 0)
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.white,
                                            width: 0.1.w,
                                          ),
                                        ),
                                        padding: EdgeInsets.all(4.r),
                                        child: Text(
                                          unreadCount > 9
                                              ? '9+'
                                              : '$unreadCount',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  // Balance card
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                    child: Card(
                      color: const Color(0XFF142B71),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(20.w, 24.h, 20.w, 20.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total Balance',
                                  style: Constants.kloginbuttonsytle2,
                                ),
                                Consumer<WalletProvider>(
                                  builder: (context, walletProvider, _) {
                                    return IconButton(
                                      icon: Icon(
                                        walletProvider.showBalance
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: const Color(0xffA4BEFF),
                                        size: 24.sp,
                                      ),
                                      onPressed: () {
                                        walletProvider
                                            .toggleBalanceVisibility();
                                      },
                                    );
                                  },
                                ),
                              ],
                            ),
                            Consumer<WalletProvider>(
                              builder: (context, walletProvider, _) {
                                final balance = walletProvider.balance;
                                return Text(
                                  walletProvider.showBalance
                                      ? '₦${balance.toStringAsFixed(2)}'
                                      : '••••••',
                                  style: Constants.kloginTextstyle,
                                );
                              },
                            ),
                            SizedBox(height: 20.h),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 35.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffA4BEFF),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/loan_repay',
                                        );
                                      },
                                      child: Text(
                                        'Current Loan',
                                        style: Constants.kloanTextstyle,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Container(
                                    height: 35.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffA4BEFF),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/fund_wallet',
                                        );
                                      },
                                      child: Text(
                                        'Fund Wallet',
                                        style: Constants.kloanTextstyle,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // 🔥 NEW: Promotion Banner (controlled by Remote Config)
                  if (RemoteConfigService().showPromotionBanner)
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                      child: Container(
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF142B71), Color(0xFF4A90E2)],
                          ),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.celebration,
                              color: Colors.white,
                              size: 40.sp,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Special Offer!",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  Text(
                                    "Get 20% cashback on your first loan repayment.",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  if (RemoteConfigService().showPromotionBanner)
                    SizedBox(height: 20.h),

                  // Actions row
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(_actions.length, (index) {
                        final action = _actions[index];
                        return Column(
                          children: [
                            Container(
                              height: 45.h,
                              width: 45.w,
                              decoration: BoxDecoration(
                                color: const Color(0xffA4BEFF),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: IconButton(
                                icon: Icon(
                                  action['icon'],
                                  color: const Color(0XFF142B71),
                                ),
                                onPressed:
                                    () => Navigator.pushNamed(
                                      context,
                                      action['route'],
                                    ),
                                iconSize: 25.r,
                                tooltip: action['tooltip'],
                              ),
                            ),
                            SizedBox(height: 8.h),
                            SizedBox(
                              width: 70.w,
                              child: Text(
                                action['label'],
                                style: TextStyle(
                                  color: const Color(0XFF142B71),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: EdgeInsets.only(left: 30.w),
                    child: Text(
                      'Recent transactions',
                      style: Constants.kHomeTextstyle,
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable bottom section
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0.w),
                child: Consumer<TransactionProvider>(
                  builder: (context, txProvider, _) {
                    final transactions = txProvider.transactions;

                    if (transactions.isEmpty) {
                      return const Center(child: Text('No transactions yet'));
                    }

                    return ListView.separated(
                      padding: EdgeInsets.only(bottom: 20.h),
                      itemCount: transactions.length,
                      separatorBuilder: (_, __) => SizedBox(height: 12.h),
                      itemBuilder: (context, index) {
                        final tx = transactions[index];
                        final amount = tx['amount'] ?? 0.0;
                        final description = tx['description'] ?? 'Transaction';
                        final type = tx['type'] ?? 'debit';

                        String formatDate(dynamic date) {
                          if (date == null) return 'N/A';
                          DateTime dateTime;
                          if (date is Timestamp) {
                            dateTime = date.toDate();
                          } else if (date is String) {
                            dateTime =
                                DateTime.tryParse(date) ?? DateTime.now();
                          } else {
                            return 'N/A';
                          }
                          return DateFormat(
                            'MMM dd, yyyy  hh:mm a',
                          ).format(dateTime);
                        }

                        IconData icon = Icons.receipt_long;
                        if (type == 'credit') {
                          icon = Icons.account_balance_wallet;
                        } else if (description
                            .toString()
                            .toLowerCase()
                            .contains('transfer')) {
                          icon = Icons.send;
                        }

                        final isCredit = type == 'credit';
                        return Card(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          elevation: 2,
                          child: ListTile(
                            leading: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: const Color(0XFF142B71),
                              ),
                              height: 35.h,
                              width: 35.w,
                              child: Icon(icon, color: const Color(0xffA4BEFF)),
                            ),
                            title: Text(
                              description,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(formatDate(tx['date'])),
                            trailing: Text(
                              '${isCredit ? '+' : '-'}₦$amount',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                                color: isCredit ? Colors.green : Colors.red,
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

// 🔔 Notifications Bottom Sheet
class NotificationsBottomSheet extends StatelessWidget {
  const NotificationsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (context, notifProvider, _) {
        final notifications = notifProvider.notifications;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(16.r),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Notifications',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF142B71),
                      ),
                    ),
                    if (notifications.isNotEmpty)
                      TextButton.icon(
                        onPressed: () {
                          notifProvider.markAllAsRead();
                        },
                        icon: Icon(Icons.done_all, size: 18.sp),
                        label: const Text('Mark all read'),
                      ),
                  ],
                ),
              ),
              const Divider(),
              Expanded(
                child:
                    notifications.isEmpty
                        ? const Center(
                          child: Text(
                            'No notifications',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                        : ListView.separated(
                          itemCount: notifications.length,
                          separatorBuilder: (_, __) => Divider(height: 1.h),
                          itemBuilder: (context, index) {
                            final notif = notifications[index];
                            return ListTile(
                              leading: Container(
                                width: 48.w,
                                height: 48.h,
                                decoration: BoxDecoration(
                                  color:
                                      notif['isRead']
                                          ? Colors.grey[200]
                                          : const Color(
                                            0xFF142B71,
                                          ).withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  notif['icon'] as IconData,
                                  color: const Color(0xFF142B71),
                                ),
                              ),
                              title: Text(
                                notif['title'] as String,
                                style: TextStyle(
                                  fontWeight:
                                      notif['isRead']
                                          ? FontWeight.normal
                                          : FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(notif['message'] as String),
                              trailing: Text(
                                notif['time'] as String,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),
                              ),
                              onTap: () {
                                notifProvider.markAsRead(index);
                              },
                            );
                          },
                        ),
              ),
            ],
          ),
        );
      },
    );
  }
}
