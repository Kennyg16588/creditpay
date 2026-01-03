import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:creditpay/constants/constants.dart';
import 'package:creditpay/providers/app_providers.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final List<Map<String, dynamic>> _actions = [
    {
      'icon': Icons.request_page,
      'label': 'Loan\nRequest',
      'tooltip': 'Loan\nRequest',
      'route': '/loan',
    },
    {
      'icon': Icons.receipt_long,
      'label': 'Bills\nPayment',
      'tooltip': 'Bills\n Payment',
      'route': '/bill_payment',
    },
    {
      'icon': Icons.money_off,
      'label': 'Withdraw\n',
      'tooltip': 'Withdraw\n',
      'route': '/withdraw',
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header (avatar + notification)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
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
                                radius: 35,
                                backgroundImage:
                                    photoUrl != null && photoUrl.isNotEmpty
                                        ? NetworkImage(photoUrl)
                                        : null,
                                child:
                                    photoUrl == null || photoUrl.isEmpty
                                        ? Icon(
                                          Icons.person,
                                          size: 50.sp,
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
                                    size: 40.sp,
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
                                            width: 2.w,
                                          ),
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: Text(
                                          unreadCount > 9
                                              ? '9+'
                                              : '$unreadCount',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10.sp,
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
                                    height: 44.h,
                                    decoration: BoxDecoration(
                                      color: const Color(0xffA4BEFF),
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        'Current Loan',
                                        style: Constants.kHomeTextstyle,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Container(
                                    height: 44.h,
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
                                        style: Constants.kHomeTextstyle,
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
                              height: 55.9.h,
                              width: 55.9.w,
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
                                iconSize: 32.r,
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
                  SizedBox(height: 20.h),
                  Padding(
                    padding: const EdgeInsets.only(left: 50.0),
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

                        String dateStr = 'Just now';
                        if (tx['date'] != null && tx['date'] is Timestamp) {
                          final dt = (tx['date'] as Timestamp).toDate();
                          dateStr =
                              "${dt.day}/${dt.month}/${dt.year}   ${dt.hour}:${dt.minute}";
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
                              height: 50.h,
                              width: 50.w,
                              child: Icon(icon, color: const Color(0xffA4BEFF)),
                            ),
                            title: Text(
                              description,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(dateStr),
                            trailing: Text(
                              '${isCredit ? '+' : '-'}₦$amount',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: isCredit ? Colors.green : Colors.red,
                              ),
                            ),
                            onTap: () {},
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
