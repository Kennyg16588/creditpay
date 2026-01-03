class Beneficiary {
  final String id;
  final String accountName;
  final String accountNumber;
  final String bankName;
  final String bankCode;
  final DateTime createdAt;

  Beneficiary({
    required this.id,
    required this.accountName,
    required this.accountNumber,
    required this.bankName,
    required this.bankCode,
    required this.createdAt,
  });

  factory Beneficiary.fromJson(Map<String, dynamic> json) {
    return Beneficiary(
      id: json['id'] ?? '',
      accountName: json['account_name'] ?? '',
      accountNumber: json['account_number'] ?? '',
      bankName: json['bank_name'] ?? '',
      bankCode: json['bank_code'] ?? '',
      createdAt:
          json['created_at'] != null
              ? DateTime.parse(json['created_at'])
              : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'account_name': accountName,
      'account_number': accountNumber,
      'bank_name': bankName,
      'bank_code': bankCode,
      'created_at': createdAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'account_name': accountName,
      'account_number': accountNumber,
      'bank_name': bankName,
      'bank_code': bankCode,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
