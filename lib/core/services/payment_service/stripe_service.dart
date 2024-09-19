import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/enrollment_entity.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      HttpsCallable callable =
          FirebaseFunctions.instance.httpsCallable('createPaymentIntent');
      final result = await callable.call(<String, dynamic>{
        'amount': amount,
        'currency': currency,
      });
      return result.data['clientSecret'];
    } catch (e) {
      print("Error calling Firebase Function: $e");
      return null;
    }
  }

  Future<bool> enrollUserFormation(BuildContext context, String userId,
      String formationId, int amount) async {
    try {
      bool paymentSuccess = await makePayment(context, amount);

      if (paymentSuccess) {
        final enrollment = EnrollmentEntity(
          id: FirebaseFirestore.instance.collection('enrollments').doc().id,
          userId: userId,
          formationId: formationId,
          enrollmentDate: DateTime.now(),
        );

        await FirebaseFirestore.instance
            .collection('enrollments')
            .doc(enrollment.id)
            .set(enrollment.toDocument());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Inscription réussie!'),
            duration: Duration(seconds: 5),
          ),
        );
      }
      return paymentSuccess;
      //return false;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
    return false;
  }

  Future<bool> makePayment(BuildContext context, int amount) async {
    try {
      String? paymentIntentClientSecret =
          await _createPaymentIntent(amount * 100, "eur");
      if (paymentIntentClientSecret == null) return false;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "MyCookCoach",
        ),
      );

      return await _processPayment(context);
    } catch (e) {
      _showErrorDialog(context, "Le paiement a échoué. Veuillez réessayer.");
      return false;
    }
  }

  Future<bool> _processPayment(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet();
      return true;
    } catch (e) {
      _showErrorDialog(context, "Le paiement a échoué. Veuillez réessayer.");
      return false;
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Erreur"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
