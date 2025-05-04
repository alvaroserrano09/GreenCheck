import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GoogleService {
  Future<void> nativeGoogleSignIn(BuildContext context) async {
    if (!kIsWeb) {
      try {
        await dotenv.load(fileName: ".env");

        final webClientId = dotenv.env['WEB_CLIENT_ID']!;
        final iosClientId = dotenv.env['IOS_CLIENT_ID']!;

        final GoogleSignIn googleSignIn = GoogleSignIn(
          clientId: iosClientId,
          serverClientId: webClientId,
          signInOption: SignInOption.standard,
          forceCodeForRefreshToken: true,
        );

        final googleUser = await googleSignIn.signIn();
        if (googleUser == null) {
          throw 'Usuario canceló el inicio de sesión';
        }

        final googleAuth = await googleUser.authentication;
        final accessToken = googleAuth.accessToken;
        final idToken = googleAuth.idToken;

        if (accessToken == null) {
          throw 'No se encontró Access Token.';
        }
        if (idToken == null) {
          throw 'No se encontró ID Token.';
        }

        await Supabase.instance.client.auth.signInWithIdToken(
          provider: OAuthProvider.google,
          idToken: idToken,
          accessToken: accessToken,
        );
        context.go("/");
      } catch (e) {
        rethrow;
      }
    } else {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        queryParams: {
          'prompt': 'select_account',
        },
      );
    }
  }

  Future<void> signOut() async {
    try {
      await Supabase.instance.client.auth.signOut();

      final googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
      }
    } catch (e) {
      rethrow;
    }
  }
}
