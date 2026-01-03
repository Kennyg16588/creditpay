import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:creditpay/models/beneficiary_model.dart';
import 'package:flutter/material.dart';

class BeneficiaryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Save a beneficiary to Firestore
  Future<bool> saveBeneficiary({
    required String accountName,
    required String accountNumber,
    required String bankName,
    required String bankCode,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('❌ No user logged in');
        return false;
      }

      // Check if beneficiary already exists
      final existingQuery =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('beneficiaries')
              .where('account_number', isEqualTo: accountNumber)
              .where('bank_code', isEqualTo: bankCode)
              .get();

      if (existingQuery.docs.isNotEmpty) {
        debugPrint('ℹ️ Beneficiary already exists');
        return true; // Already saved
      }

      // Save new beneficiary
      final beneficiary = Beneficiary(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        accountName: accountName,
        accountNumber: accountNumber,
        bankName: bankName,
        bankCode: bankCode,
        createdAt: DateTime.now(),
      );

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('beneficiaries')
          .doc(beneficiary.id)
          .set(beneficiary.toFirestore());

      debugPrint('✅ Beneficiary saved successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Error saving beneficiary: $e');
      return false;
    }
  }

  /// Get all beneficiaries for the current user
  Future<List<Beneficiary>> getBeneficiaries() async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('❌ No user logged in');
        return [];
      }

      final snapshot =
          await _firestore
              .collection('users')
              .doc(user.uid)
              .collection('beneficiaries')
              .orderBy('created_at', descending: true)
              .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Beneficiary.fromJson(data);
      }).toList();
    } catch (e) {
      debugPrint('❌ Error fetching beneficiaries: $e');
      return [];
    }
  }

  /// Delete a beneficiary
  Future<bool> deleteBeneficiary(String beneficiaryId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        debugPrint('❌ No user logged in');
        return false;
      }

      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('beneficiaries')
          .doc(beneficiaryId)
          .delete();

      debugPrint('✅ Beneficiary deleted successfully');
      return true;
    } catch (e) {
      debugPrint('❌ Error deleting beneficiary: $e');
      return false;
    }
  }
}
