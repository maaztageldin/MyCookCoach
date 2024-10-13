import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mycookcoach/core/services/payment_service/enrollment_service.dart';
import 'package:mycookcoach/core/services/payment_service/stripe_service.dart';
import 'package:mycookcoach/core/utils/constents.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/domain/entities/formation_entity.dart';
import 'package:mycookcoach/features/Catalogue%20des%20prestations/presentation/pages/formation_screen/formation_details_screen.dart';
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
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _checkIfEnrolled();
    _initializeNotifications();
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

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          _navigateToDetails(context, response.payload!);
        }
      },
    );
  }


  Future<void> _showNotification(String title, String body, String formationId) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'formation_channel',
      'Notifications importantes',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: formationId,
    );
  }

  void _navigateToDetails(BuildContext context, String formationId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FormationDetailsScreen(formation: widget.formation),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.all(8.0),
        decoration: _cardDecoration(),
        child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                  padding: const EdgeInsets.all(10.0),
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
                  style:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(widget.formation.description),
                const SizedBox(height: 4.0),
                Text(
                  "Prix: ${widget.formation.price} €",
                  style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Text(
                  "Durée: ${widget.formation.duration}",
                  style:
                  const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    isEnrolled
                        ? const Text(
                      'Déjà inscrit',
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    )
                        : _isLoading
                        ? const CircularProgressIndicator(
                      color: kMainColor,
                    )
                        : TextButton(
                      onPressed: () async {
                        setState(() {
                          _isLoading = true;
                        });

                        bool paymentSuccess =
                        await StripeService.instance
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
                          await _showNotification(
                            "Inscription réussie",
                            "Vous êtes maintenant inscrit à ${widget.formation.title}.", widget.formation.id
                          );
                        }
                        setState(() {
                          _isLoading = false;
                        });
                      },
                      child: const Text(
                        'S\'inscrire',
                        style: TextStyle(
                          color: kMainColor,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
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
           // ),
         // ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
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
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
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
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                "Durée: ${widget.formation.duration}",
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}
