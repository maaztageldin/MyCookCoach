import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mycookcoach/config/consts.dart';
import 'package:mycookcoach/core/services/firebase_initializer.dart';
import 'package:mycookcoach/core/services/notifications_service/push_notification_service.dart';
import 'package:mycookcoach/core/utils/simple_bloc_observer.dart';

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseInitializer.initialize();
  final FirebaseApi firebaseApi = FirebaseApi();
  await firebaseApi.initPushNotifications();
  Stripe.publishableKey = stripePublishableKey;

  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  Bloc.observer = SimpleBlocObserver();
}
