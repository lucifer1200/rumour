import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rumour/services/index.dart';
import 'package:rumour/firebase_options.dart';

// Firebase initialization
final firebaseProvider = FutureProvider<void>((ref) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await LocalStorageService.init();
});

// Firestore service
final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

// Random User service
final randomUserServiceProvider = Provider<RandomUserService>((ref) {
  return RandomUserService();
});

// Local Storage service
final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});
