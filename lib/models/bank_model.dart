class Bank {
  final String name;
  final String code;
  final String slug;

  Bank({required this.name, required this.code, required this.slug});

  factory Bank.fromJson(Map<String, dynamic> json) {
    return Bank(
      name: json['name']?.toString() ?? '',
      code: json['code']?.toString() ?? '',
      slug: json['slug']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'code': code, 'slug': slug};
  }

  @override
  String toString() => name;
}

class AccountVerification {
  final String accountNumber;
  final String accountName;
  final String bankCode;

  AccountVerification({
    required this.accountNumber,
    required this.accountName,
    required this.bankCode,
  });

  factory AccountVerification.fromJson(Map<String, dynamic> json) {
    return AccountVerification(
      accountNumber: json['account_number']?.toString() ?? '',
      accountName: json['account_name']?.toString() ?? '',
      bankCode: json['bank_code']?.toString() ?? '',
    );
  }
}
