import 'package:firebase_core/firebase_core.dart';

class FirebaseInitializer {
  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyBBZNQivC7ql6rH0S3qT97FNKvguVIsSiQ',
        appId: '1:474219284522:android:45ab0f0602b79fdfb39b53',
        messagingSenderId: '474219284522',
        projectId: 'mycookcoach',
        storageBucket: 'gs://mycookcoach.appspot.com',
      ),
    );
  }
}


