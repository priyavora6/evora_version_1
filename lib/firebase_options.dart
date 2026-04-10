// lib/firebase_options.dart
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web; // ✅ Updated to return web config
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
      apiKey: "AIzaSyCHB-2Qde78kQmDbRD1KD6L8vdbtXafGfM",
      authDomain: "online-voting-system-76856.firebaseapp.com",
      projectId: "online-voting-system-76856",
      storageBucket: "online-voting-system-76856.firebasestorage.app",
      messagingSenderId: "107763524926",
      appId: "1:107763524926:web:49cd23b80017f2670af86f",
      measurementId: "G-HQFTPBYTFH" // 👈 Optional, found in Console
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBXspeeVNj90BkT9AAe0jAH3kjGfrJWHpE',
    appId: '1:107763524926:android:17223d637827d4610af86f',
    messagingSenderId: '107763524926',
    projectId: 'online-voting-system-76856',
    storageBucket: 'online-voting-system-76856.firebasestorage.app',
  );
}