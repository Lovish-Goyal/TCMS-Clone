import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logger/logger.dart';
import '../../shared/utils/logger.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  AuthNotifier({
    required FirebaseAuth auth,
    required GoogleSignIn googleSignIn,
    required FirebaseFirestore firestore,
  }) : _auth = auth,
       _googleSignIn = googleSignIn,
       _firestore = firestore,
       super(AuthInitial());

  Future<void> signInWithGoogle(String role) async {
    try {
      logger.i('Starting Google Sign In process');
      state = AuthLoading();

      await _googleSignIn.initialize();

      Logger().f("supportsAuthenticate? ${_googleSignIn.supportsAuthenticate}");

      if (_googleSignIn.supportsAuthenticate()) {
        Logger().f("yes");
        final googleUser = await _googleSignIn.authenticate();

        Logger().f(googleUser);

        // If user cancelled login
        if (googleUser == null) {
          return null;
        }

        final googleAuth = await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        final userCredential = await _auth.signInWithCredential(credential);
        final user = userCredential.user;

        if (user == null) {
          state = AuthError(message: 'Failed to sign in');
          return;
        }

        final userDocRef = _firestore.collection('teachers').doc(user.uid);
        final userData = await userDocRef.get();

        if (!userData.exists) {
          logger.i('New user detected - requiring registration');
          state = AuthRequiresRegistration(
            id: user.uid,
            email: user.email ?? '',
            name: user.displayName ?? '',
            phoneNumber: user.phoneNumber ?? '',
            photoUrl: user.photoURL ?? '',
            role: role,
            academyId: '',
            academyName: '',
            address: '',
          );
        } else {
          state = AuthAuthenticated(userData.data()!);
        }
      }
    } catch (e) {
      logger.e('Error during sign in process', error: e);
      state = AuthError(message: e.toString());
    }
  }

  Future<void> completeRegistration(
    String uid,
    Map<String, dynamic> userData,
  ) async {
    try {
      logger.i('Starting registration completion for user: $uid');
      await _firestore.collection('teachers').doc(uid).set(userData);
      final updatedDoc = await _firestore.collection('teachers').doc(uid).get();
      state = AuthAuthenticated(updatedDoc.data()!);
    } catch (e) {
      logger.e('Error during registration completion', error: e);
      state = AuthError(message: e.toString());
    }
  }

  Future<void> signOut() async {
    try {
      state = AuthLoading();
      await Future.wait([_auth.signOut(), _googleSignIn.signOut()]);
      state = AuthLoggedOut();
    } catch (e) {
      logger.e('Error during sign out', error: e);
      state = AuthError(message: e.toString());
    }
  }

  Future<void> checkAuthStatus() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final userData = await _firestore
            .collection('teachers')
            .doc(user.uid)
            .get();
        if (userData.exists) {
          state = AuthAuthenticated(userData.data()!);
        } else {
          state = AuthInitial();
        }
      } else {
        state = AuthInitial();
      }
    } catch (e) {
      logger.e('Error checking auth status', error: e);
      state = AuthError(message: e.toString());
    }
  }
}
