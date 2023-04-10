import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';


class AuthUser {
final String ?email;
 final bool isEmailVerified;

 const AuthUser(this.isEmailVerified,this.email);
 factory AuthUser.fromfirebase(User user)=>AuthUser(user.emailVerified,user.email);
}