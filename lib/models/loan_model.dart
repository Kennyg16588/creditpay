import 'package:cloud_firestore/cloud_firestore.dart';

enum LoanStatus { active, paid, overdue, pending }

class Loan {
  final String id;
  final String userId;
  final double amount;
  final double balance; // Amount left to pay
  final DateTime createdAt;
  final DateTime dueDate;
  final LoanStatus status;

  Loan({
    required this.id,
    required this.userId,
    required this.amount,
    required this.balance,
    required this.createdAt,
    required this.dueDate,
    required this.status,
  });

  factory Loan.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Loan(
      id: doc.id,
      userId: data['userId'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      balance: (data['balance'] ?? 0.0).toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      status: LoanStatus.values.firstWhere(
        (e) => e.toString() == 'LoanStatus.${data['status']}',
        orElse: () => LoanStatus.active,
      ),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'balance': balance,
      'createdAt': Timestamp.fromDate(createdAt),
      'dueDate': Timestamp.fromDate(dueDate),
      'status': status.toString().split('.').last,
    };
  }
}
