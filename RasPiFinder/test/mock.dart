import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:firebase_auth_platform_interface/src/method_channel/method_channel_firebase_auth.dart';
import 'package:cloud_firestore_platform_interface/src/method_channel/method_channel_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

typedef Callback(MethodCall call);

setupFirebaseAuthMocks([Callback customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelFirebase.channel.setMockMethodCallHandler((call) async {
    if (call.method == 'Firebase#initializeCore') {
      return [
        {
          'name': defaultFirebaseAppName,
          'options': {
            'apiKey': '123',
            'appId': '123',
            'messagingSenderId': '123',
            'projectId': '123',
          },
          'pluginConstants': {},
        }
      ];
    }

    if (call.method == 'Firebase#initializeApp') {
      return {
        'name': call.arguments['appName'],
        'options': call.arguments['options'],
        'pluginConstants': {},
      };
    }

    if (customHandlers != null) {
      customHandlers(call);
    }

    return null;
  });

  MethodChannelFirebaseAuth.channel
      .setMockMethodCallHandler((MethodCall call) async {
    if (call.method == 'Auth#registerChangeListeners') {
      return {'uid': '123456', 'email': 'foo@bar'};
    }

    if (call.method == 'Auth#signInWithEmailAndPassword' ||
        call.method == 'Auth#createUserWithEmailAndPassword') {
      return {
        'user': {
          'email': call.arguments['email'],
          'uid': '123456',
        }
      };
    }

    if (call.method == 'Auth#signInAnonymously') {
      return {
        'user': {
          'email': 'anon@ymous',
          'uid': '123456',
        }
      };
    }

    if (customHandlers != null) {
      customHandlers(call);
    }

    return null;
  });

  MethodChannelFirebaseFirestore.channel
      .setMockMethodCallHandler((MethodCall call) async {
    if (call.method == 'DocumentReference#set') {
      print(call.arguments);
      return {
        'data': {
          'email': call.arguments['email'],
          'phoneNumber': call.arguments['phoneNumber'],
          'uid': '123456',
          'username': call.arguments['username'],
        }
      };
    }
    if (customHandlers != null) {
      customHandlers(call);
    }
    return null;
  });
}
