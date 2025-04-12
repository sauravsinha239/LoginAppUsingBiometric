import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

final FirebaseAuth firebaseAuth =FirebaseAuth.instance;
User? currentUser;
final FlutterSecureStorage storage = FlutterSecureStorage();
//final localAuth = LocalAuthentication();
final LocalAuthentication localAuth = LocalAuthentication();
