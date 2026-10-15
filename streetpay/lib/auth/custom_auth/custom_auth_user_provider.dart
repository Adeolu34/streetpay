import 'package:rxdart/rxdart.dart';

import 'custom_auth_manager.dart';

class StreetpayAuthUser {
  StreetpayAuthUser({required this.loggedIn, this.uid});

  bool loggedIn;
  String? uid;
}

/// Generates a stream of the authenticated user.
BehaviorSubject<StreetpayAuthUser> streetpayAuthUserSubject =
    BehaviorSubject.seeded(StreetpayAuthUser(loggedIn: false));
Stream<StreetpayAuthUser> streetpayAuthUserStream() => streetpayAuthUserSubject
    .asBroadcastStream()
    .map((user) => currentUser = user);
