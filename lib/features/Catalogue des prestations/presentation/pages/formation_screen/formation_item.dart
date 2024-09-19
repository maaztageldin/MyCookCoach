import 'package:flutter/material.dart';
import 'package:mycookcoach/core/services/payment_service/enrollment_service.dart';
import 'package:mycookcoach/core/services/payment_service/stripe_service.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/formation_entity.dart';
import 'package:mycookcoach/features/authentication/domain/entities/user_entity.dart';

class FormationItem extends StatefulWidget {
  final FormationEntity formation;
  final UserEntity user;

  const FormationItem({
    Key? key,
    required this.formation,
    required this.user,
  }) : super(key: key);

  @override
  _FormationItemState createState() => _FormationItemState();
}

class _FormationItemState extends State<FormationItem> {
  bool isEnrolled = false;
  bool _isLoading = false;
  final EnrollmentService _enrollmentService = EnrollmentService();

  @override
  void initState() {
    super.initState();
    _checkIfEnrolled();
  }

  Future<void> _checkIfEnrolled() async {
    final enrolled = await _enrollmentService.checkIfEnrolled(
      widget.user.userId,
      widget.formation.id,
    );

    setState(() {
      isEnrolled = enrolled;
    });
  }

  @override
  Widget build(BuildContext context) {
    return /*Card(
      child:*/
        Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 250,
            width: 380,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: widget.formation.imageUrl.isNotEmpty
                    ? NetworkImage(widget.formation.imageUrl)
                    : AssetImage("assets/shop/images/chef_img.png")
                        as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            widget.formation.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4.0),
          Text(widget.formation.description),
          const SizedBox(height: 4.0),
          Text(
            "Prix: ${widget.formation.price} €",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4.0),
          Text(
            "Durée: ${widget.formation.duration}",
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4.0),
          Row(
            children: [
              isEnrolled
                  ? const Text('Déjà inscrit',
                      style: TextStyle(
                          color: kTextLightColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold))
                  : _isLoading
                      ? const CircularProgressIndicator(
                          color: kMainColor,
                        )
                      : TextButton(
                          onPressed: () async {
                            setState(() {
                              _isLoading = true;
                            });

                            bool paymentSuccess = await StripeService.instance
                                .enrollUserFormation(
                              context,
                              widget.user.userId,
                              widget.formation.id,
                              int.parse(widget.formation.price),
                            );
                            if (paymentSuccess) {
                              setState(() {
                                isEnrolled = true;
                              });
                            }
                            setState(() {
                              _isLoading = false;
                            });
                          },
                          child: const Text('S\'inscrire',
                              style: TextStyle(
                                color: kMainColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              )),
                        ),
              const Spacer(),
              TextButton(
                onPressed: () => _showFormationDetails(context),
                child: const Text(
                  'Détails',
                  style: TextStyle(
                      color: kMainColor,
                      fontSize: 14,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFormationDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.formation.title,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              if (widget.formation.imageUrl.isNotEmpty)
                Image.network(
                  widget.formation.imageUrl,
                  height: 200.0,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 8.0),
              Text(
                widget.formation.description,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8.0),
              Text(
                "Prix: ${widget.formation.price} €",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                "Durée: ${widget.formation.duration}",
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}
