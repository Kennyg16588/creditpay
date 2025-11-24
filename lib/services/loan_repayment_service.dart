
class LoanRepaymentService {
  Future<bool> makeRepayment({
    required double amount,
    required String repaymentType,
    required String bankAccount,
  }) async {
    await Future.delayed(const Duration(seconds: 2)); // simulate network call
    return true;
  }
}
