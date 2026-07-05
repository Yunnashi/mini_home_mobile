import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:mini_home/environment/firebase_environment.dart';

extension FirebaseEnvironmentStaging on FirebaseEnvironment {
  static FirebaseEnvironment makeEnvironment() {
    const iosOptions = FirebaseOptions(
      apiKey: String.fromEnvironment('FIREBASE_IOS_API_KEY'),
      appId: String.fromEnvironment('FIREBASE_IOS_APP_ID'),
      messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
      projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
      storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
      iosClientId: String.fromEnvironment('FIREBASE_IOS_CLIENT_ID'),
      iosBundleId: String.fromEnvironment('FIREBASE_IOS_BUNDLE_ID'),
    );
    const androidOptions = FirebaseOptions(
      apiKey: String.fromEnvironment('FIREBASE_ANDROID_API_KEY'),
      appId: String.fromEnvironment('FIREBASE_ANDROID_APP_ID'),
      messagingSenderId: String.fromEnvironment('FIREBASE_MESSAGING_SENDER_ID'),
      projectId: String.fromEnvironment('FIREBASE_PROJECT_ID'),
      storageBucket: String.fromEnvironment('FIREBASE_STORAGE_BUCKET'),
    );
    return FirebaseEnvironment(iosOptions, androidOptions);
  }
}
