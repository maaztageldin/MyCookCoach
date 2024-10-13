import 'package:flutter/material.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const PreferredSize(
              preferredSize: Size.fromHeight(30),
              child: Center(
                child: Text(
                  'Notifications',
                  style: TextStyle(color: Colors.black),
                ),
              )),
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: const Center(child: Text("vous n'avez pas de notifications")));
  }
}
