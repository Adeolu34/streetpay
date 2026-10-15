import 'dart:async';

import 'custom_auth_user_provider.dart';

export 'custom_auth_manager.dart';

class CustomAuthManager {
  // Auth session attributes
  String? authenticationToken;
  String? refreshToken;
  DateTime? tokenExpiration;
  // User attributes
  String? uid;

  Future signOut() async {
    authenticationToken = null;
    refreshToken = null;
    tokenExpiration = null;
    uid = null;

    // Update the current user.
    streetpayAuthUserSubject.add(
      StreetpayAuthUser(loggedIn: false),
    );
  }

  Future<StreetpayAuthUser?> signIn({
    String? authenticationToken,
    String? refreshToken,
    DateTime? tokenExpiration,
    String? authUid,
  }) async =>
      await _updateCurrentUser(
        authenticationToken: authenticationToken,
        refreshToken: refreshToken,
        tokenExpiration: tokenExpiration,
        authUid: authUid,
      );

  Future<void> updateAuthUserData({
    String? authenticationToken,
    String? refreshToken,
    DateTime? tokenExpiration,
    String? authUid,
  }) async {
    assert(
      currentUser?.loggedIn ?? false,
      'User must be logged in to update auth user data.',
    );

    await _updateCurrentUser(
      authenticationToken: authenticationToken,
      refreshToken: refreshToken,
      tokenExpiration: tokenExpiration,
      authUid: authUid,
    );
  }

  Future<StreetpayAuthUser?> _updateCurrentUser({
    String? authenticationToken,
    String? refreshToken,
    DateTime? tokenExpiration,
    String? authUid,
  }) async {
    this.authenticationToken = authenticationToken;
    this.refreshToken = refreshToken;
    this.tokenExpiration = tokenExpiration;
    this.uid = authUid;

    // Update the current user stream.
    final updatedUser = StreetpayAuthUser(
      loggedIn: true,
      uid: authUid,
    );
    streetpayAuthUserSubject.add(updatedUser);

    return updatedUser;
  }
}

StreetpayAuthUser? currentUser;
bool get loggedIn => currentUser?.loggedIn ?? false;
