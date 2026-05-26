import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return android;
    }
    throw UnsupportedError('Platform tidak didukung');
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey:
        'AIzaSyCo-UTRHPNB8eRs95eBRZk_VY8FxcD_PGs', // Cek di google-services.json (api_key)
    appId:
        '1:288935293555:android:79034a1696111dc5c93006', // Cek di google-services.json (mobilesdk_app_id)
    messagingSenderId:
        '288935293555', // Cek di google-services.json (project_number)
    projectId: 'aira-soal',
    storageBucket: 'aira-soal.firebasestorage.app',
  );
}
