import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:mycookcoach/core/services/notifications_service/send_mail_service.dart';
import 'package:mycookcoach/core/services/payment_service/stripe_service.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/authentication/data/repositories/firebase_user_repo.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/booking_entity.dart';
import 'package:mycookcoach/features/location_espace/domain/entities/kitchen_location_entity.dart';
import 'package:mycookcoach/features/location_espace/presentation/blocs/location_bloc/location_bloc.dart';
import 'package:mycookcoach/features/location_espace/presentation/blocs/location_bloc/location_event.dart';

class ReservationScreen extends StatefulWidget {
  final KitchenLocationEntity kitchen;

  const ReservationScreen({Key? key, required this.kitchen}) : super(key: key);

  @override
  _ReservationScreenState createState() => _ReservationScreenState();
}

class _ReservationScreenState extends State<ReservationScreen> {
  final String userId = FirebaseUserRepo().currentUser!.uid;
  DateTime? _selectedStartDate;
  DateTime? _selectedEndDate;
  int? _selectedPrice;

  bool _isLoading = false;

  final DateFormat dateFormatter = DateFormat('dd MMMM yyyy à HH:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Réserver cet espace',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "Sélectionnez une période disponible :",
              style: TextStyle(fontSize: 18, color: kTextLightColor),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.kitchen.availabilityPeriods.length,
              itemBuilder: (context, index) {
                final period = widget.kitchen.availabilityPeriods[index];
                final startDate = period['start_date'] as DateTime;
                final endDate = period['end_date'] as DateTime;
                final price = period['price'] as int;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedStartDate = startDate;
                      _selectedEndDate = endDate;
                      _selectedPrice = price;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: _selectedStartDate == startDate &&
                              _selectedEndDate == endDate
                          ? Colors.amber[100]
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "De ${dateFormatter.format(startDate)} au ${dateFormatter.format(endDate)}",
                          style: const TextStyle(
                            fontSize: 14,
                            color: kTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Prix: $price €",
                          style: TextStyle(
                            fontSize: 14,
                            color: kTextLightColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          _buildReserveButton(),
        ],
      ),
    );
  }

  Widget _buildReserveButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: _isLoading
          ? const CircularProgressIndicator(color: kMainColor,)
          : ElevatedButton(
              onPressed: (_selectedStartDate != null && _selectedEndDate != null)
                  ? () async {
                      setState(() {
                        _isLoading = true;
                      });

                      bool paymentSuccess =
                          await _processPayment(_selectedPrice!);

                      if (paymentSuccess) {
                        _createReservation();
                      }

                      setState(() {
                        _isLoading =
                            false;
                      });
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: kMainColor,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              child: Text(
                _selectedPrice != null
                    ? 'Payer $_selectedPrice€'.toUpperCase()
                    : 'Payer'.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
    );
  }

  Future<bool> _processPayment(int amount) async {
    try {
      bool paymentSuccess =
          await StripeService.instance.makePayment(context, amount);
      if (paymentSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Réservation effectuée avec succès!'),
            backgroundColor: kMainColor,
          ),
        );
        return true;
      } else {
        return false;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors du paiement: $e'),
          backgroundColor: kMainColor,
        ),
      );
      return false;
    }
  }

  void _createReservation() async {
    final booking = BookingEntity(
      kitchenId: widget.kitchen.id,
      userId: userId,
      localId: widget.kitchen.localId,
      startDate: _selectedStartDate!,
      endDate: _selectedEndDate!,
      price: _selectedPrice!,
      id: '',
    );

    context.read<LocationBloc>().add(BookKitchenEvent(booking));
    await _removeSelectedAvailabilityPeriod();

    Navigator.pop(context, booking);
  }

  Future<void> _removeSelectedAvailabilityPeriod() async {
    List<Map<String, dynamic>> updatedAvailabilityPeriods =
        widget.kitchen.availabilityPeriods.where((period) {
      DateTime startDate = period['start_date'] as DateTime;
      DateTime endDate = period['end_date'] as DateTime;

      return !(startDate == _selectedStartDate && endDate == _selectedEndDate);
    }).toList();

    try {
      await FirebaseFirestore.instance
          .collection('kitchens_to_book')
          .doc(widget.kitchen.id)
          .update({
        'availabilityPeriods': updatedAvailabilityPeriods,
      });

      setState(() {
        widget.kitchen.availabilityPeriods = updatedAvailabilityPeriods;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de la mise à jour des périodes: $e');
      }
    }
  }
}

